# ZeroClaw Docker Sandbox

This workspace contains a custom Docker Compose setup for ZeroClaw. The container has been configured specifically for 16GB RAM development environments and comes with `git` and `bru` (Bruno CLI) pre-installed for executing tests and repository management.

## 1. Start the Environment

```bash
# Start the container in the background
docker compose up -d
```

## 2. Authenticate with ChatGPT (OpenAI Codex)

You can link your ChatGPT Plus/Pro subscription instead of paying per-token by using ZeroClaw's OAuth integration.

Execute the following command to begin the OAuth flow:

```bash
docker exec -it zeroclaw zeroclaw auth login --provider openai-codex --device-code
```

> **Note:** If you receive a "403 Forbidden" (Cloudflare) error during the device-code flow, the CLI will automatically output a URL for a browser-based login fallback.
>
> 1. Open the provided `https://auth.openai.com/...` URL in your browser.
> 2. Log in and authorize the application. 
> 3. Your browser will be redirected to a `localhost` URL that fails to load (this is expected).
> 4. **Copy the entire URL** from your browser's address bar.
> 5. Run the following command, replacing `"YOUR_PASTED_URL_HERE"` with the URL you copied:
> 
> ```bash
> docker exec -it zeroclaw zeroclaw auth paste-redirect --provider openai-codex --profile default --input "YOUR_PASTED_URL_HERE"
> ```

## 3. Interact with the Agent

Once authenticated, start a session with the AI assistant:

```bash
# Start an interactive chat session using the ChatGPT subscription
# (The agent is pre-configured to use gpt-5.3-codex for this provider)
docker exec -it zeroclaw zeroclaw agent
```

## Advanced Settings

The configuration is stored in `./data/.zeroclaw/config.toml`. Currently, it uses:
- **Provider:** `openai-codex`
- **Model:** `gpt-5.3-codex`
- **Workspace:** `/workspace` (Restricted access)
- **Tools:** `git`, `bru` (Bruno CLI)

The configuration is mounted directly from `./data/config.toml`. The `[autonomy]` block has `workspace_only = true` set to prevent the AI from interacting with files outside of this immediate directory.

To provide Bruno skills, look into defining a skill inside a `skills/` folder that utilizes the `bru run` command against your OpenAPI spec.
