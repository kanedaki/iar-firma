# Firma de IA para retail

Es el programa con el que firmas el contrato en `firma.iapararetail.com`: [DocuSeal](https://github.com/docusealco/docuseal) 3.3.6, sin cambios, más una extensión pequeña nuestra.

## Qué cambia la extensión

Añade una sola ruta, `POST /api/iar/plantillas`, que pide la clave de la API. Crea una plantilla con nuestro PDF, igual que la subida desde la web de DocuSeal, y devuelve `{id, documentos: [{uuid}]}`. Los campos y el envío para firmar van por la API normal de DocuSeal. No escribe nada en el registro.

Son dos ficheros:

- `extension/app/controllers/api/iar_plantillas_controller.rb`: la ruta;
- `extension/config/initializers/iar_rutas.rb`: la da de alta.

## Cómo se construye

`Dockerfile` parte de la imagen oficial `docuseal/docuseal:3.3.6`, fijada por su digest, y copia los dos ficheros. En Railway: `railway up firma --service firma`.

## Licencia

[AGPL-3.0](https://www.gnu.org/licenses/agpl-3.0.html), como DocuSeal, con las condiciones añadidas de DocuSeal (su `LICENSE_ADDITIONAL_TERMS`). El «Powered by DocuSeal» de la página de firma se queda.
