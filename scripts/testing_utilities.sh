red='\033[1;031m'
dred='\033[0;031m'
green='\033[1;032m'
dgreen='\033[0;032m'
normal='\033[0m'

function assert_result_using_diff() {
	local expected_outcome="$1"
	local actual_outcome="$2"
	local message="$3"

	diff ${expected_outcome} ${actual_outcome} &> /dev/null
	local status_code=`echo $?`

	local status="${dred}✗${normal}"
	if [[ ${status_code} == 0 ]]
	then
		status="${dgreen}✔${normal}"
	fi

	update_test_case_array ${status} "${actual_outcome}" "${expected_outcome}"
#	echo -e "\t${status} ${message} "
}

function assert_result() {
	local expected_outcome="$1"
	local actual_outcome="$2"
	local message="$3"

	[[ "${expected_outcome}" == "${actual_outcome}" ]]
	local status_code=`echo $?`

	local status="${dred}✗${normal}"
	if [[ ${status_code} == 0 ]]
	then
		status="${dgreen}✔${normal}"
	fi

	update_test_case_array ${status} "${actual_outcome}" "${expected_outcome}"
#	echo -e "\t${status} ${message} "
}

function update_test_case_array(){
	local status="$1"
	local actual="$2"
	local expected="$3"

	ALL_STATUS=("${ALL_STATUS[@]}" "${status} ${message}" )
	#ALL_MESSAGE=("${ALL_MESSAGE[@]}" "${message}")

	if [[ ${status} == "${dred}✗${normal}" ]]
	then
		FAILED_STATUS=(${FAILED_STATUS[@]} ${status})
		ERROR_MESSAGE=("${ERROR_MESSAGE[@]}" "${message}")
		SUB_COMMAND=(${SUB_COMMAND[@]} ${sub_function})
		ACTUAL_OUTCOME=("${ACTUAL_OUTCOME[@]}" "`echo -e "${actual}"`")
		EXPECTED_OUTCOME=("${EXPECTED_OUTCOME[@]}" "`echo -e "${expected}"`")
		return
	fi
	PASSED_STATUS=(${PASSED_STATUS[@]} "${status}")
	PASSED_MESSAGE=(${PASSED_MESSAGE[@]} "${message}")
}

function generate_report() {
	local index=0
	for status in "${ALL_STATUS[@]}"
	do
		echo -e "\t${status}" #${ALL_MESSAGE[${index}]}"
		#index=$(( ${index} + 1 ))
	done

	echo -e "\nSummary"
	ALL_STATUS=`echo ${#ALL_STATUS[@]}`
	echo -e "\tfailed cases : ${red}${#FAILED_STATUS[@]}${normal}/${ALL_STATUS}"

	if [[ `echo ${#FAILED_STATUS[@]}` -gt 0 ]]
	then
		echo -e "\nfailed test cases :\n"
		local index=0

		for error in "${ERROR_MESSAGE[@]}"
		do
			echo -e "$((${index}+1)). ${dred}${SUB_COMMAND[${index}]}${normal} : "${error}"\n"
			echo -e "actual:\n${ACTUAL_OUTCOME[${index}]}\n\nexpected:\n${EXPECTED_OUTCOME[${index}]}\n"
			index=$(( ${index} + 1 ))
		done
	fi
	echo
}
