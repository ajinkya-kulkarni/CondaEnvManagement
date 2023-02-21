#!/bin/bash

# Set the shell options to exit on error, unset variables, and pipeline failures
set -euo pipefail

# Clear the terminal output
clear

# Remove all environments except `base`
for i in $(conda env list | awk '{print $1}' | egrep -v 'base|#' | tr '\n' ' '); do
    if [ $i != "base" ]; then
        echo "Removing environment $i"
        conda env remove --name $i --yes
    fi
done

# Define a function to create environments and install packages
function create_environment 
{
	# Get the environment name from the first argument
	name=$1

	# Create the environment
	echo "Creating environment $name"
	if ! conda create -n $name python=3.9 --yes; then
		echo "Error: Failed to create $name environment."
		exit 1
	fi

	# Activate the environment
	echo "Activating $name environment"
	if ! conda activate $name; then
		echo "Error: Failed to activate $name environment."
		exit 1
	fi

	# Install packages
	echo "Installing packages in $name environment"
	pip install numpy==1.24.0
	pip install opencv-python-headless==4.7.0.68
	pip install imageio==2.25.1
	pip install scikit-image==0.19.3
	pip install scipy==1.10.1
	pip install matplotlib==3.7.0
	pip install tqdm==4.64.1
	pip install tifffile==2023.2.3
	pip install Pillow==9.4.0
	pip install streamlit==1.8.1

	if [ "$name" == "deeplearning" ]; then
		pip install tensorflow-cpu==2.11.0
		pip install scikit-learn==1.2.1
		pip install stardist==0.8.3
	fi

	if [ "$name" == "napari" ]; then
		pip install pyqtwebengine==5.15.6
		pip install "napari[all]"
	fi

	if [ "$name" == "ABAproject" ]; then
		pip install boto3==1.17.107
		pip install botocore==1.20.107
		pip install caosdb==0.11.0
		pip install caosadvancedtools==0.6.1
	fi

	# Clean the environment
	echo "Cleaning $name environment"
	if ! conda clean --all --yes; then
		echo "Error: Failed to clean $name environment."
	fi

	# Deactivate the environment
	echo "Deactivating $name environment"
	conda deactivate
}

# Initialize conda and source zshrc
conda init zsh
source ~/.zshrc

# Define an array of environment names
environments=("general" "deeplearning" "napari" "ABAproject")

# Loop through the array and create/activate each environment
for env in "${environments[@]}"; do
	create_environment "$env"
done

# Echo success message
echo ""
echo "All done!"
echo ""
