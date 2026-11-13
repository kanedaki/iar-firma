# frozen_string_literal: true

# Extensión de IA para retail sobre DocuSeal (AGPL-3.0). Añade una sola ruta de la API.
Rails.application.routes.prepend do
  namespace :api, defaults: { format: :json } do
    post 'iar/plantillas', to: 'iar_plantillas#create'
  end
end
