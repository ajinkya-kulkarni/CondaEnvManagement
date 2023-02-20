#!/bin/bash

# Initialize the shell for Conda
conda init zsh
source ~/.zshrc

set -eu

# Install anaconda-clean first
conda install anaconda-clean --yes

# Function to create and activate an environment
create_environment() {
	# Extract environment name and requirements file from input arguments
	name="$1"
	requirements_file="$2"

	# Create and activate the environment
	echo "Creating and activating $name environment"
	conda create --name "$name" python=3.9 --yes
	conda activate "$name"

	# Install jupyter notebook
	conda install -c anaconda jupyter --yes

	if [ "$name" == "napari" ]; then
		pip install pyqtwebengine==5.15
    	pip install "napari[all]"
	fi

	# Install packages in the environment
	echo "Installing packages in $name environment"
	curl -s "https://raw.githubusercontent.com/ajinkya-kulkarni/CondaEnvManagement/main/$requirements_file" | xargs -n 1 pip install

	# Clean the environment
	echo "Cleaning $name environment"
	conda clean --all --yes

	# Deactivate the environment
	echo "Deactivating $name environment"
	conda deactivate
}

# Create and activate the general environment
create_environment "general" "requirements_general.txt"

# Create and activate the deeplearning environment
create_environment "deeplearning" "requirements_deeplearning.txt"

# Create and activate the napari environment
create_environment "napari" "requirements_deeplearning.txt"
pip install "napari[all]"

echo ""
echo "All done!"
echo ""