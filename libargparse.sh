#!/bin/bash
function argParseLib() {
	trap argParseCleanUp SIGTERM SIGHUP SIGINT SIGQUIT EXIT
	function argParseCleanUp() {
		rm $TMPCODEFILE
		exit 
	}
	function setFlags() { 
		for arg in `seq $#`; do
			# [flag],[variable],[bool or val],[required]
			# a,isASet,bool,1 - flag a, variable isASet, boolean, is required
			# u, url, val, 0 - flag u, variable url, value, not required
			IFS=, read flag variable varType required <<< "$1"
			if ((required==1)); then 
				requiredVars+="$variable "
			fi
			if [[ "$varType" == "bool" ]]; then
				boolFlags+=":$flag "
			else
				valFlags+=":$flag: "
			fi
			flagsWithTheirVars+="$flag $variable \n"
			shift
		done 
	}
	function codeBuilder() {
		# builds getopts code to execute
		IFS=' '
		TMPCODEFILE="/tmp/argParse-codebuilder-`date +%s`.sh" 
		OPTIONS="$boolFlags $valFlags"
		getOptsCode="while getopts \"$OPTIONS\" opt; do \n"
		caseSwitch="case \$opt in \n"

		# Starting our generated script, declare vars
		code="#!/bin/bash			
			  # Declaring our variables - we're actually passing in variables from the generator script				
			  boolFlags=\"$boolFlags\"						
			  flagsWithTheirVars=\"$flagsWithTheirVars\"	
			  requiredVars=\"$requiredVars\"

			  # Iterate through each of the boolFlags and if they're not required set them to 0
			  for i in \$(echo -e \"\$boolFlags\"); do # For each boolean flag
			  	flag=\"\$(echo \$i | tr -d :)\" # Remove the : characters
			  	var=\"\$(echo -e \"\$flagsWithTheirVars\" | grep \"^\$flag \" | cut -d ' ' -f2)\" 
			  	if [ -z \"\$(echo -e \"\$requiredVars\" | grep \$var)\" ]; then # If this isn't a required variable
			  		export \$var=0
			  	fi
			  done
			 "

		# iterate thru the value flags and add the cooresponding code 
		for i in `echo -e "$valFlags"`; do 
			flag=`echo "$i" | tr -d :`
			var=`echo -e "$flagsWithTheirVars" | grep "^$flag " | cut -d ' ' -f2`

			# add to the case logic 
			caseSwitch+=" 			 
				$flag) 				
					$var=\$OPTARG	
				;;				
						\n"
		done

		# iterate thru the boolean flags and add the cooresponding code
		for i in `echo -e "$boolFlags"`; do 
			flag=`echo "$i" | tr -d :`
			var=`echo -e "$flagsWithTheirVars" | grep "^$flag " | cut -d ' ' -f2`
			# add to the case logic
			caseSwitch+="  				  				 
				$flag)			  				
					$var=1 			 
				;;				  			

					  \n"
		done

		# Check for invalid options or missing arguments
		caseSwitch+="													 		
   			\?)																	
      			echo \"Invalid option: -\$OPTARG\" >&2
      		;;															
     		:)								
      			echo \"Option -\$OPTARG requires an argument.\" >&2
      			exit 1	
      		;;				
					\n"

		getOptsCode+="$caseSwitch 		
					esac 				
				done					\n"

		code+="$getOptsCode \n" # Add the generated getOptsCode to our code variable

		# Check for missing required flags
		for i in `echo -e $requiredVars`; do
			code+="if [ -z \"\$$i\" ]; then
			  		flag=\"\$(echo -e \"\$flagsWithTheirVars\" | grep \"$i\" | cut -d ' ' -f1)\"
					echo \"-\$flag is required. \"
					exit 1
				   fi 
				  "
		done
		echo -e "$code" > "$TMPCODEFILE"
	}
	function parseFlags() {
	#	while getopts "$OPTIONS" opt; do
	#		  case $opt in
	codeBuilder
	source "$TMPCODEFILE" "$@"
	}
}
argParseLib 
