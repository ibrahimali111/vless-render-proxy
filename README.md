# VLESS WebSocket Proxy for Render

A standalone, production-ready VLESS WebSocket proxy server running the official 64-bit [Xray-core](https://github.com/XTLS/Xray-core) inside a lightweight Alpine Linux Docker container, tailored for zero-cost deployment on [Render.com](https://render.com).

---

## Features

- **Lightweight & Fast**: Built on Alpine Linux with the latest official release of Xray-core.
- **WebSocket Transport**: Fully compatible with Cloudflare CDN, reverse proxies, and Render HTTP/WebSocket edge routing.
- **Render Ready**: Automatically binds to `$PORT` (Render default: `10000`) and serves traffic over Render's automatic TLS on port `443`.
- **Customizable**: Set your own client `UUID` and WebSocket `WSPATH` using environment variables.

---

## Project Structure

```
.
├── Dockerfile        # Alpine image with Xray-core and dependencies
├── entrypoint.sh     # Dynamic config generator and container entrypoint
├── .gitignore        # Standard Git ignore rules
└── README.md         # Deployment and client configuration documentation
```

---

## 1. How to Push This Repository to GitHub

> **Security Note:** You **never** need to share your GitHub login or password with anyone. You can push this project securely from your computer directly using the steps below.

### Step 1: Create a New Repository on GitHub
1. Log into your account at [github.com](https://github.com).
2. Click the **`+`** icon in the top right corner and choose **New repository**.
3. Name your repository (for example: `render-vless-proxy`).
4. Set visibility to **Public** or **Private**.
5. Do **not** check "Initialize this repository with a README" (we already have one).
6. Click **Create repository**.

### Step 2: Push Your Local Code
Open your terminal in this workspace folder (`/home/millo/Documents/github pro`) and run:

```bash
# 1. Initialize local Git repository (if not already done)
git init

# 2. Add all files to staging
git add .

# 3. Create your initial commit
git commit -m "feat: initial commit for VLESS WebSocket proxy on Render"

# 4. Set default branch to main
git branch -M main

# 5. Link to your newly created GitHub repository
# (Replace YOUR_GITHUB_USERNAME and YOUR_REPO_NAME with your details)
git remote add origin https://github.com/YOUR_GITHUB_USERNAME/YOUR_REPO_NAME.git

# 6. Push code to GitHub
git push -u origin main
```

*(If prompted by Git, enter your GitHub username and a [Personal Access Token](https://github.com/settings/tokens) as your password).*

---

## 2. Deploying on Render.com

Follow these step-by-step instructions to deploy your proxy:

1. **Sign in to Render**:
   - Go to [dashboard.render.com](https://dashboard.render.com/) and log in (or sign up using your GitHub account).
2. **Create a New Web Service**:
   - In your Render dashboard, click **New +** and select **Web Service**.
   - Select **Build and deploy from a Git repository** and connect your GitHub account.
   - Choose the repository you just pushed (e.g., `render-vless-proxy`).
3. **Configure Service Settings**:
   - **Name**: Choose a unique service name (e.g., `my-vless-node`).
   - **Region**: Select **Frankfurt (EU Central)** (or your preferred region).
   - **Branch**: `main`
   - **Runtime**: Select **Docker**.
   - **Instance Type**: Select **Free**.
4. **Configure Environment Variables**:
   Scroll down to the **Environment Variables** section and click **Add Environment Variable**:

   | Key | Value | Description |
   |---|---|---|
   | `UUID` | `de04add9-5c68-8bab-950c-08cd5320df18` *(or your custom UUID)* | Client authentication ID |
   | `WSPATH` | `/vless-ws` *(or your custom path like `/mysecretpath`)* | WebSocket route path |

   *(Note: Render automatically supplies `PORT=10000`, so you do not need to manually configure `PORT` unless you want to override it).*
5. **Deploy**:
   - Click **Create Web Service**.
   - Render will automatically pull the Dockerfile, download Xray-core, build the container, and launch your server.
   - Once deployment completes, your service status will show **Live** and provide an assigned public URL, for example: `https://my-vless-node.onrender.com`.

---

## 3. Environment Variables Reference

| Variable | Default Value | Required | Description |
|---|---|---|---|
| `UUID` | `de04add9-5c68-8bab-950c-08cd5320df18` | Optional | User identifier for VLESS client authentication. Generate a fresh UUID using `uuidgen` or [uuidgenerator.net](https://www.uuidgenerator.net/). |
| `WSPATH` | `/vless-ws` | Optional | WebSocket path that incoming connections must match. Must start with `/`. |
| `PORT` | `10000` | Optional | Listening port inside the container. Handled automatically by Render. |

---

## 4. Client Configuration Guide

Render terminates TLS at its edge, so your client must connect with **Port 443** and **TLS Enabled**.

### Core Connection Parameters

- **Protocol**: `VLESS`
- **Address (Server / Host)**: `<your-service-name>.onrender.com` *(no `https://`, just domain)*
- **Port**: `443`
- **User ID / UUID**: Your configured `UUID`
- **Encryption**: `none`
- **Transport / Network**: `ws` (WebSocket)
- **Path**: Your configured `WSPATH` (e.g., `/vless-ws`)
- **Host / SNI**: `<your-service-name>.onrender.com`
- **TLS / Security**: `TLS` enabled (allow standard certificate verification)
- **Flow**: Leave blank / none

---

### Configuration by Client App

#### A. v2rayN (Windows)
1. Open v2rayN.
2. Click **Servers** -> **Add VLESS Server**.
3. Fill in:
   - **Address**: `<your-service-name>.onrender.com`
   - **Port**: `443`
   - **User ID (id)**: `<YOUR_UUID>`
   - **Flow**: *(leave empty)*
   - **Encryption**: `none`
   - **Network**: `ws`
4. Under **Transport Settings (ws)**:
   - **path**: `/vless-ws`
   - **Host**: `<your-service-name>.onrender.com`
5. Under **TLS**:
   - **streamSecurity**: `tls`
   - **SNI**: `<your-service-name>.onrender.com`
6. Save and set as active server.

#### B. NekoBox (Android / Windows)
1. Tap **+** to add a new profile.
2. Select **Type**: **VLESS**.
3. Enter Server: `<your-service-name>.onrender.com`, Port: `443`.
4. UUID: `<YOUR_UUID>`.
5. Under **Network**:
   - Network: `WebSocket`
   - Path: `/vless-ws`
   - Host: `<your-service-name>.onrender.com`
6. Under **Security**:
   - Security: `TLS`
   - SNI: `<your-service-name>.onrender.com`
7. Save and connect.

#### C. Quick Import via VLESS Link (URL Format)

You can copy and import the following URI into v2rayN, NekoBox, Sing-box, or Shadowrocket by replacing the placeholders:

```text
vless://YOUR_UUID@YOUR_SERVICE_NAME.onrender.com:443?encryption=none&security=tls&sni=YOUR_SERVICE_NAME.onrender.com&type=ws&host=YOUR_SERVICE_NAME.onrender.com&path=%2Fvless-ws#Render-VLESS
```
