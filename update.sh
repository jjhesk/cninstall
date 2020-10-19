# /usr/local/bin/bash
# Accepts a version string and prints it incremented by one.
# Usage: increment_version <version> [<position>] [<leftmost>]
increment_version() {
   local usage="USAGE: $FUNCNAME [-l] [-t] <version> [<position>] [<leftmost>]
           -l : remove leading zeros
           -t : drop trailing zeros
    <version> : The version string.
   <position> : Optional. The position (starting with one) of the number
                within <version> to increment.  If the position does not
                exist, it will be created.  Defaults to last position.
   <leftmost> : The leftmost position that can be incremented.  If does not
                exist, position will be created.  This right-padding will
                occur even to right of <position>, unless passed the -t flag."

   # Get flags.
   local flag_remove_leading_zeros=0
   local flag_drop_trailing_zeros=0
   while [ "${1:0:1}" == "-" ]; do
      if [ "$1" == "--" ]; then shift; break
      elif [ "$1" == "-l" ]; then flag_remove_leading_zeros=1
      elif [ "$1" == "-t" ]; then flag_drop_trailing_zeros=1
      else echo -e "Invalid flag: ${1}\n$usage"; return 1; fi
      shift; done

   # Get arguments.
   if [ ${#@} -lt 1 ]; then echo "$usage"; return 1; fi
   local v="${1}"             # version string
   local targetPos=${2-last}  # target position
   local minPos=${3-${2-0}}   # minimum position

   # Split version string into array using its periods.
   local IFSbak; IFSbak=IFS; IFS='.' # IFS restored at end of func to
   read -ra v <<< "$v"               #  avoid breaking other scripts.

   # Determine target position.
   if [ "${targetPos}" == "last" ]; then
      if [ "${minPos}" == "last" ]; then minPos=0; fi
      targetPos=$((${#v[@]}>${minPos}?${#v[@]}:$minPos)); fi
   if [[ ! ${targetPos} -gt 0 ]]; then
      echo -e "Invalid position: '$targetPos'\n$usage"; return 1; fi
   (( targetPos--  )) || true # offset to match array index

   # Make sure minPosition exists.
   while [ ${#v[@]} -lt ${minPos} ]; do v+=("0"); done;

   # Increment target position.
   v[$targetPos]=`printf %0${#v[$targetPos]}d $((10#${v[$targetPos]}+1))`;

   # Remove leading zeros, if -l flag passed.
   if [ $flag_remove_leading_zeros == 1 ]; then
      for (( pos=0; $pos<${#v[@]}; pos++ )); do
         v[$pos]=$((${v[$pos]}*1)); done; fi

   # If targetPosition was not at end of array, reset following positions to
   #   zero (or remove them if -t flag was passed).
   if [[ ${flag_drop_trailing_zeros} -eq "1" ]]; then
        for (( p=$((${#v[@]}-1)); $p>$targetPos; p-- )); do unset v[$p]; done
   else for (( p=$((${#v[@]}-1)); $p>$targetPos; p-- )); do v[$p]=0; done; fi

   echo "${v[*]}"
   IFS=IFSbak
   return 0
}

listfiles(){
   filesList=(*.sh)
   EXCLUDE=("!(update.sh)")
   shopt -s nullglob
   for file in "${filesList[@]}|${EXCLUDE[@]}"; do
      cdn $file
   done
}

cdn(){
   local filename=$1
   if [ -z "$filename" ]; then
      return 
   fi;
   local q="'"
   local qq='"'
   local backtick='`'
   local url="https://cdn.jsdelivr.net/gh/$GH_USER/$GH_REPO@$GH_VERSION/$filename"
   local install_file="wget ${url} & chmod 0700 ${filename} & ./${filename}"
   local install_exe="wget -q -O - ${url} | bash"

   echo "${backtick}${install_file}${backtick}\n"
   echo "Or, "
   echo "${backtick}${install_exe}${backtick}\n\n"
}

bumpVer(){
   VERSION=$(cat version)
   increment_version $VERSION > version
   echo $VERSION
}

gitremotecommit(){
   git add .
   git remote add origin https://gitee.com/jjhoc/china-build.git
   git remote add github https://github.com/jjhesk/cninstall.git
   git commit -m "compile success modification v$VERSION"
   git push origin master
   git push github master -ff
}
writedereadmefile() {
  cat <<EOF >README.md

# China CDN install [![Build Status](https://travis-ci.org/canha/$GH_REPO.svg?branch=master)](https://travis-ci.org/canha/$GH_REPO)

## The collection of system tools for your linux build

## :hammer: Requirements
* `wget` or `curl`
* Bash shell

## :fast_forward: Install

Download and run with `wget` or `curl`. Here's the short version using the official git.io shortening:


### Check for any of the working installation one line script

$(listfiles)

## Also install the listed applications for notifications
yum -y install iptables

yum -y install sendmail

yum install -y mailx

Tested working on:

* :white_check_mark: Ubuntu 16.04 to 18.04
* :white_check_mark: macOS Sierra (10.12) to Catalina (10.15)

EOF
}


GH_USER="jjhesk"
GH_REPO="cninstall"
GH_VERSION="v1.1"

writedereadmefile
bumpVer
gitremotecommit
open README.md

#find . -path '*/*.sh' -type f -print0 | while IFS= read -r -d $'\0' file; 
#  do echo "$file" ;
#done

echo "Final Pack Finish"