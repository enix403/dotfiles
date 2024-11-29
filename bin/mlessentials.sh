#!/usr/bin/env sh

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
