#!/bin/bash

###########################################################################################

# For Linux (Ubntu 22.10 atleast), run this script as:
# source <path/script.sh>

# For MacOS, run this script as:
# sh <path/script.sh>

###########################################################################################

clear

# Set the shell options to exit on error, unset variables.
set -eu

echo ""
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
echo ""

###########################################################################################

# Remove all existing Conda environments from the miniconda3/envs/ directory

if [ $(uname -s) = "Darwin" ]; then
	rm -rf /Users/ajinkyakulkarni/miniconda3/envs/

	echo "Deleted all existing environments from miniconda3 folder"
	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo ""
fi

if [ $(uname -s) = "Linux" ]; then
	rm -rf /home/ajinkya/miniconda3/envs/

	echo "Deleted all existing environments from miniconda3 folder"
	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' =
	echo ""
fi

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

	if ! conda create -n $name python=3.10 --yes; then
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
		
	pip install numpy==1.24.2 opencv-python-headless==4.7.0.72 imageio==2.26.0 scikit-image==0.19.3 scipy==1.10.1 matplotlib==3.7.0 tqdm==4.64.1 tifffile==2023.2.28 Pillow==9.4.0 streamlit==1.19.0 notebook==6.5.2 ipywidgets==8.0.4

	if [ "$name" == "deeplearning" ]; then

# 		if [ $(uname -s) = "Linux" ]; then
# 			conda install pocl -c conda-forge --yes
# 		fi

		pip install scikit-learn==1.2.1 tensorflow-cpu==2.11.0 stardist==0.8.3 networkx==3.0 
		
	fi

	if [ "$name" == "ABAproject" ]; then
		pip install boto3==1.26.83 botocore==1.29.83 caosdb==0.11.0 caosadvancedtools==0.6.1 gspread==5.7.2 oauth2client==4.1.3
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
environments=("general" "deeplearning" "ABAproject")

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
