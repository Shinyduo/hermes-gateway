# Hermes Agent gateway — backend for the Hermes WebUI template.
#
# The upstream image is built on s6-overlay, so the ENTRYPOINT
# (/init -> docker/main-wrapper.sh) MUST be preserved. We only set CMD.
# main-wrapper.sh turns these args into `hermes gateway run`, which starts
# the gateway daemon plus, when API_SERVER_ENABLED=true, the OpenAI-compatible
# API server on port 8642 that the WebUI consumes over private networking.
FROM nousresearch/hermes-agent:latest

CMD ["gateway", "run"]
