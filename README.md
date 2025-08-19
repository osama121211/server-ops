# Affiliate Automation — Starter

This repo contains the starter files to automate affiliate product import to WordPress using n8n.

Files included:
- docker-compose.n8n.yml : n8n docker-compose baseline
- n8n_workflow.json : n8n workflow (import feed -> OpenAI -> create WP draft)
- wp-plugin/affiliate-automation.php : WordPress plugin to accept REST create requests and provide admin settings.

Next steps for you:
1. Add server deploy key to the repo (Settings → Deploy keys).
2. Tell me the repo name (owner/repo). I will push these files.
3. On your server:
   - Start n8n: cd /opt/n8n && docker-compose up -d
   - Change N8N_BASIC_AUTH_PASSWORD in /opt/n8n/docker-compose.yml to a strong password.
   - Configure reverse proxy in aaPanel to expose n8n at a secure URL (recommended).
4. I will then configure the n8n workflow and show you how to add API keys (OpenAI, Amazon PA, AliExpress feed).