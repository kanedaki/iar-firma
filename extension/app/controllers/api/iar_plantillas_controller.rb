# frozen_string_literal: true

# Extensión de IA para retail sobre DocuSeal 3.3.6 (AGPL-3.0, como DocuSeal; el «Powered by DocuSeal» se queda).
# POST /api/iar/plantillas {nombre, referencia, pdf: base64} con la clave de la API (X-Auth-Token): crea una
# plantilla con nuestro PDF, igual que la subida de la web (TemplatesUploadsController#create), y devuelve
# {id, documentos: [{uuid}]}. Los campos y el envío van después por la API normal (PUT /api/templates/{id} y
# POST /api/submissions). No escribe nada en el registro.
module Api
  class IarPlantillasController < ApiBaseController
    MAXIMO = 10.megabytes

    def create
      nombre = params.require(:nombre).to_s.first(200)
      referencia = params[:referencia].to_s.first(100).presence
      datos = Base64.strict_decode64(params.require(:pdf).to_s)

      return render(json: { error: 'demasiado grande' }, status: :content_too_large) if datos.bytesize > MAXIMO
      return render(json: { error: 'no es un PDF' }, status: :unprocessable_content) unless datos.start_with?('%PDF-')

      plantilla = Template.new(account: current_account, author: current_user, name: nombre,
                               external_id: referencia, source: :api)
      authorize!(:create, plantilla)
      plantilla.folder = TemplateFolders.find_or_create_by_name(current_user, 'iar')
      Templates.maybe_assign_access(plantilla)
      plantilla.save!

      temporal = Tempfile.new(['contrato', '.pdf'])
      temporal.binmode
      temporal.write(datos)
      temporal.rewind
      fichero = ActionDispatch::Http::UploadedFile.new(tempfile: temporal, filename: "#{nombre.parameterize}.pdf",
                                                       type: 'application/pdf')

      documentos, = Templates::CreateAttachments.call(plantilla, { files: [fichero] })
      plantilla.update!(schema: documentos.map { |d| { attachment_uuid: d.uuid, name: nombre } })

      render json: { id: plantilla.id, documentos: documentos.map { |d| { uuid: d.uuid } } }
    rescue ArgumentError
      render json: { error: 'el pdf no va en base64' }, status: :unprocessable_content
    ensure
      temporal&.close!
    end
  end
end
