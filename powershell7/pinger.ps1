# Bypass execution policy for the session (No manual setup required)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

# Function to ping the website
function Ping-Website {
    param (
        [string]$url
    )

    try {
        $response = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 5
        if ($response.StatusCode -eq 200) {
            Write-Host "$url is up and running!" -ForegroundColor Green
        } else {
            Write-Host "The targeted site is not active. Status Code: $($response.StatusCode)" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "Failed to connect to the URL. It may be down or invalid." -ForegroundColor Red
    }
}

# Ask user for the website URL
$websiteUrl = Read-Host "Enter the URL to check its status (e.g., https://example.com)"

# Wait for user to start the ping
Read-Host "Press Enter to start the ping process..."

Write-Host "`nStarting..." -ForegroundColor Cyan

# Start pinging process
while ($true) {
    $userInput = Read-Host "`nPress Enter to exit or enter seconds for auto-loop"

    if ($userInput -eq "") {
        Write-Host "Exiting..." -ForegroundColor Red
        break
    }

    if ($userInput -match '^\d+$') {
        $interval = [int]$userInput
        Write-Host "Pinging $websiteUrl every $interval seconds... (Press Ctrl+C to stop)" -ForegroundColor Cyan
        
        try {
            while ($true) {
                Ping-Website $websiteUrl
                Start-Sleep -Seconds $interval
            }
        } catch {
            Write-Host "`nLoop stopped. Exiting..." -ForegroundColor Red
            break
        }
    } else {
        Write-Host "Invalid input. Please enter a number for seconds or press Enter to exit." -ForegroundColor Yellow
    }
}

# Keep the window open
Read-Host "Press Enter to close the window"
