# API Key Configuration Guide

## 📌 Current Configuration

- **SMTP Server URL**: https://river-flow-smtp-server-t3zk.vercel.app
- **API Key**: `riverflow-smtp-secure-key-2024`

## 🔐 Security Best Practices

### 1. API Key trong Vercel (SMTP Server)

API Key được cấu hình trong Vercel Environment Variables:

**Bước 1:** Vào Vercel Dashboard
- URL: https://vercel.com/dashboard
- Chọn project: `RiverFlow-SMTP-Server`

**Bước 2:** Thêm Environment Variable
- Settings → Environment Variables
- Thêm biến mới:
  ```
  Key: API_KEY
  Value: riverflow-smtp-secure-key-2024
  ```
- Apply to: Production, Preview, Development

**Bước 3:** Redeploy
- Sau khi thêm environment variable, click "Redeploy" để áp dụng

### 2. API Key trong Spring Boot Server

API Key được cấu hình trong `application.properties`:

```properties
# SMTP SERVER CONFIGURATION (Proxy)
app.smtp.server.url=https://river-flow-smtp-server-t3zk.vercel.app
app.smtp.server.api-key=riverflow-smtp-secure-key-2024
```

**Quan trọng:** 
- Trong production, nên sử dụng environment variables thay vì hardcode
- Trên Render.com, thêm environment variable `SMTP_API_KEY`
- Cập nhật application.properties: `app.smtp.server.api-key=${SMTP_API_KEY:riverflow-smtp-secure-key-2024}`

### 3. Generate API Key mạnh hơn (Optional)

Nếu muốn tạo API key bảo mật hơn:

```bash
# Sử dụng Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Hoặc sử dụng OpenSSL
openssl rand -hex 32
```

Sau đó cập nhật ở cả 2 nơi:
1. Vercel Environment Variables (SMTP Server)
2. Render.com Environment Variables (Main Server)

## 🧪 Test API Key

### Test với cURL

```bash
# Test health check (không cần API key)
curl https://river-flow-smtp-server-t3zk.vercel.app/api/email/health

# Test send email (cần API key)
curl -X POST https://river-flow-smtp-server-t3zk.vercel.app/api/email/send \
  -H "Content-Type: application/json" \
  -H "X-API-Key: riverflow-smtp-secure-key-2024" \
  -d '{
    "to": "test@example.com",
    "subject": "Test Email",
    "html": "<h1>Test from RiverFlow</h1>",
    "text": "Test from RiverFlow"
  }'
```

### Expected Responses

**✅ Success (200)**
```json
{
  "success": true,
  "message": "Email sent successfully",
  "messageId": "message-id-from-smtp"
}
```

**❌ Missing API Key (401)**
```json
{
  "success": false,
  "message": "API key is required"
}
```

**❌ Invalid API Key (403)**
```json
{
  "success": false,
  "message": "Invalid API key"
}
```

## 🔄 API Key Flow

```
┌─────────────────┐
│  Client Request │
│  (Next.js App)  │
└────────┬────────┘
         │
         ▼
┌─────────────────────────┐
│  RiverFlow Server       │
│  (Spring Boot)          │
│  - Has API Key          │
└────────┬────────────────┘
         │ HTTP Request with
         │ X-API-Key header
         ▼
┌─────────────────────────┐
│  SMTP Server            │
│  (Node.js/Express)      │
│  - Validates API Key    │
│  - Sends Email via SMTP │
└─────────────────────────┘
```

## 🚨 Troubleshooting

### Problem: API Key không hoạt động

**Solution:**
1. Check Vercel environment variables đã được set chưa
2. Redeploy sau khi thêm environment variables
3. Verify API key match giữa Server và SMTP Server
4. Check header name phải là `X-API-Key` (case-sensitive)

### Problem: 403 Forbidden

**Solution:**
- API key không khớp
- Kiểm tra lại giá trị trong:
  - Vercel: `API_KEY` environment variable
  - Spring Boot: `app.smtp.server.api-key` property

### Problem: CORS Error

**Solution:**
- Thêm domain của Server vào `CORS_ORIGINS` trong Vercel
- Ví dụ: `https://riverflow-server.onrender.com,https://river-flow-client.vercel.app`

## 📝 Checklist

- [ ] API Key đã được set trong Vercel environment variables
- [ ] API Key đã được cấu hình trong Spring Boot application.properties
- [ ] Đã redeploy SMTP Server sau khi thêm environment variables
- [ ] Đã test health check endpoint
- [ ] Đã test send email endpoint với API key
- [ ] CORS origins đã được cấu hình đúng
- [ ] Đã verify email được gửi thành công

## 🔗 Related Files

- SMTP Server Config: `src/config/app.config.js`
- SMTP Server Auth: `src/middlewares/auth.middleware.js`
- Spring Boot Config: `src/main/resources/application.properties`
- Spring Boot Service: `src/main/java/com/riverflow/service/SmtpEmailServiceImpl.java`

