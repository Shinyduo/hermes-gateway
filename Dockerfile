# Hermes Agent gateway — backend for the Hermes WebUI template.
#
# The upstream image is built on s6-overlay, so the ENTRYPOINT
# (/init -> docker/main-wrapper.sh) MUST be preserved. We only set CMD.
# main-wrapper.sh turns these args into `hermes gateway run`, which runs as
# /init's main program (the s6 "main-hermes" service is a deliberate no-op).
# With the API server enabled, `gateway run` also serves the OpenAI-compatible
# API on port 8642 that the WebUI consumes over Railway private networking.
#
# 99-railway-env.sh (a cont-init.d hook that runs before the gateway) writes
# the API_SERVER_* configuration into ~/.hermes/.env, which is the documented,
# version-independent way to enable the API server.
FROM nousresearch/hermes-agent:latest

COPY 99-railway-env.sh /etc/cont-init.d/99-railway-env.sh
RUN chmod +x /etc/cont-init.d/99-railway-env.sh

CMD ["gateway", "run"]
