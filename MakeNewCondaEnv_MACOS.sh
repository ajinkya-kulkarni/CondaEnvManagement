#!/bin/bash

# Initialize the appropriate shell
conda init zsh
source ~/.zshrc

# Clear all variables
set -eu

# Install anaconda-clean first
if ! conda install anaconda-clean --yes; then
	echo "Error: Failed to install anaconda-clean. Please check your internet connection or try again later."
fi

# Function to create and activate an environment
create_environment() {
	# Extract environment name and requirements file from input arguments
	name="$1"

	# Create and activate the environment
	echo "Creating and activating $name environment"
	if ! conda create --name "$name" python=3.9 --yes; then
		echo "Error: Failed to create $name environment."
	fi
	if ! conda activate "$name"; then
		echo "Error: Failed to activate $name environment."
	fi

	# Install jupyter notebook
	if ! conda install -c anaconda jupyter --yes; then
		echo "Error: Failed to install jupyter notebook in $name environment."
	fi

	# Install packages in the environment
	echo "Installing packages in $name environment"
	if ! wget -qO- "https://raw.githubusercontent.com/ajinkya-kulkarni/CondaEnvManagement/main/requirements_common.txt" | xargs -n 1 pip install; then
		echo "Error: Failed to install packages in $name environment."
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

	if [ "$name" == "ABAproject" ]; then

		pip install boto3==1.26.75
		pip install botocore==1.29.75
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
	if ! conda deactivate; then
		echo "Error: Failed to deactivate $name environment."
	fi
}

# Create and activate the general environment
create_environment "general"

# Create and activate the deeplearning environment
create_environment "deeplearning"

# Create and activate the napari environment
create_environment "napari"

# Create and activate the ABAproject environment
create_environment "ABAproject"

# Echo success message
echo ""
echo "All done!"
echo ""