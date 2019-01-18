#!/bin/bash
RED='\e[91m'
NC='\033[0m' 
GREEN='\e[32m'
GRY='\e[37m'
CYAN='\e[36m'
NORMALTEXT='\e[0m'
BLINK='\e[5m'
WHITE='\e[97m'
FAV=$HOME/.favoris_bash
NEWFAV=$HOME/.favoris_bash_new
_completions()
{ #COMP_CWORD
  COMPREPLY=()
  for name in `grep "^${COMP_WORDS[1]}" $FAV | cut -d'-' -f1` ; do 
    COMPREPLY+=($name)
  done 
 
}

complete -F _completions C 
complete -F _completions R 
C() { 
	if [ $# -lt 1 ];then 
		echo "you must specify the name"
	else 
	    while IFS= read -r list; do 
	     if [ $(echo "$list" | cut -d'-' -f1 ) = $1 ];then 
	        
	        path=$(echo  "$list" | cut -d'>' -f2)
	        
	        cd "$path"
	       
	        #cd "\"$path\""
	        break
	     fi 
	    done<"$FAV"
		
		#echo $PWD 
	fi 
}

S() {
	if [ $# -lt 1 ]; then 
		echo -e "you must specify the ${RED}${BLINK}name${NORMALTEXT}"
	else
		AreExisted='False'
        while IFS= read -r line ; do 
        if [ $(echo $line | cut -d'-' -f1 ) = $1 ];then 
	                AreExisted='True'
	                break
	             fi 
        done<$FAV
		if [[ $AreExisted = 'True' ]] ; then 
			echo "the name is exist .."

		else 
			AreExisted=`grep "$PWD" "$FAV" | cut -d'>' -f2 | head -1 `
			if [[ $AreExisted = $PWD ]]; then 
				echo "the path is existed "
				echo -n "do you want to add more then one name ? [y/n] : "
				
				read choice
				if [[ $choice =~ [y|Y|yes|Yes|YES] ]] ; then 
				 	echo "$1->$PWD" >> $FAV
					echo "Successfully added"
				fi 	
			else  
				echo "$1->$PWD" >> $FAV
				echo "Successfully added"
			fi
		fi
	fi 
}

R() {
	 if [ $# -lt 1 ] ; then 
	 	echo "you must specify a name..."
	 else 
		AreExisted='False'
		>$NEWFAV
			while IFS= read -r list; do 
	             if [ $(echo $list | cut -d'-' -f1 ) = $1 ];then 
	                AreExisted='True'
	                continue
	             fi 
	             echo $list >> $NEWFAV 
	        done<"$FAV"
	        if [ $AreExisted = 'True' ];then
	            rm -fr $FAV
	            mv $NEWFAV $FAV
	            rm -fr $NEWFAV
	 	        echo "Successfully Remove.."
	 	    else 
	 	        echo "ther are no name with $1 "
	 	    fi
	 fi 
}
L() {
	#showfunc_dynamic
	if [ $(cat $FAV | wc -l) -gt 0 ] ; then 
	let NAMELENGTH=20
	let PATHLENGTH=$COLUMNS-$NAMELENGTH-1
	let NAMELENGTH-=2
	let T_len=($NAMELENGTH-4)/2
	let T_len1=($PATHLENGTH-4)/2
	python3 -c "print('+'+'-'*$NAMELENGTH+'+'+'-'*$PATHLENGTH+'+')"
	python3 -c "print('|'+' '*$T_len+'NAME'+$(($NAMELENGTH-$T_len-4))*' '+'|'+' '*$T_len1+'PATH'+' '*$(($PATHLENGTH-$T_len1-4))+'|')"
	python3 -c "print('+'+'-'*$NAMELENGTH+'+'+'-'*$PATHLENGTH+'+')"
	while IFS= read -r line ; do 
	Name=`echo $line | cut -d'-' -f1`
	Path=`echo $line | cut -d'>' -f2`
	let LenName=$(echo -n $Name|wc -c )
	let LenPath=$(echo -n $Path|wc -c )
	if [ $LenName -gt $NAMELENGTH ]; then
	    let  T_len=$NAMELENGTH-2
	    name=$(echo -n $Name| cut  -c -$T_len)
	    echo -n -e "|$name.${BLINK}.${NORMALTEXT}|"
	else 
	    let T_len=($NAMELENGTH-$LenName)/2
	    python3 -c "print('|'+' '*$T_len+'$Name'+' '*$(($NAMELENGTH-$T_len-$LenName))+'|',end='')"
	fi
	if [ $LenPath -gt $PATHLENGTH ];then 
	    let T_len=$PATHLENGTH-2
	    name=$(echo -n $Path| cut  -c -$T_len)
	    echo -e "$name.${BLINK}.${NORMALTEXT}|"
	else 
	    let T_len=($PATHLENGTH-$LenPath)/2
	    python3 -c "print(' '*$T_len+'$Path'+' '*$(($PATHLENGTH-$T_len-$LenPath))+'|')"
	fi
	python3 -c "print('+'+'-'*$NAMELENGTH+'+'+'-'*$PATHLENGTH+'+')"
	done<$FAV
	else 
	
	    echo "the DB is empty .."
	fi
}

if ! [ -e $FAV ]; then 
	>$FAV
	echo "the .favoris_bash file is create now !!"
fi 
