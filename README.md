# ZeroClaw Docker Setup (Telegram & ChatGPT Subscription Ready) 🦀🚀

This repository contains a full-featured, containerized environment for **ZeroClaw v0.1.7**, optimized for systems with 16GB RAM. It integrates **Telegram** as a communication channel and is pre-configured to use **ChatGPT Plus/Pro subscriptions** via OpenAI Codex.

## 🌟 Key Features
- **ZeroClaw v0.1.7**: The latest stable runtime for fast AI assistance.
- **ChatGPT Subscription Support**: Uses `openai-codex` so you don't pay per-token.
- **Telegram Integration**: Chat with your agent from anywhere.
- **Security First**: 
  - Restricted to your workspace directory.
  - Locked down to specific Telegram IDs (`allowed_users`).
  - `.gitignore` configured to keep your tokens/auth private.
- **Built-in Tools**: `git` and `bruno CLI` (`bru`) pre-installed for agent use.
- **High Stability**: Pre-tuned with `gpt-5.2-codex` and advanced exponential backoff to handle ChatGPT rate limits (503/429 errors).

---

## 🛠️ Prerequisites
- [Docker](https://docs.docker.com/get-docker/) installed.
- A **Telegram Bot Token** from [@BotFather](https://t.me/botfather).
- An active **ChatGPT Plus/Pro** subscription.

---

## 🚀 Quick Start

### 1. Build and Start
```bash
docker compose up -d --build
```

### 2. Authenticate ChatGPT (OAuth)
ZeroClaw uses a secure OAuth flow. Run the following and follow the CLI instructions:
```bash
docker exec -it zeroclaw zeroclaw auth login --provider openai-codex --device-code
```
*Note: If Cloudflare blocks the device code, use the browser-redirect flow as prompted by the CLI.*

### 3. Connect Telegram
Your `config.toml` is located at `./data/.zeroclaw/config.toml`. Open it and update your Telegram settings:

```toml
[channels_config.telegram]
bot_token = "YOUR_BOT_TOKEN_HERE"
allowed_users = ["YOUR_TELEGRAM_ID", "YOUR_USERNAME"]
```
*To find your ID, message [@userinfobot](https://t.me/userinfobot) on Telegram.*

Restart the agent to apply:
```bash
docker compose restart zeroclaw
```

---

## 🔧 Stability & Reliability

The ChatGPT Codex bridge can occasionally return `503 Service Unavailable` or `429 Too Many Requests`. This setup is hardened against these errors with the following in `config.toml`:

- **Model:** Switched to `gpt-5.2-codex` (the industry-standard stable fallback).
- **Reliability Block:**
  ```toml
  [reliability]
  provider_retries = 5
  provider_backoff_ms = 5000
  ```
  This ensures the agent pauses and retries automatically instead of failing.

---

## 📁 Project Structure
- `Dockerfile`: Customizable ZeroClaw image with system tools.
- `docker-compose.yml`: Resource-limited (1GB RAM cap) service definition.
- `data/`: **(Ignored by Git)** Stores your authentication profiles, memory, and sensitive bot config.
- `workspace/`: This folder is mounted into the container as `/workspace`. Put your code here for the agent to work on.

---

## 🐞 Troubleshooting

### "Telegram Polling Conflict (409)"
Make sure only **one** instance of this bot is running. If you used the token in a Python script or another bot, kill that process first, then restart the container.

### "Empty Queue / No Response"
If your bot isn't replying, try resetting the Telegram polling state:
```bash
docker compose stop zeroclaw
curl -s -X POST "https://api.telegram.org/bot<TOKEN>/deleteWebhook?drop_pending_updates=true"
docker compose start zeroclaw
```

---

## 📜 Contributing
Feel free to fork and adapt this setup for your own agentic workflows.
