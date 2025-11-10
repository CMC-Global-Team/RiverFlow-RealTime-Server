# PowerShell script để tạo API key mới cho RiverFlow SMTP Server
# Usage: .\create-api-key.ps1 -Name "Key Name" -Description "Description"

param(
    [string]$Name = "Production Server",
    [string]$Description = "Main backend server"
)

$SMTP_SERVER = "https://river-flow-smtp-server.vercel.app"
$MASTER_KEY = "master-riverflow-smtp-key-2024"

Write-Host "🔑 Creating API Key for RiverFlow SMTP Server" -ForegroundColor Cyan
Write-Host "==============================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Server: $SMTP_SERVER"
Write-Host "Name: $Name"
Write-Host "Description: $Description"
Write-Host ""

# Create request body
$body = @{
    name = $Name
    description = $Description
} | ConvertTo-Json

# Create API key
$headers = @{
    "Content-Type" = "application/json"
    "X-Master-Key" = $MASTER_KEY
}

try {
    $response = Invoke-RestMethod -Uri "$SMTP_SERVER/api/keys" `
        -Method Post `
        -Headers $headers `
        -Body $body
    
    if ($response.success) {
        Write-Host "✅ API Key created successfully!" -ForegroundColor Green
        Write-Host ""
        Write-Host ($response | ConvertTo-Json -Depth 10)
        Write-Host ""
        Write-Host "⚠️  IMPORTANT: Save the 'key' value above securely!" -ForegroundColor Yellow
        Write-Host "   You will not be able to see it again." -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Your new API Key: $($response.data.key)" -ForegroundColor Green
    } else {
        Write-Host "❌ Failed to create API key" -ForegroundColor Red
        Write-Host ($response | ConvertTo-Json -Depth 10)
        exit 1
    }
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

