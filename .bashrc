#
# ~/.bashrc
# __CLEMENT_BENIER__
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#NO BEEP
xset -b
setxkbmap fr

myscripts_dir=$HOME/.myscripts

# Bash completion
if [ -f $myscripts_dir/bash_completion.d/git-completion.bash ]; then
    source $myscripts_dir/bash_completion.d/git-completion.bash
    source $myscripts_dir/bash_completion.d/git-prompt.sh
else
    echo "cannot load bash_completion.d scripts"
fi

complete -cf sudo

alias ls='ls --color=auto'
#default
#PS1='[\u@\h \W]\$ '
########PROMPT##########
TIME="\D{%H:%M}"
WHITE='\[\e[1;30m\]'
RED="\[\e[1;31m\]"
GREEN='\[\e[1;32m\]'
YELLOW='\[\e[1;33m\]'
BLUE='\[\e[1;34m\]'
PURPLE='\[\e[1;35m\]'
KK='\[\e[1;36m\]'
#USER='\u'
CURRENT_PATH='\w'
COLOR_OFF='\[\e[m\]'
PROMPT_CHARACTER='\$'
NAME='\W'

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=
export GIT_PS1_SHOWUNTRACKEDFILES=
export GIT_PS1_SHOWUPSTREAM= #auto #verbose name legacy git svn
export GIT_PS1_DESCRIBE_STYLE= #contains branch describe default

export PS1="${BLUE}[$TIME]${RED}${GREEN}[${USER} ${YELLOW}${NAME}${COLOR_OFF}${BLUE}${COLOR_OFF}${GREEN}]${RED}"'$(__git_ps1 "(%s)")'"${GREEN}${PROMPT_CHARACTER}${COLOR_OFF}${KK}"
source $myscripts_dir/vte.sh
PROMPT_COMMAND=__vte_prompt_command

if [ -e $HOME/.screenlayout/classic.sh ]; then
    sh $HOME/.screenlayout/classic.sh
fi

#completion sudo

#alias
alias l='ls'
alias ll='ls -lh'
alias lla='ll -a'
alias vi='vim'
alias resdir='cd && cd -'
function formatpatch {
    if [ "$1" ]; then
        git format-patch -M -n -s -o $1 origin/master
    fi
}

#official export
export EDITOR=vim
export PATH=$PATH:/usr/bin/core_perl/
export HISTTIMEFORMAT='%F %T  '
export HISTCONTROL=ignoredups
export export HISTSIZE=9999999999999999999
#personnal export
export DOWNLOADS=$HOME/Downloads
export TOSEND=$HOME/Tosend
export FREENIVI=$HOME/work/freenivi/projet/freenivi/work/freenivi-os
export EFL=$HOME/work/efl
export PATH=$PATH:/home/clement/work/efl/bin:/home/clement/bin
export WWWDOKU="/home/clement/work/efl/www-content"
export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
export CORB=$HOME/corbeille

#set -o vi

function create_dir {
    local cdate=$1
    local mounth=${cdate::7}
    if [ ! -d "$CORB/$mounth" ]; then
        mkdir $CORB/$mounth
    fi
    local day=${cdate:8:2}
    if [ ! -d "$CORB/$mounth/$day" ]; then
        mkdir $CORB/$mounth/$day
    fi
    local hour=${cdate:11}
    if [ ! -d "$CORB/$mounth/$day/$hour" ]; then
        mkdir $CORB/$mounth/$day/$hour
    fi
    res=$CORB/$mounth/$day/$hour
}
function move2corbeille {
    local currentdate=$(date +%F-%H-%M)
    create_dir $currentdate
    tdir=$res
    mv $* $tdir
}

function clean_corbeille {
    /bin/rm -fr $CORB/*
}

function scanreseau {
    getip=$(ip route | awk ' $1=="default" {print $7}')
    if [ -z "$1" ]; then
        scanip="$getip/24"
    else
        scanip="$getip/$1"
    fi
    echo "nmap -sP $scanip"
    nmap -sP $scanip
}

function scanreseaudiff {
    if [ -z "$1" ]; then
        optreseau=$1
    else
        optreseau=
    fi
    firstfilereseau="/tmp/scanreseaufirst"
    secondfilereseau="/tmp/scanreseausecond"
    res1="/tmp/resreseau1"
    res2="/tmp/resreseau2"
    if [ ! -e "$firstfilereseau" ];then
        scanreseau $optreseau > $firstfilereseau
    else
        scanreseau $optreseau > $secondfilereseau
        diff $firstfilereseau $secondfilereseau | awk '$2=="Nmap" && $3=="scan" {print $NF}' > $res2
        if [ ! -e "$res1" ]; then
            mv $res2 $res1
        else
            diff $res1 $res2
        fi
        mv $secondfilereseau $firstfilereseau
        cat $firstfilereseau
    fi
}
alias lin='wine ~/.wine/drive_c/lint/lint-nt.exe'
export LIN_INCLUDE_PATH="/usr/include/qt/*"
#alias rm=move2corbeille

#astuces
ASTUCES=$HOME/astuces
RAC_CONSOLE=$ASTUCES/raccourcis_console.txt
LESSER_KNOWN_CMD=$ASTUCES/lesser_known_commands.txt
alias rac_console='cat $RAC_CONSOLEi && echo && cat $LESSER_KNOWN_CMD'
port_lafp=8003

function hostsmile {
    if [ -z $1 ]; then
        name=nlab
    else
        name=$1
    fi
    echo "host $name.daviel.idf.intranet 10.1.4.162"
    host $name.daviel.idf.intranet 10.1.4.162
}

function getiphost {
    machine=$1.daviel.idf.intranet
    ip_route=10.1.4.162
    iphost=$(host ${machine} ${ip_route} | awk '$3="address" {print $4}')
    iphost=$(echo $iphost)
    echo $iphost
}

function nlab {
    getiphost nlab
    ssh cbenier@$iphost
}
function jenkins {
    getiphost jenkins-lafp
    ssh cbenier@$iphost
}
alias lafp='ssh cbenier@localhost -p $port_lafp'
alias proxyP2S='ssh -L 8003:P2S:22 cbenier@daviel.openwide.fr'
alias proxylafpbuilder='ssh -L 8004:lafp-builder:22 cbenier@daviel.openwide.fr'
alias proxyjenkins='ssh -L 8080:jenkins-lafp:8080 cbenier@daviel.openwide.fr'
#alias proxyjenkins='ssh -L 8100:jenkins-lafp:8100 cbenier@daviel.openwide.fr'
export NEXTER="/home/clement/NEXTER"
export Nexter="/home/clement/NEXTER"
lafpapps=$NEXTER/lafp-apps
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$NEXTER/passerellecan/libcandbc/lib

#function git {
#    if [ "$1" == "pull" ]; then
#        shift
#        echo "-> /usr/bin/git pull --rebase $*"
#        /usr/bin/git pull --rebase $*
#    else
#        /usr/bin/git $*
#    fi
#}

function ipkcopy {
    cd && cd -
    scp $1 root@10.9.18.209:~
}

function restore_gcc5 {
    pushd .
    cd /var/cache/pacman/pkg
    yaourt -U gcc-libs-multilib-5.3.0-5-x86_64.pkg.tar.xz gcc-multilib-5.3.0-5-x86_64.pkg.tar.xz lib32-gcc-libs-5.3.0-5-x86_64.pkg.tar.xz
    yaourt -U binutils-2.26-3-x86_64.pkg.tar.xz
    yaourt -U glibc-2.23-4-x86_64.pkg.tar.xz lib32-glibc-2.23-4-x86_64.pkg.tar.xz valgrind-3.11.0-3-x86_64.pkg.tar.xz
    popd
}

function updatelistpackages {
    yaourt -Qq > archpackagesinstalled
}


function vpnSmile()
{
    cd $HOME/vpnSmile
    sudo openvpn cleben.client
    cd -
}

#git command
alias gitonelog="git log --pretty=oneline --max-count=1"
function gitlastlogdirs {
    dirs=$(ls .)
    commit=
    for dir in $dirs; do
        if [ -d $dir ]; then
            cd $dir
            log="$dir:$(git log --pretty=oneline --max-count=1)"
            commits="$commits\n$log"
            cd -
        fi
    done
    echo -e $commits
}
#help
alias helpgitarchive='echo i"git archive --format=tar.gz nexter-v3.1.0 > traitair-trt_nexter-v3.1.0.tar.gz"'
function updateall {
    yaourt -Syu
    sudo cp /boot/initramfs-linux.img /boot/efi
    sudo cp /boot/vmlinuz-linux /boot/efi
}

scripts=$(find $myscripts_dir/bin | grep -v "~")
for sc in $scripts; do
    if [ -f $sc ]; then
        source $sc
    fi
done

#qtsource
alias sshdocker='ssh -X -Y -p 2222 devel@linux-bu4u'
alias sshapache='ssh apache@www.ovh.iot'
alias sshjenkins='ssh jenkins@jenkins'

function git() {
    case $1 in
        clone ) shift 1; command git clone --recurse-submodules "$@";;
        pull ) shift 1; command git pull --rebase "$@";;
        * ) command git "$@" ;;
    esac
}

alias jetirc="ssh -t devel@vm-jet-clement 'tmux attach'"
