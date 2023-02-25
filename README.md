[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

# Anaconda Environment Setup Script

This shell script creates and installs packages in multiple Anaconda environments. It supports Linux (Ubuntu 22.10 at least) and MacOS.

## Instructions

- For Linux, run the script as:
    ```
    source <path/to/script.sh>
    ```

- For MacOS, run the script as:
    ```
    sh <path/to/script.sh>
    ```

## What it does

1. Removes all environments except `base`
2. Defines a function to create environments and install packages
3. Creates and activates each environment in a loop, and installs packages according to the environment
4. Cleans the environment and deactivates it after installation is complete

The following environments are created and the following packages are installed:

- `general`: 
    - numpy 
    - opencv-python-headless 
    - imageio 
    - scikit-image 
    - scipy 
    - matplotlib 
    - tqdm 
    - tifffile 
    - Pillow 
    - streamlit 
    - protobuf 
    - jupyter

- `numba`: 
    - numpy 
    - opencv-python-headless 
    - imageio 
    - scikit-image 
    - scipy 
    - matplotlib 
    - tqdm 
    - tifffile 
    - Pillow 
    - streamlit 
    - protobuf 
    - jupyter 
    - numba

- `deeplearning`: 
    - numpy 
    - opencv-python-headless 
    - imageio 
    - scikit-image 
    - scipy 
    - matplotlib 
    - tqdm 
    - tifffile 
    - Pillow 
    - streamlit 
    - protobuf 
    - jupyter 
    - tensorflow-cpu 
    - scikit-learn 
    - stardist

- `pyclesperanto`: 
    - numpy 
    - opencv-python-headless 
    - imageio 
    - scikit-image 
    - scipy 
    - matplotlib 
    - tqdm 
    - tifffile 
    - Pillow 
    - streamlit 
    - protobuf 
    - jupyter 
    - pyclesperanto-prototype
    - pocl (if running on Linux)

- `ABAproject`: 
    - boto3 
    - botocore 
    - caosdb 
    - caosadvancedtools 
    - jupyter
