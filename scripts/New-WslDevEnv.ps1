<#
.SYNOPSIS
    Installs a new Ubuntu WSL distribution, configures a user, and runs an Ansible playbook.

.DESCRIPTION
    This script automates the setup of a new WSL development environment. It performs the following:
    1. Downloads a specified Ubuntu cloud image for WSL.
    2. Imports the image as a new WSL distribution with a given name.
    3. Prompts for a new username and password, then creates and configures this user inside WSL.
    4. Installs Git and Ansible within the new instance.
    5. Clones the dev-env Git repository.
    6. Checks out the 'devbox' branch and runs the provisioning playbook.

.PARAMETER DistroName
    The name for the new WSL distribution (e.g., "Ubuntu-Dev"). This is mandatory.

.PARAMETER UbuntuVersion
    The version name of the Ubuntu release to download (e.g., 'noble', 'jammy'). Defaults to 'noble'.

.PARAMETER InstallPath
    The local path to store the WSL distribution's virtual disk. 
    Defaults to "$env:LOCALAPPDATA\WSL\<DistroName>".

.EXAMPLE
    .\New-WslDevEnv.ps1 -DistroName "MyDevBox"

    This command will create a WSL instance named "MyDevBox" using the latest 'noble' Ubuntu image.
    It will prompt for user credentials and then run the full setup.

.EXAMPLE
    .\New-WslDevEnv.ps1 -DistroName "JammyDev" -UbuntuVersion "jammy"

    This command creates a WSL instance named "JammyDev" using the 'jammy' Ubuntu image.
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
    [Parameter(Mandatory = $true)]
    [string]$DistroName,

    [string]$UbuntuVersion = "noble",

    [string]$InstallPath = "$env:LOCALAPPDATA\WSL\$DistroName"
)

# --- Script Configuration ---
$ImageUrl = "https://cloud-images.ubuntu.com/wsl/${UbuntuVersion}/current/ubuntu-${UbuntuVersion}-wsl-amd64-wsl.rootfs.tar.gz"
$DownloadPath = Join-Path $env:TEMP "ubuntu-${UbuntuVersion}-wsl.tar.gz"
$RepoUrl = "https://github.com/syvanpera/dev-env.git"
$RepoBranch = "devbox"
$PlaybookName = "local.yml"

# --- Main Logic ---
try {
    # Pre-flight checks
    Write-Host "🔎 Checking prerequisites..." -ForegroundColor Cyan
    if (-not (wsl --status 2>&1 | Select-String "Default Distribution")) {
        Write-Error "WSL does not appear to be installed or is not fully configured. Please run 'wsl --install' and restart your system."
        return
    }

    if (wsl --list --quiet | Select-String -Pattern "^${DistroName}$") {
        Write-Error "A WSL distribution named '${DistroName}' already exists. Please choose a different name or unregister it first with 'wsl --unregister ${DistroName}'."
        return
    }
    Write-Host "✅ Prerequisites met." -ForegroundColor Green

    # --- 1. Download WSL Image ---
    Write-Host "🌐 Downloading Ubuntu $UbuntuVersion image..." -ForegroundColor Cyan
    Write-Host "URL: $ImageUrl"
    if ($PSCmdlet.ShouldProcess($ImageUrl, "Download WSL Image")) {
        Invoke-WebRequest -Uri $ImageUrl -OutFile $DownloadPath
        Write-Host "✅ Download complete." -ForegroundColor Green
    }

    # --- 2. Install WSL Instance ---
    Write-Host "⚙️ Installing WSL instance '$DistroName' to '$InstallPath'..." -ForegroundColor Cyan
    if ($PSCmdlet.ShouldProcess($DistroName, "Import WSL Distribution")) {
        if (-not (Test-Path -Path $InstallPath)) {
            New-Item -ItemType Directory -Force -Path $InstallPath | Out-Null
        }
        wsl --import $DistroName $InstallPath $DownloadPath
        Write-Host "✅ WSL instance '$DistroName' installed successfully." -ForegroundColor Green
    }

    # --- 3. Prompt for and Configure User ---
    Write-Host "👤 Configuring initial user for '$DistroName'..." -ForegroundColor Cyan
    $username = Read-Host "Please enter the desired username for WSL"
    $passwordSecure = Read-Host "Please enter the password for '$username'" -AsSecureString
    $passwordPlain = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordSecure)
    )

    if ($PSCmdlet.ShouldProcess($username, "Create and Configure WSL User")) {
        # Create user, add to sudo group, and set password
        $userSetupCommands = @"
useradd -m -s /bin/bash '${username}';
usermod -aG sudo '${username}';
echo '${username}:${passwordPlain}' | chpasswd;
echo "[user]`ndefault=${username}" > /etc/wsl.conf;
"@
        wsl -d $DistroName -u root -- bash -c $userSetupCommands
        Write-Host "✅ User '$username' configured successfully." -ForegroundColor Green
    }

    # --- 4. Run Ansible Playbook ---
    $RepoPath = "/home/$username/dev-env"
    Write-Host "🚀 Provisioning environment with Ansible..." -ForegroundColor Cyan

    if ($PSCmdlet.ShouldProcess($RepoUrl, "Run Ansible Provisioning")) {
        $ansibleSetupCommands = @"
set -e
echo 'Updating package lists...';
sudo -S <<< '${passwordPlain}' apt-get update -y > /dev/null;

echo 'Installing Git and Ansible...';
sudo -S <<< '${passwordPlain}' apt-get install -y git ansible > /dev/null;

echo 'Cloning repository ${RepoUrl}...';
git clone '${RepoUrl}' '${RepoPath}';

echo 'Checking out branch ${RepoBranch}...';
cd '${RepoPath}';
git checkout '${RepoBranch}';

echo 'Running Ansible playbook... This may take a while.';
ansible-playbook '${PlaybookName}' --extra-vars "ansible_become_pass=${passwordPlain}";
"@

        wsl -d $DistroName -u $username -- bash -c $ansibleSetupCommands

        Write-Host "✅ Ansible playbook execution finished." -ForegroundColor Green
    }

    Write-Host "`n🎉 Setup complete! `nYou can now access your new WSL instance by running: wsl -d $DistroName" -ForegroundColor Yellow

}
catch {
    Write-Error "An error occurred during execution: $_"
}
finally {
    # Cleanup the downloaded file and the password variable
    if (Test-Path -Path $DownloadPath) {
        Write-Host "🧹 Cleaning up downloaded files..." -ForegroundColor Cyan
        Remove-Item -Path $DownloadPath -Force
    }
    if ($passwordPlain) {
        [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR(
            [System.Runtime.InteropServices.Marshal]::StringToBSTR($passwordPlain)
        )
    }
}
