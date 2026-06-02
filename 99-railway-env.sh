#!/command/with-contenv sh
# Railway: persist the OpenAI-compatible API server configuration into
# ~/.hermes/.env before the gateway starts.
#
# Hermes Agent's documented way to enable the API server is via ~/.hermes/.env
# (see https://hermes-agent.nousresearch.com/docs/user-guide/features/api-server).
# Relying on process env alone is version-dependent, so we write the config to
# the .env file that `hermes gateway run` loads at startup. cont-init.d runs
# before the container CMD (the gateway), so the values are in place in time.
set -e

ENVFILE="${HERMES_HOME:-/home/hermes/.hermes}/.env"
mkdir -p "$(dirname "$ENVFILE")"
touch "$ENVFILE"

for var in API_SERVER_ENABLED API_SERVER_HOST API_SERVER_PORT API_SERVER_KEY API_SERVER_CORS_ORIGINS; do
  eval "val=\"\${$var:-}\""
  [ -z "$val" ] && continue
  # Replace any existing definition, then append the current value.
  grep -v "^${var}=" "$ENVFILE" > "${ENVFILE}.tmp" 2>/dev/null || true
  mv -f "${ENVFILE}.tmp" "$ENVFILE" 2>/dev/null || true
  printf '%s=%s\n' "$var" "$val" >> "$ENVFILE"
done

# cont-init.d runs as root; the gateway runs as the unprivileged `hermes`
# user, so the .env must be owned by and readable to hermes.
chown hermes:hermes "$ENVFILE" 2>/dev/null || true
chmod 600 "$ENVFILE" 2>/dev/null || true
echo "[railway-env] wrote API_SERVER_* config to $ENVFILE (owner hermes)"
