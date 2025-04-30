alias rebash="source ~/.bashrc"
function kate { nohup kate "$@" >/dev/null 2>&1 & }
function draw { nohup drawio "$@" >/dev/null 2>&1 & }
function arduino { nohup arduino & }

# function rstssh { ssh-keygen -f "/home/adam.bowen/.ssh/known_hosts" -R "$@" }

alias edit_aliases="kate ~/.bash_aliases"
alias edit_rc="kate ~/.bashrc"
alias acli="arduino-cli"
#alias putty="putty -load esp"
#alias putty1="putty -load esp1"
#alias putty2="putty -load esp2"
alias putty="minicom -D /dev/ttyUSB0 -b 115200"
alias putty1="minicom -D /dev/ttyUSB1 -b 115200"
alias putty2="minicom -D /dev/ttyUSB2 -b 115200"

alias espidf="source ~/esp/esp-idf/export.sh"
alias iflash="idf.py -p /dev/ttyUSB0 flash monitor"
alias iflash1="idf.py -p /dev/ttyUSB1 flash monitor"

alias puttym="putty -load mega"
alias get_idf='. $HOME/esp/esp-idf/export.sh'
alias idf='idf.py'
alias show_aliases='cat ~/.bash_aliases'
alias ports='dmesg | grep tty'
alias gb='git branch'
alias glf='git log --follow'
alias gco='git checkout'
alias gs='git status'
alias ga='git add'
alias gd='git diff'
alias mboot='sudo mkdir /media/$USER/boot; sudo mount /dev/mmcblk0p1 /media/$USER/boot'
alias mrootfs='sudo mkdir /media/$USER/rootfs; sudo mount /dev/mmcblk0p2 /media/$USER/rootfs'
alias umboot='sudo umount /dev/mmcblk0p1'
alias umrootfs='sudo umount /dev/mmcblk0p2'
alias umsd='umboot -f; umrootfs -f'
alias rpyc='rm -r __pycache__; rm -r */__pycache__; rm -r */*/__pycache__'
alias cvenv='source ~/venv/cvenv/bin/activate'

alias scphp='scp $1 $home_personal:$share_dir'
alias scphw='scp $1 $home_personal:$share_dir'

espmon() {
    if [ -z "$1" ]; then
        idf.py -p "$port" monitor
    else
        idf.py -p "${port}${1}" monitor
    fi
}


alias app2='bluetoothctl connect 68:CA:C4:DB:C5:E9'
alias dapp2='bluetoothctl disconnect 68:CA:C4:DB:C5:E9'
alias cabana='bluetoothctl connect 94:B3:F7:9B:7B:59'
alias dcabana='bluetoothctl disconnect 94:B3:F7:9B:7B:59'

function cpl {
    acli compile -b $mega "$1"
    if [ $? != 0 ]; then printf "ERROR: COMPILATION FAILED\n"; return; fi
}

function upl {
    acli upload -b $tesp -p /dev/ttyUSB0 "$1"
    if [ $? != 0 ]; then printf "ERROR: UPLOAD FAILED\n"; return; fi
}

function xc {
    acli compile $tesp "$1"
    if [ $? != 0 ]; then printf "ERROR: COMPILATION FAILED\n"; return; fi
    acli upload $tesp "$1"
    if [ $? != 0 ]; then printf "ERROR: UPLOAD FAILED\n"; return; fi
    putty
}

function xc1 {
    acli compile $tesp1 "$1"
    if [ $? != 0 ]; then printf "ERROR: COMPILATION FAILED\n"; return; fi
    acli upload $tesp1 "$1"
    if [ $? != 0 ]; then printf "ERROR: UPLOAD FAILED\n"; return; fi
    putty1
}


function xc2 {
    acli compile $tesp2 "$1"
    if [ $? != 0 ]; then printf "ERROR: COMPILATION FAILED\n"; return; fi
    acli upload $tesp2 "$1"
    if [ $? != 0 ]; then printf "ERROR: UPLOAD FAILED\n"; return; fi
    putty2
}


function tst {
    acli upload $tesp "$1"
    if [ $? != 0 ]; then printf "ERROR: UPLOAD FAILED\n"; return; fi
    putty
}

function tst1 {
    acli upload $tesp1 "$1"
    if [ $? != 0 ]; then printf "ERROR: UPLOAD FAILED\n"; return; fi
    putty1
}


function tst2 {
    acli upload $tesp2 "$1"
    if [ $? != 0 ]; then printf "ERROR: UPLOAD FAILED\n"; return; fi
    putty2
}

function gr {
    grep -i -r "$1"
}

function glg {
    git log --all --grep="$1"
}
