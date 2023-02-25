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

	if [ "$name" != "numba" ]; then
		if ! conda create -n $name python=3.10 --yes; then
		echo "Error: Failed to create $name environment."
		fi
	else
		if ! conda create -n $name python=3.8 --yes; then
		echo "Error: Failed to create $name environment."
		fi
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
	pip3 install --upgrade pip
	
	pip3 install numpy==1.23.5 opencv-python-headless==4.7.0.68 imageio==2.25.1 scikit-image==0.19.3 scipy==1.10.1 matplotlib==3.7.0 tqdm==4.64.1 tifffile==2023.2.3 Pillow==9.4.0 streamlit==1.17.0 protobuf==3.20.0 jupyter
	
	if [ "$name" == "numba" ]; then
		pip3 install numba==0.56.0
	fi

	if [ "$name" == "deeplearning" ]; then
		pip3 install tensorflow-cpu==2.11.0 scikit-learn==1.2.1 stardist==0.8.3
	fi

	if [ "$name" == "pyclesperanto" ]; then
		pip3 install pyclesperanto-prototype
		if [ $(uname -s) = "Linux" ]; then
			conda install pocl -c conda-forge --yes
		fi
	fi

	if [ "$name" == "ABAproject" ]; then
		pip3 install boto3==1.17.107 botocore==1.20.107 caosdb==0.11.0 caosadvancedtools==0.6.1
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
environments=("general" "numba" "deeplearning" "pyclesperanto" "ABAproject")

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
