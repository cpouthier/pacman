# 🎮 Pacman Helm Chart — Step-by-Step Custom Deployment Guide

This guide explains **step by step** how to download the Pacman Helm chart, customize its MongoDB image, and deploy it safely on Kubernetes.

The goal here is to **override the MongoDB container image** to use `bitnamilegacy/mongodb` while keeping the official Helm chart structure intact.

---

## 🧠 What You Will Do

✔ Add the Pacman Helm repository  
✔ Download the chart locally for modification  
✔ Override MongoDB image settings  
✔ Verify the rendered manifests  
✔ Deploy Pacman with custom values  

---

## 📦 Step 1 — Add the Pacman Helm Repository

📡 This tells Helm where to find the Pacman chart.

```bash
helm repo add pacman https://shuguet.github.io/pacman/
helm repo update
```

---

## 📥 Step 2 — Download the Chart Locally

📂 We pull the chart locally so it can be customized safely.

```bash
helm pull pacman/pacman --untar
```

This creates a local directory:

```
pacman/
├── Chart.yaml
├── values.yaml
├── templates/
└── charts/
```

---

## ✏️ Step 3 — Create a Custom values Override File

🛠 We override **only** what we need: the MongoDB image source.

Create a file named `values-override.yaml`:

```bash
cat > values-override.yaml <<'EOF'
mongodb:
  image:
    registry: docker.io
    repository: bitnamilegacy/mongodb
    tag: 7.0.7-debian-12-r0
EOF
```

### 🔍 Why this works
- The Bitnami MongoDB chart exposes `mongodb.image.*` as configurable values
- We change the **Docker image**, not the Helm repository
- This keeps the chart upgrade-safe and maintainable

---

## 🔎 Step 4 — Verify the Rendered Kubernetes Manifests

🧪 Before installing anything, always inspect what Helm will generate.

```bash
helm template pacman . -f values-override.yaml | grep -i "bitnami"
```

### ✅ Expected Output

You should see lines similar to:

```
image: docker.io/bitnamilegacy/mongodb:7.0.7-debian-12-r0
```

If you see `bitnami/mongodb`, your override is not applied correctly.

---

## 🚀 Step 5 — Install Pacman with Custom Values

📦 Now deploy Pacman using your overridden configuration.

```bash
helm upgrade --install pacman . \
  -n pacman \
  --create-namespace \
  -f values-override.yaml
```

This will:
- Create the `pacman` namespace (if needed)
- Deploy Pacman and MongoDB
- Use the **legacy MongoDB image**

---

## 🔍 Optional — Verify the Running Pod Image

```bash
kubectl -n pacman get pods -l app.kubernetes.io/name=mongodb \
  -o jsonpath='{.items[0].spec.containers[0].image}'
```

Expected result:

```
docker.io/bitnamilegacy/mongodb:7.0.7-debian-12-r0
```

---

## ❌ Common Mistakes to Avoid

🚫 Do NOT change `dependencies.repository` to `bitnamilegacy`  
🚫 Do NOT modify templates directly  
🚫 Do NOT install from `pacman/pacman` after local changes  

✔ Always install from the **local chart directory**

---

## 🧩 Key Takeaway

> **Helm chart repository ≠ Docker image repository**

- `Chart.yaml` → where Helm downloads charts
- `values.yaml` → which container images Kubernetes runs

You changed the **right thing**.

---

## ✅ Summary

✔ Local chart download  
✔ Clean image override  
✔ Verified rendering  
✔ Safe and reproducible deployment  

Happy Helming 🚀
