{ pkgs ? import <nixpkgs> {} }:

let
  pythonEnv = pkgs.python313.withPackages (ps: with ps; [
    # Core ML packages
    torch
    torchvision
    numpy
    scipy
    matplotlib
    seaborn
    pandas

    # Deep learning utilities
    tqdm
    tensorboard
    scikit-learn

    # Jupyter ecosystem for notebooks
    jupyter
    ipykernel
    ipywidgets

    # Code quality and type checking tools
    black
    flake8
    mypy

    # Additional utilities for data processing
    pillow
    h5py
  ]);
in
pkgs.mkShell {
  name = "pytorch-ml-env";
  buildInputs = [
    pythonEnv

    # Pyright LSP server (from nodePackages)
    pkgs.pyright

    # Monitor MPS performance from CLI
    pkgs.macmon

    # Native dependencies (ensuring BLAS and other native libs are available)
    pkgs.openblas
    pkgs.libjpeg
    pkgs.zlib
    pkgs.libpng
    pkgs.libtiff
    pkgs.hdf5
    pkgs.freetype

    # Dependency for Jupyter Notebook proxying (removed as it is unnecessary for a minimal local shell)
    # pkgs.nodePackages.configurable-http-proxy
  ];

  shellHook = ''
    # Include the python environment's site-packages in PYTHONPATH
    export PYTHONPATH="${pythonEnv}/${pythonEnv.sitePackages}:$PYTHONPATH"

    # Define a temporary directory for pip installations if needed
    export PIP_PREFIX="$(pwd)/_build/pip_packages"
    export PYTHONPATH="$PIP_PREFIX/${pkgs.python313.sitePackages}:$PYTHONPATH"
    export PATH="$PIP_PREFIX/bin:$PATH"

    # Enable PyTorch experimental MPS fallback support on Apple Silicon
    export PYTORCH_ENABLE_MPS_FALLBACK=1

    # Cleanup function to remove temporary pip installations on exit
    cleanup() {
      echo "===================================================="
      echo "Exit nix shell. Cleaning up temporary pip installations..."
      echo "===================================================="
      [ -d "$PIP_PREFIX" ] && rm -rf "$PIP_PREFIX"
    }
    trap cleanup EXIT

    echo "===================================================="
    echo "PyTorch ML environment for Apple Silicon activated!"
    echo "Python version: $(python --version)"
    echo "PyTorch version: $(python -c 'import torch; print(torch.__version__)')"
    echo "MPS available: $(python -c 'import torch; print(torch.backends.mps.is_available())')"
    echo "Pyright version: $(pyright --version 2>/dev/null || echo 'version unavailable')"
    echo "===================================================="
  '';
}
