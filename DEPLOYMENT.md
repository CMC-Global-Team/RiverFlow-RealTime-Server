# RiverFlow SMTP Server - Deployment Guide

## 📦 Deployment on Vercel

### Prerequisites
- Vercel account
- GitHub repository connected

### Steps

1. **Push code to GitHub**
   ```bash
   git add .
   git commit -m "feat: SMTP Server ready for deployment"
   git push origin main
   ```

2. **Import to Vercel**
   - Go to https://vercel.com/dashboard
   - Click "Add New Project"
   - Import `RiverFlow-SMTP-Server` repository
   - Framework Preset: **Other** (Node.js)
   - Root Directory: `./`

3. **Configure Environment Variables**
   In Vercel dashboard, add these environment variables:

   ```
   NODE_ENV=production
   PORT=3001
   
   SMTP_HOST=smtp.gmail.com
   SMTP_PORT=587
   SMTP_USER=winnieph13@gmail.com
   SMTP_PASSWORD=fjzaeivwjhblsvig
   SMTP_FROM=winnieph13@gmail.com
   
   API_KEY=riverflow-smtp-secure-key-2024
   
   CORS_ORIGINS=https://riverflow-server.onrender.com,https://river-flow-client.vercel.app
   ```

4. **Deploy**
   - Click "Deploy"
   - Wait for deployment to complete
   - Your SMTP server will be available at: `https://river-flow-smtp-server.vercel.app`

5. **Verify Deployment**
   Test the health check endpoint:
   ```bash
   curl https://river-flow-smtp-server.vercel.app/api/email/health
   ```

   Expected response:
   ```json
   {
     "success": true,
     "message": "SMTP Server is running",
     "timestamp": "2024-11-10T..."
   }
   ```

## 🔧 Local Development

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Create .env file**
   ```bash
   cp .env.example .env
   # Edit .env with your credentials
   ```

3. **Run development server**
   ```bash
   npm run dev
   ```

4. **Test locally**
   ```bash
   # Health check
   curl http://localhost:3001/api/email/health
   
   # Send test email
   curl -X POST http://localhost:3001/api/email/send \
     -H "Content-Type: application/json" \
     -H "X-API-Key: your-api-key" \
     -d '{
       "to": "test@example.com",
       "subject": "Test Email",
       "html": "<h1>Test</h1>"
     }'
   ```

## 🔒 Security Notes

1. **API Key**: Never commit `.env` file. Always use environment variables.
2. **CORS**: Configure allowed origins in production.
3. **SMTP Credentials**: Use Gmail App Password, not regular password.
4. **Rate Limiting**: Consider adding rate limiting for production.

## 📊 Monitoring

Monitor your SMTP server:
- Check Vercel logs for errors
- Monitor email delivery success rate
- Set up alerts for failed requests

## 🚨 Troubleshooting

### SMTP Connection Failed
- Verify Gmail credentials
- Check if 2FA is enabled (use App Password)
- Verify SMTP port and host

### API Key Authentication Failed
- Verify API key matches in both server and client
- Check header name is `X-API-Key`

### CORS Errors
- Verify origin is in CORS_ORIGINS list
- Check domain spelling and protocol (https/http)

