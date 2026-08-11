# Insta Garam Dashboard — One-click deploy to GitHub Pages
# Run this ONCE. After that, the dashboard is permanently online.

Write-Host "`n`e[31m🌶️ Deploying Insta Garam CEO Dashboard to GitHub Pages`e[0m" -ForegroundColor Red
Write-Host "=" * 55

Set-Location $PSScriptRoot

# 1. Init git repo
if (-not (Test-Path ".git")) {
    git init
    git config user.email "amitbtare@gmail.com"
    git config user.name "Amit Tare"
}

# 2. Add all files
git add index.html agents.html 404.html
git commit -m "Deploy CEO Command Center + Agent Map"

# 3. Create GitHub repo
Write-Host "`nCreating GitHub repo..." -ForegroundColor Cyan
$env:Path += ";C:\Program Files\GitHub CLI"
gh repo create instagaram-dashboard --public --source=. --push --description "Insta Garam Studio CEO Command Center"

# 4. Enable GitHub Pages
Write-Host "`nEnabling GitHub Pages..." -ForegroundColor Cyan
Start-Sleep -Seconds 3
gh api repos/amitbtare-bot/instagaram-dashboard/pages -X POST -f "source[branch]=main" -f "source[path]=/"

# 5. Update Telegram Mini App URL
Write-Host "`nUpdating Telegram Mini App..." -ForegroundColor Cyan
$token = [System.Environment]::GetEnvironmentVariable('TELEGRAM_BOT_TOKEN', 'User')
if ($token) {
    $body = @{
        menu_button = @{
            type = "web_app"
            text = "Dashboard"
            web_app = @{ url = "https://amitbtare-bot.github.io/instagaram-dashboard/" }
        }
    } | ConvertTo-Json -Depth 3

    $null = Invoke-RestMethod -Uri "https://api.telegram.org/bot$token/setChatMenuButton" -Method Post -ContentType "application/json" -Body $body
    Write-Host "Telegram Mini App updated!" -ForegroundColor Green
}

Write-Host "`n`e[32m✅ DONE! Your dashboard is permanently live at:`e[0m"
Write-Host "`n   📊 Dashboard: https://amitbtare-bot.github.io/instagaram-dashboard/"
Write-Host "   🗺️  Agent Map: https://amitbtare-bot.github.io/instagaram-dashboard/agents.html"
Write-Host "   📱 Telegram:  Open @instagaram_ceo_bot → tap Menu button"
Write-Host "`n   (GitHub Pages may take 1-2 minutes to go live on first deploy)`n"
