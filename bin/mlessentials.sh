#!/usr/bin/env sh

# Define the package list
PACKAGES="
numpy
torch
torchvision
matplotlib
jupyterlab
pillow
pandas
scikit-learn
scipy
seaborn
"

# Install the packages
pip install $PACKAGES

# Write the package names (without versions) to requirements.txt
echo "$PACKAGES" | tr ' ' '\n' > requirements.txt

# Create .gitignore if it does not exist
if [ ! -f .gitignore ]; then
    cat << 'EOF' > .gitignore
.venv/
__pycache__/
*.pyc

.ipynb_checkpoints/
.virtual_documents/

*.sublime-project
*.sublime-workspace
EOF
fi


#
# pip install \
#   numpy \
#   torch \
#   torchvision \
#   matplotlib \
#   jupyterlab \
#   pillow \
#   pandas \
#   scikit-learn
#
# pip freeze > requirements.txt
#
# if [ ! -f .gitignore ]; then
#     cat << 'EOF' > .gitignore
# .venv/
# __pycache__/
# *.pyc
#
# .ipynb_checkpoints/
# .virtual_documents/
#
# *.sublime-project
# *.sublime-workspace
# EOF
# fi
