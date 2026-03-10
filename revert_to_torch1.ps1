<#
PowerShell helper to guide / automate environment creation for Torch 1.10 on Windows (conda preferred).
Run as: ./revert_to_torch1.ps1
#>

param(
    [string] $envName = "viralcutter_py1",
    [switch] $UseCPUOnly
)

function Write-Note($s){ Write-Host $s -ForegroundColor Cyan }
function Write-Warn($s){ Write-Host $s -ForegroundColor Yellow }
function Write-Err($s){ Write-Host $s -ForegroundColor Red }

Write-Note "This script helps create a compatible environment for Torch 1.10 and older pyannote/audio."

# Check conda
$conda = Get-Command conda -ErrorAction SilentlyContinue
if ($null -ne $conda) {
    Write-Note "Conda detected. Creating environment '$envName'..."
    conda create -n $envName python=3.9 -y
    Write-Note "Activating environment..."
    Write-Note "Run: conda activate $envName"
    Write-Note "Installing torch 1.10.0 (CUDA 10.2) via conda..."
    if ($UseCPUOnly) {
        Write-Note "User requested CPU-only build. Installing CPU wheels via pip after activation."
    } else {
        conda install -y -c pytorch pytorch==1.10.0 torchvision==0.11.1 torchaudio==0.10.0 cudatoolkit=10.2
    }
    Write-Note "Now run the following inside the activated env (copy-paste):"
    Write-Host "pip install pytorch-lightning==1.5.4" -ForegroundColor Green
    Write-Host "pip install pyannote.audio==0.0.1" -ForegroundColor Green
    Write-Host "pip install -r requirements.txt" -ForegroundColor Green
    Write-Note "If you have issues with pyannote or old wheels, consider using CPU-only option or consult ENV_FIX_INSTRUCTIONS.md"
}
else {
    Write-Warn "Conda not found. I'll show pip-based CPU-only commands instead."
    Write-Note "Commands to run in PowerShell (create virtualenv first):"
    Write-Host "python -m venv .venv_py1" -ForegroundColor Green
    Write-Host ".\\.venv_py1\\Scripts\\Activate.ps1" -ForegroundColor Green
    Write-Host "pip install --upgrade pip" -ForegroundColor Green
    Write-Host "pip install torch==1.10.0+cpu torchvision==0.11.1+cpu torchaudio==0.10.0+cpu -f https://download.pytorch.org/whl/torch_stable.html" -ForegroundColor Green
    Write-Host "pip install pytorch-lightning==1.5.4" -ForegroundColor Green
    Write-Host "pip install pyannote.audio==0.0.1" -ForegroundColor Green
    Write-Host "pip install -r requirements.txt" -ForegroundColor Green
}

Write-Note "Done. If you want I can (A) modify requirements.txt to pin the older versions, or (B) add runtime checks to the code to detect mismatches and fail fast. Which do you prefer?"