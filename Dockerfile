FROM docuseal/docuseal:3.3.6@sha256:df78e750ec0df42c121225875714487998048c9c80f412c1d5a0b9290887ba5c
# Extensión de IA para retail (AGPL-3.0, como DocuSeal): una ruta para crear una plantilla con un PDF nuestro.
COPY extension/app/controllers/api/iar_plantillas_controller.rb /app/app/controllers/api/iar_plantillas_controller.rb
COPY extension/config/initializers/iar_rutas.rb /app/config/initializers/iar_rutas.rb
