#!/bin/bash

# Set the shell options to exit on error, unset variables
set -eu

# Clear the terminal output
clear

echo ""
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
echo ""

# Remove all environments except `base`
for i in $(conda env list | awk '{print $1}' | egrep -v 'base|#' | tr '\n' ' '); do
	if [ $i != "base" ]; then
		echo "Removing environment $i"
		conda env remove --name $i --yes
	fi
done

echo ""
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
echo ""

# Define a function to create environments and install packages
function create_environment 
{
	# Get the environment name from the first argument
	name=$1

	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
	echo ""

	# Create the environment
	echo "Creating environment $name"
	if ! conda create -n $name python=3.9 --yes; then
		echo "Error: Failed to create $name environment."
	fi

	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
	echo ""

	# Activate the environment
	echo "Activating $name environment"
	if ! conda activate $name; then
		echo "Error: Failed to activate $name environment."
	fi

	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
	echo ""

	# Install packages
	echo "Installing packages in $name environment"
	python -m pip install numpy==1.24.0 opencv-python-headless==4.7.0.68 imageio==2.25.1 scikit-image==0.19.3 scipy==1.10.1 matplotlib==3.7.0 tqdm==4.64.1 tifffile==2023.2.3 Pillow==9.4.0 streamlit==1.8.1

	if [ "$name" == "deeplearning" ]; then
		python -m pip install tensorflow-cpu==2.11.0 scikit-learn==1.2.1 stardist==0.8.3
	fi

	if [ "$name" == "napari" ]; then
		python -m pip install pyqtwebengine==5.15.6 "napari[all]"
	fi

	if [ "$name" == "ABAproject" ]; then
		python -m pip install boto3==1.17.107 botocore==1.20.107 caosdb==0.11.0 caosadvancedtools==0.6.1
	fi

	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
	echo ""

	# Clean the environment
	echo "Cleaning $name environment"
	if ! conda clean --all --yes; then
		echo "Error: Failed to clean $name environment."
	fi

	echo ""
	printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
	echo ""

	# Deactivate the environment
	echo "Deactivating $name environment"
	conda deactivate

}

# Define an array of environment names
environments=("general" "deeplearning" "napari" "ABAproject")

# Loop through the array and create/activate each environment
for env in "${environments[@]}"; do
	create_environment "$env"
done

# Echo success message
echo ""
echo "All done!"
printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' _
echo ""
