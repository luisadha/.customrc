#begin
#- MY $ANDROID_ROOT/etc/bashrc FILE for bash-5.1 (or later)
# modifications from nanodroid bashrc's (nanolx.org)
#
# By luisadha bashrc's
#
# Revision 3, Last modified: Sun Apr 10 09:05:35 WIB 2022


alias bash=$(type -p bash.bin) # fix "double execute" bug
export BASH_ARGV0='bash' # fix "$0 are bash.bin" bug
export SHELL='bash'
export USER=$(whoami)
export SYSTEM='/system'
# export SHELL=${BASH} this delete

# select storage path
if [ -n ${EXTERNAL_STORAGE} ]; then
	export HOME="${EXTERNAL_STORAGE}"
else
	if [ -w /sdcard ]; then
		export HOME="/sdcard"
	elif [ -w /storage/self/primary ]; then
		export HOME="/storage/self/primary"
	elif [ -w /data/media/0 ]; then
		export HOME="/data/media/0"
	fi
fi

export TMPDIR=${HOME}/.bash_tmp
export HISTFILE=${HOME}/.bash_history

mkdir -p ${TMPDIR}

export TERM=xterm
export PAGER=less.bin


# Access some commands built for Android
export PATH="/data/local/bin:${PATH}"
export LD_LIBRARY_PATH="/data/local/lib:${LD_LIBRARY_PATH}"
export CLICOLOR=yes
export LSCOLORS="exfxcxdxbxegedabagacad"

[[ $- != *i* ]] && return

shopt -s checkwinsize
shopt -s histappend

# Different aliases for root and normal user
if [[ ${EUID} == 0 ]] ; then
# Quick (un)mounting of /system as writable
      alias su='echo \"you currently logged as root.\"'
      alias sysro='mount -o remount,ro /system'
      alias sysrw='mount -o remount,rw /system'
else
      alias su="su --shell ${SHELL}"
fi

if [ -n "$(type -p busybox)" ]; then
# Set up a ton of aliases to cover toolbox with the nice busybox
# equivalents of its commands
for i in cat chmod chown df insmod ln lsmod mkdir mount mv rm rmdir rmmod umount; do
eval alias ${i}=\"busybox ${i}\"
done
unset i

# Give ls and grep colours
alias ls='busybox ls --color=auto'
alias grep='busybox grep --color=auto'
fi

# r for replay mybe, inspirated from builtin aliases of mksh shell
alias r="fc -e -"

red="\[\033[01;38;5;1m\]"
gre="\[\033[01;38;5;2m\]"
blu="\[\033[01;38;5;4m\]"
whi="\[\033[01;38;5;7m\]"

export HOSTNAME=$(getprop ro.product.device)
export PS1="${whi}[ ${blu}\$(whoami) ${whi}@ ${red}${HOSTNAME} ${whi}: ${gre}\w ${whi}] "

resize &>/dev/null;
input keyevent 4;
clear

cd ${HOME}

if [ -r "${HOME}/.bash_profile" ]; then
        . "${HOME}/.bash_profile"
fi

if [ -r "${HOME}/.bashrc" ]; then
        . ~/.bashrc
fi

source_bash_exit () {
if [ -r "${SYSTEM}/etc/bash_logout" ]; then
. "${SYSTEM}/etc/bash_logout"
fi
}
trap source_bash_exit EXIT

function window () {
echo -en "\e]2;$@\007"
}


if [ "${BASH_VERSION%.*}" \< "5.1" ]; then
    echo "You will need to upgrade to version 5.1 for full 
          programmable completion features"
    window "$RANDOM";
    return
fi

echo "This is BASH ${BASH_VERSION%.*}";
date

if [ -x "$(type -p sl)" ]; then
    window "just a secs";
    sl
sleep 1;
window "Window $(basename $(tty))"
unset HOSTNAME
fi

# Added personal bash Functions
# example: up 1 2 3
function up() {
LEVEL=$1
for ((i=0; i < LEVEL; i++)); do
	echo $i
	CDIR=../$CDIR
done
cd $CDIR
echo "You are in: "$PWD
sh=$(which $SHELL)
exec $sh
}

#eof
