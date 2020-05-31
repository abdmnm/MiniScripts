# Take filename as commandline argument
cmd_arg=$1

if [[ "$cmd_arg" == *".java"* ]]
then		
	file_name=$1

	# Remove file extension
	file_name=$(echo "$file_name" | cut -f 1 -d '.')

	# Compile and Execute
	echo ecj :
	ecj $file_name.java
	if [ $? -eq 0 ]
	then
		echo dx :
		dx --dex --output=$file_name.dex $file_name.class
	else
		echo ecj failure
		exit 1
	fi
	if [ $? -eq 0 ]
	then
		echo dalvikvm :
		dalvikvm -cp $file_name.dex $file_name ${@:2}
	else 
		echo dx failure
		exit 1
	fi
	if [ $? -eq 1 ]
	then
		echo dalvikvm failure
	fi

elif [ "$cmd_arg" == "install" ]
then
	apt install ecj dx
else
	echo "Script to run Java on Android in Termux"
	echo "usage: bash JavaOnTermux.sh <option | source file>"
	echo "Possible options are listed below."
	echo "install: To install required packages"
fi
