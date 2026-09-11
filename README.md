# VLESS WebSocket Proxy for Render

<p align="center">
  <a href="https://github.com/ibrahimali111/vless-render-proxy/actions/workflows/docker-build.yml">
    <img src="https://github.com/ibrahimali111/vless-render-proxy/actions/workflows/docker-build.yml/badge.svg" alt="Docker CI" />
  </a>
  <a href="https://github.com/ibrahimali111/vless-render-proxy/blob/main/LICENSE">
    <img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License: MIT" />
  </a>
  <img src="https://img.shields.io/badge/docker-ready-2496ED?logo=docker&logoColor=white" alt="Docker Ready" />
  <img src="https://img.shields.io/badge/platform-Render.com-46E3B7?logo=render&logoColor=white" alt="Render Ready" />
</p>

A standalone, production-ready VLESS WebSocket proxy server running the official 64-bit [Xray-core](https://github.com/XTLS/Xray-core) inside a lightweight Alpine Linux Docker container, tailored for zero-cost deployment on [Render.com](https://render.com).

---

## ⚡ 1-Click Deploy to Render

Deploy directly to your Render account with pre-configured settings:

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/ibrahimali111/vless-render-proxy)

---

## Features

- **Lightweight & Fast**: Built on Alpine Linux with the latest official release of Xray-core.
- **WebSocket Transport**: Fully compatible with Cloudflare CDN, reverse proxies, and Render HTTP/WebSocket edge routing.
- **Render Ready**: Automatically binds to `$PORT` (Render default: `10000`) and serves traffic over Render's automatic TLS on port `443`.
- **Customizable**: Set your own client `UUID` and WebSocket `WSPATH` using environment variables.
- **Automated CI**: Built-in GitHub Actions testing workflow.

---

## Project Structure

```
.
├── Dockerfile                  # Alpine image with Xray-core and dependencies
├── entrypoint.sh               # Dynamic config generator and container entrypoint
├── render.yaml                 # 1-Click Render blueprint configuration
├── .github/
│   └── workflows/
│       └── docker-build.yml    # Continuous Integration Docker build tests
├── LICENSE                     # MIT Open Source License
├── .gitignore                  # Standard Git ignore rules
└── README.md                   # Complete documentation
```

---

## Manual Deployment on Render.com

If you prefer to configure the Web Service manually:

1. **Sign in to Render**:
   - Go to [dashboard.render.com](https://dashboard.render.com/) and log in with your GitHub account.
2. **Create a New Web Service**:
   - In your Render dashboard, click **New +** and select **Web Service**.
   - Select **Build and deploy from a Git repository**.
   - Choose `vless-render-proxy`.
3. **Configure Service Settings**:
   - **Name**: Choose a unique service name (e.g., `my-vless-service`).
   - **Region**: Select **Frankfurt (EU Central)** (or your preferred region).
   - **Branch**: `main`
   - **Runtime**: Select **Docker**.
   - **Instance Type**: Select **Free** ($0 / month).
4. **Configure Environment Variables**:
   Click **Add Environment Variable**:

   | Key | Value | Description |
   |---|---|---|
   | `UUID` | `de04add9-5c68-8bab-950c-08cd5320df18` *(or your custom UUID)* | Client authentication ID |
   | `WSPATH` | `/vless-ws` *(or custom path like `/app-stream`)* | WebSocket route path |

5. **Deploy**:
   - Click **Deploy Web Service**.
   - When the build finishes, status will turn **Live** and provide your URL (e.g., `https://my-vless-service.onrender.com`).

---

## Environment Variables Reference

| Variable | Default Value | Required | Description |
|---|---|---|---|
| `UUID` | `de04add9-5c68-8bab-950c-08cd5320df18` | Optional | User identifier for VLESS authentication. |
| `WSPATH` | `/vless-ws` | Optional | WebSocket path (must start with `/`). |
| `PORT` | `10000` | Optional | Port inside container (handled automatically by Render). |

---

## Client Configuration Guide

Render terminates TLS at its edge, so your client connects with **Port 443** and **TLS Enabled**.

### Core Connection Parameters

- **Protocol**: `VLESS`
- **Address (Server / Host)**: `<your-service-name>.onrender.com`
- **Port**: `443`
- **User ID / UUID**: Your configured `UUID`
- **Encryption**: `none`
- **Transport / Network**: `ws` (WebSocket)
- **Path**: Your configured `WSPATH` (e.g., `/vless-ws`)
- **Host / SNI**: `<your-service-name>.onrender.com`
- **TLS / Security**: `TLS` enabled
- **Flow**: Leave blank / none

---

### Configuration by Client App

#### A. v2rayN (Windows)
1. Open v2rayN &rarr; **Servers** &rarr; **Add VLESS Server**.
2. **Address**: `<your-service-name>.onrender.com`
3. **Port**: `443`
4. **User ID (id)**: `<YOUR_UUID>`
5. **Encryption**: `none`, **Network**: `ws`
6. Under **Transport Settings (ws)**:
   - **path**: `/vless-ws` (or your custom path)
   - **Host**: `<your-service-name>.onrender.com`
7. Under **TLS**:
   - **streamSecurity**: `tls`
   - **SNI**: `<your-service-name>.onrender.com`
8. Save and connect.

#### B. NekoBox (Android / Windows)
1. Tap **+** &rarr; **Type**: **VLESS**.
2. **Server**: `<your-service-name>.onrender.com`, **Port**: `443`.
3. **UUID**: `<YOUR_UUID>`.
4. Under **Network**:
   - **Network**: `WebSocket`
   - **Path**: `/vless-ws`
   - **Host**: `<your-service-name>.onrender.com`
5. Under **Security**:
   - **Security**: `TLS`
   - **SNI**: `<your-service-name>.onrender.com`
6. Save and connect.

#### C. Quick Import Link (URI)

```text
vless://YOUR_UUID@YOUR_SERVICE_NAME.onrender.com:443?encryption=none&security=tls&sni=YOUR_SERVICE_NAME.onrender.com&type=ws&host=YOUR_SERVICE_NAME.onrender.com&path=%2Fvless-ws#Render-VLESS
```

---

## License

This project is licensed under the [MIT License](LICENSE).
