# Set window title
title() {
  echo -ne "\033]0;$@\007";
}

# reload source
reload() {
  source ~/.bash_profile;
}

# list directory after cd; also save the last directory
# and open it when a new tab is created.
cd() {
  builtin cd "${@:-$HOME}" && ls && pwd > $CDHISTORY;
}

# run rake without worring about
# bundler wrapper.
function rake {
  if [ -e Gemfile ]; then
    bundle exec rake $@
  else
    `which rake` $@
  fi
}

if [ -f $CDHISTORY ]; then
  dir=$(cat $CDHISTORY)

  if [ -d "$dir" ]; then
    cd "$dir" && clear
  fi
fi

# Check if given url is giving gzipped content
#
#   $ gzipped http://simplesideias.com.br
#
gzipped() {
  local r=`curl -L --write-out "%{size_download}" --output /dev/null --silent $1`
  local g=`curl -L -H "Accept-Encoding: gzip,deflate" --write-out "%{size_download}" --output /dev/null --silent $1`
  local message

  local rs=`expr ${r} / 1024`
  local gs=`expr ${g} / 1024`

  if [[ "$r" =  "$g" ]]; then
    message="Regular: ${rs}KB\n\033[31m → Gzip: ${gs}KB\033[0m"
  else
    message="Regular: ${rs}KB\n\033[32m → Gzip: ${gs}KB\033[0m"
  fi

  echo -e $message
  return 0
}

# Schedule alarm. Will display growl
# notification and beep.
#
#   $ alarm "now + 2 hours" "Your time has finished"
#
# Quotes required, sorry!
#
alarm() {
  echo "afplay /System/Library/Sounds/Basso.aiff && /usr/local/bin/growlnotify -t Alarm -s -d alarm -a /Applications/iCal.app -m '$2'" | at $1
}

extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

#netinfo - shows network information for your system
netinfo ()
{
echo "--------------- Network Information ---------------"
/sbin/ifconfig | awk /'inet addr/ {print $2}'
/sbin/ifconfig | awk /'Bcast/ {print $3}'
/sbin/ifconfig | awk /'inet addr/ {print $4}'
/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
echo "${myip}"
echo "---------------------------------------------------"
}

#dirsize - finds directory sizes and lists them for the current directory
dirsize ()
{
du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
egrep '^ *[0-9.]*M' /tmp/list
egrep '^ *[0-9.]*G' /tmp/list
rm -rf /tmp/list
}

#copy and go to dir
cpg (){
  if [ -d "$2" ];then
    cp $1 $2 && cd $2
  else
    cp $1 $2
  fi
}

#move and go to dir
mvg (){
  if [ -d "$2" ];then
    mv $1 $2 && cd $2
  else
    mv $1 $2
  fi
}

