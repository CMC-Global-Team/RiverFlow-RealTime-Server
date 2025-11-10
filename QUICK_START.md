# 🚀 Quick Start - Tạo API Key Mới

## 📋 Prerequisites

✅ Vercel KV đã được setup  
✅ Master API Key đã được thêm vào Vercel Environment Variables  
✅ SMTP Server đã được deploy  

---

## 🔑 Cách 1: Sử dụng cURL (Recommended)

### Tạo API Key cơ bản:

```bash
curl -X POST https://river-flow-smtp-server.vercel.app/api/keys \
  -H "Content-Type: application/json" \
  -H "X-Master-Key: master-riverflow-smtp-key-2024" \
  -d '{
    "name": "Production Server",
    "description": "Main RiverFlow backend server"
  }'
```

### Response thành công:

```json
{
  "success": true,
  "message": "API key created successfully",
  "data": {
    "id": "1699876543210",
    "key": "rfsk_aBcDeFgHiJkLmNoPqRsTuVwXyZ1234567890aBcDeFgHiJkL",
    "name": "Production Server",
    "description": "Main RiverFlow backend server",
    "createdAt": "2024-11-10T12:00:00.000Z",
    "warning": "Save this key securely. You will not be able to see it again."
  }
}
```

⚠️ **QUAN TRỌNG:** Lưu key `rfsk_...` ngay lập tức! Bạn chỉ thấy full key 1 lần duy nhất.

---

## 🔑 Cách 2: Sử dụng PowerShell Script

### Windows PowerShell:

```powershell
# Chạy script
.\scripts\create-api-key.ps1 -Name "Production Server" -Description "Main backend"

# Hoặc với default values
.\scripts\create-api-key.ps1
```

### Custom name và description:

```powershell
.\scripts\create-api-key.ps1 `
  -Name "Staging Server" `
  -Description "Staging environment for testing"
```

---

## 🔑 Cách 3: Sử dụng Bash Script (Linux/Mac)

```bash
# Make executable
chmod +x scripts/create-api-key.sh

# Run script
./scripts/create-api-key.sh "Production Server" "Main backend"

# Hoặc với default values
./scripts/create-api-key.sh
```

---

## 🔑 Cách 4: Sử dụng Postman/Insomnia

### Request Setup:

**Method:** `POST`  
**URL:** `https://river-flow-smtp-server.vercel.app/api/keys`

**Headers:**
```
Content-Type: application/json
X-Master-Key: master-riverflow-smtp-key-2024
```

**Body (JSON):**
```json
{
  "name": "Production Server",
  "description": "Main RiverFlow backend server"
}
```

---

## 📝 Examples - Tạo nhiều keys cho các môi trường

### 1. Production Key

```bash
curl -X POST https://river-flow-smtp-server.vercel.app/api/keys \
  -H "Content-Type: application/json" \
  -H "X-Master-Key: master-riverflow-smtp-key-2024" \
  -d '{
    "name": "Production Server",
    "description": "Main production backend on Render.com"
  }'
```

### 2. Staging Key

```bash
curl -X POST https://river-flow-smtp-server.vercel.app/api/keys \
  -H "Content-Type: application/json" \
  -H "X-Master-Key: master-riverflow-smtp-key-2024" \
  -d '{
    "name": "Staging Server",
    "description": "Staging environment for testing"
  }'
```

### 3. Development Key

```bash
curl -X POST https://river-flow-smtp-server.vercel.app/api/keys \
  -H "Content-Type: application/json" \
  -H "X-Master-Key: master-riverflow-smtp-key-2024" \
  -d '{
    "name": "Development",
    "description": "Local development environment"
  }'
```

---

## ✅ Sau khi tạo API Key

### 1. Lưu Key an toàn

```bash
# Lưu vào file (Linux/Mac)
echo "rfsk_YOUR_KEY_HERE" > ~/.riverflow-smtp-key

# Hoặc lưu vào password manager
# Hoặc lưu vào environment variables trên server
```

### 2. Cập nhật Spring Boot Server

**File:** `application.properties`

```properties
# Thay đổi từ default key sang key mới
app.smtp.server.api-key=rfsk_YOUR_NEW_KEY_HERE
```

### 3. Test API Key mới

```bash
# Test gửi email
curl -X POST https://river-flow-smtp-server.vercel.app/api/email/send \
  -H "Content-Type: application/json" \
  -H "X-API-Key: rfsk_YOUR_NEW_KEY_HERE" \
  -d '{
    "to": "winnieph13@gmail.com",
    "subject": "Test from New API Key",
    "html": "<h1>✅ API Key hoạt động!</h1>"
  }'
```

---

## 📊 Xem tất cả API Keys

```bash
curl https://river-flow-smtp-server.vercel.app/api/keys \
  -H "X-Master-Key: master-riverflow-smtp-key-2024"
```

**Response:**
```json
{
  "success": true,
  "count": 3,
  "data": [
    {
      "id": "1699876543210",
      "name": "Production Server",
      "description": "Main backend",
      "key": "rfsk_aBcDeFgHi...JkLm",
      "createdAt": "2024-11-10T12:00:00.000Z",
      "lastUsedAt": "2024-11-10T15:30:00.000Z",
      "usageCount": 156,
      "active": true
    }
  ]
}
```

**Lưu ý:** Key sẽ bị mask (chỉ hiển thị một phần) để bảo mật.

---

## 🔒 Security Best Practices

### ✅ DO:
- ✅ Lưu key trong environment variables
- ✅ Sử dụng password manager
- ✅ Tạo key riêng cho mỗi environment
- ✅ Rotate keys định kỳ (3-6 tháng)
- ✅ Revoke keys không còn dùng

### ❌ DON'T:
- ❌ Commit keys vào Git
- ❌ Share keys qua email/chat không mã hóa
- ❌ Hardcode keys trong code
- ❌ Dùng chung key cho nhiều services

---

## 🚨 Troubleshooting

### Error: "Master API key is required"

**Solution:**
1. Kiểm tra Master Key đã được set trong Vercel Environment Variables
2. Verify header name: `X-Master-Key` (case-sensitive)
3. Redeploy sau khi thêm environment variable

### Error: "Invalid Master API key"

**Solution:**
- Master key phải match với `MASTER_API_KEY` trong Vercel
- Default: `master-riverflow-smtp-key-2024`
- Hoặc set custom key trong Vercel

### Error: "Failed to save API keys"

**Solution:**
1. Verify Vercel KV đã được connect đến project
2. Check KV environment variables đã được set
3. Redeploy project

### Keys không hiển thị sau khi tạo

**Solution:**
- Vercel KV có thể cần vài giây để sync
- Thử list keys lại sau 5-10 giây
- Check Vercel logs để xem errors

---

## 📖 Related Documentation

- [API_KEY_MANAGEMENT.md](./API_KEY_MANAGEMENT.md) - Full API key management guide
- [VERCEL_KV_SETUP.md](./VERCEL_KV_SETUP.md) - Vercel KV setup instructions
- [API_KEY_SETUP.md](./API_KEY_SETUP.md) - Basic API key configuration

---

## 🎯 Next Steps

1. ✅ Tạo API key cho Production
2. ✅ Update Spring Boot server với key mới
3. ✅ Test gửi email
4. ✅ Monitor usage trong Vercel KV dashboard
5. ✅ Setup key rotation schedule

