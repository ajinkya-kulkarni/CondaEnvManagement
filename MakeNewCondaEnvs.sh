#!/bin/bash

###########################################################################################

# For Linux (Ubntu 22.10 atleast), run this script as:
# source <path/script.sh>

# For MacOS, run this script as:
# sh <path/script.sh>

###########################################################################################

# Set the shell options to exit on error, unset variables.
set -eu

echo ""
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""

###########################################################################################

# Remove all environments except `base`
for i in $(conda env list | awk '{print $1}' | egrep -v 'base|#' | tr '\n' ' '); do
	if [ $i != "base" ]; then
		echo "Removing environment $i"
		conda env remove --name $i --yes
	fi
done

echo ""
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""

###########################################################################################

# Define a function to create environments and install packages
function create_environment 
{
	# Get the environment name from the first argument
	name=$1

	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo ""

	# Create the environment
	echo "Creating environment $name"
	if ! conda create -n $name python=3.9 --yes; then
		echo "Error: Failed to create $name environment."
	fi

	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo ""

	# Activate the environment
	echo "Activating $name environment"
	if ! conda activate $name; then
		echo "Error: Failed to activate $name environment."
	fi

	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo ""

	# Install packages
	echo "Installing packages in $name environment"
	python -m pip install numpy==1.24.0 
	python -m pip install opencv-python-headless==4.7.0.68 
	python -m pip install imageio==2.25.1 
	python -m pip install scikit-image==0.19.3 
	python -m pip install scipy==1.10.1 
	python -m pip install matplotlib==3.7.0 
	python -m pip install tqdm==4.64.1 
	python -m pip install tifffile==2023.2.3 
	python -m pip install Pillow==9.4.0 
	python -m pip install streamlit==1.8.1
# 	python -m pip install protobuf==3.20.*

	if [ "$name" == "deeplearning" ]; then
		python -m pip install tensorflow-cpu==2.11.0 
		python -m pip install scikit-learn==1.2.1 
		python -m pip install stardist==0.8.3
	fi

	if [ "$name" == "napari" ]; then
		python -m pip install pyqtwebengine==5.15.6 
		python -m pip install "napari[all]"
	fi

	if [ "$name" == "ABAproject" ]; then
		python -m pip install boto3==1.17.107 
		python -m pip install botocore==1.20.107 
		python -m pip install caosdb==0.11.0 
		python -m pip install caosadvancedtools==0.6.1
	fi

	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo ""

	# Clean the environment
	echo "Cleaning $name environment"
	if ! conda clean --all --yes; then
		echo "Error: Failed to clean $name environment."
	fi

	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo ""

	# Deactivate the environment
	echo "Deactivating $name environment"
	conda deactivate

}

###########################################################################################

if [ $(uname -s) = "Darwin" ]; then
	# Initialize conda and source zshrc
	conda init zsh
	source ~/.zshrc
fi

###########################################################################################

# Define an array of environment names
environments=("general" "deeplearning" "napari" "ABAproject")

###########################################################################################

# Loop through the array and create/activate each environment
for env in "${environments[@]}"; do
	create_environment "$env"
done

###########################################################################################

# Echo success message
echo ""
echo "All done!"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""

###########################################################################################
