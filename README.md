# Hermes Gateway (Railway)

Backend service for the [Hermes WebUI](https://github.com/Shinyduo/hermes-webui) Railway template.

Runs [Hermes Agent](https://hermes-agent.nousresearch.com) in `gateway run` mode and
exposes its OpenAI-compatible API server on port `8642` over Railway private
networking. The Hermes WebUI service connects to it as its chat backend.

## Required variables

| Variable | Value | Notes |
| --- | --- | --- |
| `API_SERVER_ENABLED` | `true` | Activates the OpenAI-compatible API server |
| `API_SERVER_HOST` | `0.0.0.0` | Bind all interfaces (required for private networking) |
| `API_SERVER_PORT` | `8642` | API server port |
| `API_SERVER_KEY` | `${{secret(64)}}` | Bearer token; the WebUI must use the same value |
| `ANTHROPIC_API_KEY` *or* `OPENAI_API_KEY` | _your key_ | LLM provider — required for the agent to respond |
| `HERMES_HOME` | `/home/hermes/.hermes` | State directory (attach a volume here) |

Attach a volume at `/home/hermes/.hermes` to persist config, sessions, skills, and memory.

The API server is intentionally **not** given a public domain — it is reached only
by the WebUI service via `hermes-gateway.railway.internal:8642`.
