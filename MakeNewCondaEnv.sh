
clear

########################################################################################

for i in `conda env list|awk '{print $1}'|egrep -v 'base|#'|tr '\n' ' '`;do echo $i;conda env remove --name $i;done

conda install anaconda-clean

########################################################################################

conda create -n general python=3.9 --yes
conda activate general

pip install -r ~/Desktop/CondaEnvManagement/requirements_general.txt

conda deactivate

########################################################################################

conda create -n deeplearning python=3.9 --yes
conda activate deeplearning

pip install -r ~/Desktop/CondaEnvManagement/requirements_deeplearning.txt

conda deactivate

########################################################################################

conda create -y -n napari -c conda-forge python=3.9
conda activate napari

pip install -r ~/Desktop/CondaEnvManagement/requirements_deeplearning.txt

pip install "napari[all]"

conda deactivate

########################################################################################
