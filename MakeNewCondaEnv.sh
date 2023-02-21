#!/bin/bash

# Clear the output
clear

# Detect the operating system and initialize the appropriate shell
if [[ $(uname -s) == 'Darwin' ]]; then
	conda init zsh
	source ~/.zshrc
else
	conda init bash
	source ~/.bashrc
fi

set -eu

# Check if Conda is installed
if [ -x "$(command -v conda)" ]; then
	echo "Error: Conda is not installed or the environment is not set up. Please install Conda and set up the environment."
	exit 1
fi

# Install anaconda-clean first
if ! conda install anaconda-clean --yes; then
	echo "Error: Failed to install anaconda-clean. Please check your internet connection or try again later."
	exit 1
fi

# Function to create and activate an environment
create_environment() {
	# Extract environment name and requirements file from input arguments
	name="$1"
	requirements_file="$2"

	# Create and activate the environment
	echo "Creating and activating $name environment"
	if ! conda create --name "$name" python=3.9 --yes; then
		echo "Error: Failed to create $name environment."
		exit 1
	fi
	if ! conda activate "$name"; then
		echo "Error: Failed to activate $name environment."
		exit 1
	fi

	# Install jupyter notebook
	if ! conda install -c anaconda jupyter --yes; then
		echo "Error: Failed to install jupyter notebook in $name environment."
		exit 1
	fi

	# Install packages in the environment
	echo "Installing packages in $name environment"
	if ! curl -s "https://raw.githubusercontent.com/ajinkya-kulkarni/CondaEnvManagement/main/$requirements_file" | xargs -n 1 pip install; then
		echo "Error: Failed to install packages in $name environment."
		exit 1
	fi

	if [ "$name" == "deeplearning" ]; then

		pip install tensorflow-cpu==2.11.0
		pip install scikit-learn==1.2.1
		pip install stardist==0.8.3

	fi

	if [ "$name" == "napari" ]; then

		pip install tensorflow-cpu==2.11.0
		pip install scikit-learn==1.2.1
		pip install stardist==0.8.3
		pip install pyqtwebengine==5.15
		pip install "napari[all]"

	fi

	# Clean the environment
	echo "Cleaning $name environment"
	if ! conda clean --all --yes; then
		echo "Error: Failed to clean $name environment."
		exit 1
	fi

	# Deactivate the environment
	echo "Deactivating $name environment"
	if ! conda deactivate; then
		echo "Error: Failed to deactivate $name environment."
		exit 1
	fi
}

# Check if the requirement files exist
if [ ! -f requirements_common.txt ] || [ ! -f requirements_deeplearning.txt ]; then
	echo "Error: One or more of the package requirement files are missing. Please make sure all required files are present."
	exit 1
fi

# Create and activate the general environment
create_environment "general" "requirements_common.txt"

# Create and activate the deeplearning environment
create_environment "deeplearning" "requirements_common.txt"

# Create and activate the napari environment
create_environment "napari" "requirements_common.txt"

# Echo success message
echo ""
echo "All done!"
echo ""