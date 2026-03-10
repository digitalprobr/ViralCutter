# ENVIRONMENT FIX: Revert to Torch 1.x and compatible packages

This project (or some pre-trained models used by WhisperX / Pyannote) were trained against older packages (Torch 1.10 + pyannote 0.x / pytorch-lightning 1.5.x). If you see warnings like:

- "Model was trained with torch 1.10.0+cu102, yours is 2.3.1+cu121"
- "Model was trained with pyannote.audio 0.0.1, yours is 3.4.0"
- "Lightning automatically upgraded your loaded checkpoint from v1.5.4 to v2.6.1"

... please follow these instructions to create a clean, compatible environment.

Windows (recommended: use Anaconda / Miniconda):

1) Create a new conda env with CUDA 10.2 (matches +cu102) (change `cudatoolkit` if you need CPU-only):

```powershell
# Create env named viralcutter_py1
conda create -n viralcutter_py1 python=3.9 -y
conda activate viralcutter_py1

# Install pytorch 1.10.0 with CUDA 10.2 (use cpu option if you don't have GPU)
conda install -y -c pytorch pytorch==1.10.0 torchvision==0.11.1 torchaudio==0.10.0 cudatoolkit=10.2

# If you prefer CPU-only builds:
# pip install torch==1.10.0+cpu torchvision==0.11.1+cpu torchaudio==0.10.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
```

2) Pin Pyannote / Lightning versions that match the training environment:

```powershell
pip install pytorch-lightning==1.5.4
pip install pyannote.audio==0.0.1
```

3) Install WhisperX and other dependencies (from repository root):

```powershell
pip install -r requirements.txt
# If you modified requirements.txt to be loose, install whisperx explicitly:
pip install whisperx
```

Notes:
- If `pyannote.audio==0.0.1` is not available on pip directly, you may need an older wheel or to fetch from the project's releases matching that release.
- For many users, switching to a CPU-only Torch 1.10 build is easier if GPU drivers / CUDA toolkits mismatch.

Alternative (no conda):
- Use pip + CPU wheels (easiest but slower):

```powershell
python -m venv .venv_py1
.\.venv_py1\Scripts\Activate.ps1
pip install --upgrade pip
pip install torch==1.10.0+cpu torchvision==0.11.1+cpu torchaudio==0.10.0+cpu -f https://download.pytorch.org/whl/torch_stable.html
pip install pytorch-lightning==1.5.4
pip install pyannote.audio==0.0.1
pip install -r requirements.txt
```

Troubleshooting & recommendations
- If installing old CUDA toolkits is difficult, use CPU-only Torch builds.
- Keep these legacy envs only for running WhisperX alignments; for other development, prefer modern Torch 2.x in a separate env.

Why this helps
- WhisperX and pyannote's alignment code sometimes rely on model checkpoint pickles serialized with older PyTorch / Lightning versions. Running them with mismatched major versions can trigger automatic upgrade attempts or silent errors.

If you want, I can:
- add a small `revert_to_torch1.ps1` helper script to automate the conda/pip steps (Windows),
- or add runtime checks to the code that detect version mismatches and offer to abort with explicit instructions.

Tell me which option you prefer and I'll implement it for you.
