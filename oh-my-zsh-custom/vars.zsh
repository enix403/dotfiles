export EDITOR=vim
export RUSTC_WRAPPER=sccache

export DOCKER_BUILDKIT=1

# KV => K for custom (with a k), v for... nothing, it just looks cool ^w^
# All the (known) folders that applications might generate and clutter in the home directory is prefixed with KV- (after a dot, if any)
# The rest of the name is untouched. For example: gradle, by default, uses ~/.gradle so it is prefixed with KV- after the dot without any other
# modifications to get ~/.KV-gradle
export GRADLE_USER_HOME="$HOME/.KV-gradle"


export QT_QPA_PLATFORMTHEME=qt5ct

# To Change cursor
#   echo -e "\e[6 q"
#
# Other options (replace the number after \e[):
#
# Ps = 0  -> blinking block.
# Ps = 1  -> blinking block (default).
# Ps = 2  -> steady block.
# Ps = 3  -> blinking underline.
# Ps = 4  -> steady underline.
# Ps = 5  -> blinking bar (xterm).
# Ps = 6  -> steady bar (xterm).


