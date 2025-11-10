# 🔑 API Keys Explained - Hướng dẫn đầy đủ

## 📊 Tổng quan về API Keys

SMTP Server có **3 loại API keys**:

1. **Default API Key** (`API_KEY`) - Key mặc định từ environment variable
2. **Master API Key** (`MASTER_API_KEY`) - Key để quản lý các generated keys
3. **Generated API Keys** - Keys được tạo động qua `/api/keys` endpoint

---

## 1️⃣ Default API Key (`API_KEY`)

### **Lấy ở đâu?**

#### **Option 1: Tự tạo (Recommended)**

Tạo một key mạnh bất kỳ:

```bash
# Sử dụng Node.js
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Hoặc sử dụng OpenSSL
openssl rand -hex 32

# Hoặc online generator
# https://randomkeygen.com/
```

**Ví dụ output:**
```
a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6
```

#### **Option 2: Dùng giá trị mặc định**

Nếu không set, code sẽ dùng default:
```
riverflow-smtp-secure-key-2024
```

⚠️ **Không nên dùng default trong production!**

### **Cách set:**

**Trên Vercel:**
```
Name: API_KEY
Value: [key bạn vừa tạo hoặc giá trị custom]
```

**Trong .env (local):**
```env
API_KEY=your-custom-api-key-here
```

### **Dùng để làm gì?**

- Gửi email qua SMTP server
- Backward compatibility với code cũ
- Không có tracking (usage count, last used)

---

## 2️⃣ Master API Key (`MASTER_API_KEY`)

### **Lấy ở đâu?**

**BẮT BUỘC phải tự tạo!** Đây là key quan trọng nhất.

#### **Tạo Master Key:**

```bash
# Sử dụng Node.js (Recommended)
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"

# Hoặc OpenSSL
openssl rand -hex 32

# Hoặc tạo key dài hơn (64 bytes = 128 hex chars)
node -e "console.log(require('crypto').randomBytes(64).toString('hex'))"
```

**Ví dụ output:**
```
master_7f3a9b2c4d5e6f8a1b3c5d7e9f0a2b4c6d8e0f2a4b6c8d0e2f4a6b8c0d2e4f6a8b
```

### **Cách set:**

**Trên Vercel:**
```
Name: MASTER_API_KEY
Value: [master key bạn vừa tạo]
```

**Trong .env (local):**
```env
MASTER_API_KEY=master_your-very-secure-key-here
```

### **Dùng để làm gì?**

- ✅ Tạo API keys mới (`POST /api/keys`)
- ✅ Xem danh sách keys (`GET /api/keys`)
- ✅ Revoke/Reactivate keys (`PUT /api/keys/:id/revoke`)
- ✅ Xóa keys (`DELETE /api/keys/:id`)

⚠️ **QUAN TRỌNG:** 
- Master key KHÔNG dùng để gửi email
- Chỉ dùng để quản lý các generated keys
- Phải giữ bí mật tuyệt đối!

---

## 3️⃣ Generated API Keys

### **Lấy ở đâu?**

Tạo qua API endpoint với Master Key:

```bash
curl -X POST https://river-flow-smtp-server.vercel.app/api/keys \
  -H "Content-Type: application/json" \
  -H "X-Master-Key: master-riverflow-smtp-key-2024" \
  -d '{
    "name": "Production Server",
    "description": "Main RiverFlow backend"
  }'
```

**Response:**
```json
{
  "success": true,
  "data": {
    "key": "rfsk_JOHo3vQB4rJrvWPMUUr0O3ko0iJMefcSLM6yFsTbSJIzvniC",
    "id": "1762793060749",
    "name": "Production Server"
  }
}
```

⚠️ **Lưu key `rfsk_...` ngay!** Bạn chỉ thấy 1 lần duy nhất.

### **Dùng để làm gì?**

- Gửi email qua SMTP server
- Có tracking (usage count, last used)
- Có thể revoke/reactivate
- Có metadata (name, description)

---

## 🎯 Workflow Khuyến nghị

### **Bước 1: Tạo Master API Key**

```bash
# Tạo master key mạnh
node -e "console.log('master_' + require('crypto').randomBytes(48).toString('hex'))"
```

**Output ví dụ:**
```
master_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f2g3h4i5j6k7l8m9n0o1p2q3r4s5t6u7v8w9x0y1z2
```

### **Bước 2: Set Master Key trên Vercel**

```
Name: MASTER_API_KEY
Value: master_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f2g3h4i5j6k7l8m9n0o1p2q3r4s5t6u7v8w9x0y1z2
```

### **Bước 3: Tạo Default API Key (Optional)**

```bash
# Tạo default API key
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

**Set trên Vercel:**
```
Name: API_KEY
Value: [key vừa tạo]
```

### **Bước 4: Tạo Generated API Key cho Production**

```bash
# Sử dụng Master Key để tạo key mới
curl -X POST https://river-flow-smtp-server.vercel.app/api/keys \
  -H "Content-Type: application/json" \
  -H "X-Master-Key: master_a1b2c3d4e5f6..." \
  -d '{
    "name": "Production Server",
    "description": "Main RiverFlow backend"
  }'
```

**Lưu key `rfsk_...` được trả về!**

### **Bước 5: Update Spring Boot Server**

Trong `application.properties`:
```properties
app.smtp.server.api-key=rfsk_JOHo3vQB4rJrvWPMUUr0O3ko0iJMefcSLM6yFsTbSJIzvniC
```

---

## 📝 Tóm tắt

| Key Type | Lấy ở đâu? | Dùng để làm gì? | Required? |
|----------|------------|----------------|-----------|
| **API_KEY** | Tự tạo hoặc dùng default | Gửi email (backward compat) | ❌ Optional |
| **MASTER_API_KEY** | **Tự tạo (bắt buộc)** | Quản lý generated keys | ✅ **Required** |
| **Generated Keys** | Tạo qua `/api/keys` với Master Key | Gửi email (recommended) | ❌ Optional |

---

## 🔐 Security Best Practices

### **Master API Key:**
- ✅ Tạo key dài ít nhất 64 characters
- ✅ Prefix với `master_` để dễ nhận biết
- ✅ Lưu trong password manager
- ✅ Chỉ share với admin
- ✅ Rotate định kỳ (3-6 tháng)

### **Generated API Keys:**
- ✅ Tạo key riêng cho mỗi service/environment
- ✅ Đặt tên rõ ràng
- ✅ Revoke khi không dùng
- ✅ Monitor usage

---

## 🚀 Quick Start

### **1. Tạo Master Key:**

```bash
node -e "console.log('master_' + require('crypto').randomBytes(48).toString('hex'))"
```

### **2. Set trên Vercel:**

```
MASTER_API_KEY = [paste key từ bước 1]
```

### **3. Redeploy và tạo Generated Key:**

```bash
curl -X POST https://river-flow-smtp-server.vercel.app/api/keys \
  -H "Content-Type: application/json" \
  -H "X-Master-Key: [master key của bạn]" \
  -d '{"name":"Production","description":"Main server"}'
```

### **4. Lưu Generated Key và update Spring Boot:**

Copy key `rfsk_...` và update `application.properties`

---

## 📖 Related Documentation

- [API_KEY_MANAGEMENT.md](./API_KEY_MANAGEMENT.md) - Full API key management guide
- [QUICK_START.md](./QUICK_START.md) - Quick start guide
- [VERCEL_ENV_SETUP.md](./VERCEL_ENV_SETUP.md) - Vercel setup guide

