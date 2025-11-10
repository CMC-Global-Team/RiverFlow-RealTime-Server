# 🔧 Troubleshooting Guide

## ❌ Error: "Failed to save API keys"

### Nguyên nhân có thể:

1. **Vercel KV chưa được connect đến project**
2. **Environment variables chưa được set**
3. **KV chưa được deploy/redeploy**

---

## ✅ Solution: Kiểm tra Vercel KV Setup

### Bước 1: Verify KV Connection

1. Vào https://vercel.com/dashboard
2. Click **Storage** tab
3. Chọn KV database của bạn
4. Click tab **".env.local"**
5. Scroll xuống phần **"Connect Project"**
6. Verify project **RiverFlow-SMTP-Server** đã được connect
7. Verify environments: **Production**, **Preview**, **Development** đều được check

### Bước 2: Verify Environment Variables

1. Vào project **RiverFlow-SMTP-Server** trên Vercel
2. Click **Settings** → **Environment Variables**
3. Kiểm tra các biến sau đã có:

```
✅ KV_REST_API_URL
✅ KV_REST_API_TOKEN
✅ KV_REST_API_READ_ONLY_TOKEN
✅ KV_URL
```

**Nếu thiếu:**
- Quay lại KV dashboard
- Click "Connect Project" lại
- Chọn project và environments
- Click "Connect"

### Bước 3: Redeploy

Sau khi verify KV connection:

1. Vào **Deployments** tab
2. Click **...** menu trên deployment mới nhất
3. Click **Redeploy**
4. Đợi deployment hoàn tất (1-2 phút)

### Bước 4: Check Logs

Sau khi redeploy, check logs:

1. Vào **Deployments** → Latest deployment
2. Click vào deployment
3. Click **Functions** tab
4. Xem logs để tìm:
   - `✅ Vercel KV initialized successfully`
   - Hoặc error messages

---

## 🔍 Debug Commands

### Check KV Environment Variables

```bash
# Trong Vercel Dashboard → Project Settings → Environment Variables
# Verify các biến sau:

KV_REST_API_URL=https://...
KV_REST_API_TOKEN=...
KV_REST_API_READ_ONLY_TOKEN=...
KV_URL=redis://...
```

### Test KV Connection (Local)

```bash
# Install Vercel CLI
npm i -g vercel

# Login
vercel login

# Link project
vercel link

# Pull environment variables
vercel env pull .env.local

# Check .env.local file
cat .env.local | grep KV_
```

---

## 🚨 Common Issues

### Issue 1: "Vercel KV not configured"

**Solution:**
- KV chưa được connect đến project
- Follow **Bước 1** ở trên

### Issue 2: "KV_REST_API_URL is not defined"

**Solution:**
- Environment variables chưa được set
- Follow **Bước 2** ở trên
- Redeploy sau khi set

### Issue 3: Keys không persist sau khi tạo

**Solution:**
- KV connection có vấn đề
- Check logs trong Vercel
- Verify KV database status trong Storage dashboard

### Issue 4: "Failed to initialize Vercel KV"

**Solution:**
1. Check `@vercel/kv` package đã được install
2. Verify package.json có dependency
3. Redeploy project

---

## 📊 Verify KV is Working

### Test 1: Check Logs

Sau khi tạo API key, check logs trong Vercel:

```
✅ Vercel KV initialized successfully
Loading API keys from Vercel KV...
✅ Loaded 0 API keys from Vercel KV
Saving 1 API keys to Vercel KV...
✅ API keys saved to Vercel KV successfully
```

### Test 2: List Keys

```bash
curl https://river-flow-smtp-server.vercel.app/api/keys \
  -H "X-Master-Key: master-riverflow-smtp-key-2024"
```

Nếu thấy keys list, KV đang hoạt động!

### Test 3: Check KV Dashboard

1. Vào Storage → Your KV
2. Click **Data Browser**
3. Tìm key: `riverflow:api-keys`
4. Verify có data

---

## 🔄 Complete Reset (Nếu vẫn lỗi)

### Option 1: Reconnect KV

1. Vào KV dashboard
2. Disconnect project
3. Connect lại project
4. Redeploy

### Option 2: Create New KV

1. Tạo KV database mới
2. Connect đến project
3. Redeploy
4. Test lại

---

## 📞 Still Having Issues?

1. **Check Vercel Status**: https://vercel-status.com
2. **Check KV Documentation**: https://vercel.com/docs/storage/vercel-kv
3. **Review Logs**: Vercel Dashboard → Deployments → Logs
4. **Check Error Messages**: Logs sẽ show chi tiết lỗi

---

## ✅ Success Indicators

Khi setup đúng, bạn sẽ thấy:

- ✅ Environment variables có đầy đủ KV_*
- ✅ Logs show "Vercel KV initialized successfully"
- ✅ API key creation trả về key value
- ✅ Keys persist sau khi tạo
- ✅ List keys endpoint hoạt động

