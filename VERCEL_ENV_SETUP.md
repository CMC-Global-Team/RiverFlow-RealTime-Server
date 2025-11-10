# Vercel Environment Variables Setup Guide

## 🔐 Required Environment Variables

SMTP Server cần các environment variables sau để hoạt động:

### **SMTP Configuration (Gmail)**

```
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=winnieph13@gmail.com
SMTP_PASSWORD=fjzaeivwjhblsvig
SMTP_FROM=winnieph13@gmail.com
```

### **Server Configuration**

```
PORT=3001
NODE_ENV=production
```

### **Security - API Keys**

```
API_KEY=riverflow-smtp-secure-key-2024
MASTER_API_KEY=master-riverflow-smtp-key-2024
```

### **Redis Cloud (Optional - if using external Redis)**

```
REDIS_URL=redis://default:PASSWORD@HOST:PORT
```

### **CORS Configuration**

```
CORS_ORIGINS=https://riverflow-server.onrender.com,https://river-flow-client.vercel.app
```

---

## 📋 Step-by-Step Setup

### **Bước 1: Vào Vercel Dashboard**

1. Vào https://vercel.com/dashboard
2. Chọn project **RiverFlow-SMTP-Server**
3. Click **Settings** tab
4. Click **Environment Variables** trong menu bên trái

### **Bước 2: Add Environment Variables**

Click **Add New** và thêm từng biến:

#### **1. SMTP_HOST**
```
Name: SMTP_HOST
Value: smtp.gmail.com
Environments: Production, Preview, Development (check all)
```

#### **2. SMTP_PORT**
```
Name: SMTP_PORT
Value: 587
Environments: Production, Preview, Development (check all)
```

#### **3. SMTP_USER**
```
Name: SMTP_USER
Value: winnieph13@gmail.com
Environments: Production, Preview, Development (check all)
```

#### **4. SMTP_PASSWORD**
```
Name: SMTP_PASSWORD
Value: fjzaeivwjhblsvig
Environments: Production, Preview, Development (check all)
```

⚠️ **QUAN TRỌNG:** Đây là Gmail App Password, không phải password thường!

#### **5. SMTP_FROM**
```
Name: SMTP_FROM
Value: winnieph13@gmail.com
Environments: Production, Preview, Development (check all)
```

#### **6. API_KEY**
```
Name: API_KEY
Value: riverflow-smtp-secure-key-2024
Environments: Production, Preview, Development (check all)
```

#### **7. MASTER_API_KEY**
```
Name: MASTER_API_KEY
Value: master-riverflow-smtp-key-2024
Environments: Production, Preview, Development (check all)
```

#### **8. CORS_ORIGINS**
```
Name: CORS_ORIGINS
Value: https://riverflow-server.onrender.com,https://river-flow-client.vercel.app
Environments: Production, Preview, Development (check all)
```

#### **9. REDIS_URL** (Nếu dùng Redis Cloud)
```
Name: REDIS_URL
Value: redis://default:dYIrqVmMAqWxvUGKiDbqVzx0Io1HwlAY@redis-13956.c52.us-east-1-4.ec2.redns.redis-cloud.com:13956
Environments: Production, Preview, Development (check all)
```

### **Bước 3: Redeploy**

Sau khi thêm tất cả environment variables:

1. Vào **Deployments** tab
2. Click **...** menu trên deployment mới nhất
3. Click **Redeploy**
4. Đợi deployment hoàn tất (1-2 phút)

---

## ✅ Verify Setup

### **Test Health Check**

```bash
curl https://river-flow-smtp-server.vercel.app/api/email/health
```

**Expected Response:**
```json
{
  "success": true,
  "message": "SMTP Server is running",
  "timestamp": "2024-11-10T..."
}
```

### **Test Send Email**

```bash
curl -X POST https://river-flow-smtp-server.vercel.app/api/email/send \
  -H "Content-Type: application/json" \
  -H "X-API-Key: rfsk_JOHo3vQB4rJrvWPMUUr0O3ko0iJMefcSLM6yFsTbSJIzvniC" \
  -d '{
    "to": "winnieph13@gmail.com",
    "subject": "Test Email",
    "html": "<h1>✅ SMTP Setup Complete!</h1>"
  }'
```

**Expected Response:**
```json
{
  "success": true,
  "message": "Email sent successfully",
  "messageId": "..."
}
```

---

## 🚨 Troubleshooting

### **Error: "Missing credentials for PLAIN"**

**Nguyên nhân:**
- `SMTP_USER` hoặc `SMTP_PASSWORD` chưa được set
- Environment variables chưa được apply sau khi thêm

**Solution:**
1. Verify environment variables đã được set trong Vercel
2. Check tất cả environments (Production, Preview, Development) đều được check
3. **Redeploy** sau khi thêm environment variables
4. Check logs trong Vercel để xem error chi tiết

### **Error: "Invalid login"**

**Nguyên nhân:**
- Gmail App Password không đúng
- 2FA chưa được enable trên Gmail account

**Solution:**
1. Verify Gmail App Password:
   - Vào Google Account → Security
   - 2-Step Verification → App passwords
   - Tạo App Password mới cho "Mail"
   - Copy password (16 characters, no spaces)
2. Update `SMTP_PASSWORD` trong Vercel
3. Redeploy

### **Error: "Connection timeout"**

**Nguyên nhân:**
- Firewall blocking SMTP port
- Network issues

**Solution:**
- Verify SMTP port 587 is not blocked
- Check Gmail account is not locked
- Try different SMTP port (465 with secure: true)

---

## 📊 Environment Variables Checklist

- [ ] SMTP_HOST set to `smtp.gmail.com`
- [ ] SMTP_PORT set to `587`
- [ ] SMTP_USER set to Gmail address
- [ ] SMTP_PASSWORD set to Gmail App Password
- [ ] SMTP_FROM set to Gmail address
- [ ] API_KEY set
- [ ] MASTER_API_KEY set
- [ ] CORS_ORIGINS set with production URLs
- [ ] REDIS_URL set (if using Redis Cloud)
- [ ] All variables applied to Production, Preview, Development
- [ ] Project redeployed after adding variables

---

## 🔒 Security Best Practices

### ✅ DO:
- ✅ Use Gmail App Password (not regular password)
- ✅ Rotate App Passwords periodically
- ✅ Use different passwords for different environments
- ✅ Never commit credentials to Git
- ✅ Use Vercel's encrypted environment variables

### ❌ DON'T:
- ❌ Use regular Gmail password
- ❌ Share App Passwords publicly
- ❌ Commit `.env` files to Git
- ❌ Use same password for all environments

---

## 📖 Related Documentation

- [DEPLOYMENT.md](./DEPLOYMENT.md) - General deployment guide
- [REDIS_CLOUD_SETUP.md](./REDIS_CLOUD_SETUP.md) - Redis Cloud setup
- [API_KEY_SETUP.md](./API_KEY_SETUP.md) - API key configuration

---

## 🎯 Quick Setup Script

Nếu bạn muốn setup nhanh, có thể copy-paste các giá trị này vào Vercel:

```
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=winnieph13@gmail.com
SMTP_PASSWORD=fjzaeivwjhblsvig
SMTP_FROM=winnieph13@gmail.com
API_KEY=riverflow-smtp-secure-key-2024
MASTER_API_KEY=master-riverflow-smtp-key-2024
CORS_ORIGINS=https://riverflow-server.onrender.com,https://river-flow-client.vercel.app
REDIS_URL=redis://default:dYIrqVmMAqWxvUGKiDbqVzx0Io1HwlAY@redis-13956.c52.us-east-1-4.ec2.redns.redis-cloud.com:13956
```

⚠️ **Lưu ý:** Thêm từng biến một trong Vercel Dashboard, không thể bulk import.

