#!/bin/bash

##
## Scribe Inc
## Collections of helper functions and default variables for our bash scripts
##
## @author Rob Frawley 2nd <rmf@scribe.tools>
##

##
## Output functions
##

## Output empty line
function out_empty_lines
{
    echo -en "\n"
}

## Output passed arguments as lines
function out_lines
{
    #
    # For each line provided...
    #
    for line in "${@}"; do

        #
        # Output line with our formatting
        #
        echo -en "${OUT_PRE}${line}\n"

    done
}
## Continue prompt
function out_prompt_boolean
{
    #
    # User response and importance of prompt
    #
    local response=""
    local importance=0
    local message="Would you like to continue?"
    local title=""
    local default=-1

    #
    # Check for passed values for the importance, message, title, and default
    #
    if [[ $# -gt 0 ]]; then

        if [[ -n ${1} ]] && [[ ${1} -gt 0 ]]; then

            importance=${1}

        fi

        if [[ -n "${2}" ]]; then

            message="${2}"

        fi

        if [[ -n "${3}" ]]; then

            title="${3}"

        fi

        if [[ -n "${4}" ]]; then

            default="${4}"

        fi

    fi

    #
    # Continue asking until we get a valid response
    #
    while true; do

        #
        # Set window text color
        #
        $bin_tput setaf 3

        #
        # Begin output
        #
        echo -en ">>> "

        #
        # Title, if available
        #
        if [[ -n "${title}" ]]; then

            echo -en "["
            $bin_tput bold
            echo -en "$( echo ${title} | tr '[:lower:]' '[:upper:]' )"
            $bin_tput sgr0
            $bin_tput setaf 3
            echo -en "] "

        fi

        #
        # Output message
        #
        echo -en "${message} "

        #
        # Different behaviour if default is available
        #
        echo -en "["
        if [[ -n "${default}" ]] && [[ "${default}" == "y" ]]; then

            $bin_tput bold
            echo -en "Y"
            $bin_tput sgr0
            $bin_tput setaf 3
            echo -en "/n"

        elif [[ -n "${default}" ]] && [[ "${default}" == "n" ]]; then


            echo -en "y/"
            $bin_tput bold
            echo -en "N"
            $bin_tput sgr0
            $bin_tput setaf 3

        else

            echo -en "y/n"

        fi
        echo -en "]: "

        #
        # Bold text for user input
        #
        $bin_tput bold

        if [[ -n "${OUT_PROMPT_DEFAULT}" ]] && [[ ${importance} -lt 1 ]]; then
            echo -en "${OUT_PROMPT_DEFAULT} (non-interactive-mode)"
            response="${OUT_PROMPT_DEFAULT}"
            out_empty_lines
        else
            read response
        fi

        #
        # Reset color attrs
        #
        $bin_tput sgr0

        #
        # Output empty line
        #
        out_empty_lines

        #
        # If user input is valid, break from while loop
        #
        if [[ "${response}" == "y" ]] || [[ "${response}" == "yes" ]] || [[ "${response}" == "n" ]] || [[ "${response}" == "no" ]]; then
            break
        elif [[ -n "${default}" ]] && [[ -z "${response}" ]]; then
            response="${default}"
            break
        else
            out_warning_no_header \
                "Invalid response provided. Valid response are:" \
                "  y|yes -> For yes (continue)" \
                "  n|no  -> For no  (stop script)"
        fi

    done

    #
    # Reset window color
    #
    $bin_tput sgr0

    if [[ ${response} == "n" ]] || [[ ${response} == "no" ]]; then
        out_error_no_header "User requested to not continue. Exiting."
    fi

    #
    # Set global response var
    #
    OUT_PROMPT_RESPONSE="${response}"
}

## Continue prompt
function out_prompt_continue
{
    out_prompt_boolean "0" "Would you like to continue?" "" "y"
}

## Display error message and exit
function out_error
{
    #
    # Set window text color
    #
    $bin_tput setaf 1

    #
    # Output message
    #
    echo -en "${OUT_PRE}\n${OUT_PRE}$($bin_tput bold)CRITICAL ERROR:$($bin_tput sgr0; $bin_tput setaf 1)\n${OUT_PRE}\n"
    out_lines "${@}"
    echo -en "${OUT_PRE}\n\n"

    #
    # Reset window color
    #
    $bin_tput sgr0

    #
    # Exit script on error with non-zero return
    #
    exit 1
}

## Display error message and exit
function out_error_no_header
{
    #
    # Set window text color
    #
    $bin_tput bold
    $bin_tput setaf 1

    #
    # Output message
    #
    out_lines "${@}"
    out_empty_lines

    #
    # Reset window color
    #
    $bin_tput sgr0

    #
    # Exit script on error with non-zero return
    #
    exit 1
}

## Display notice/warning message
function out_warning_no_header
{
    #
    # Set window text color
    #
    $bin_tput bold
    $bin_tput setaf 3

    #
    # Output message
    #
    echo -en "${OUT_PRE}\n"
    out_lines "${@}"
    echo -en "${OUT_PRE}\n\n"

    #
    # Reset window color
    #
    $bin_tput sgr0
}

## Display notice/warning message
function out_notice
{
    #
    # Set window text color
    #
    $bin_tput setaf 3

    #
    # Output message
    #
    echo -en "${OUT_PRE}\n${OUT_PRE}$(${bin_tput} bold)$(echo "Notice" | tr '[:lower:]' '[:upper:]')$($bin_tput sgr0; $bin_tput setaf 3)\n"
    out_lines "${@}"
    echo -en "${OUT_PRE}\n\n"

    #
    # Reset window color
    #
    $bin_tput sgr0
}

## Display notice/warning message
function out_notice_no_header
{
    #
    # Set window text color
    #
    $bin_tput bold
    $bin_tput setaf 3

    #
    # Output message
    #
    echo -en "${OUT_PRE}\n"
    out_lines "${@}"
    echo -en "${OUT_PRE}\n\n"

    #
    # Reset window color
    #
    $bin_tput sgr0
}

## Display info messages
function out_info_final
{
    #
    # Set window text color
    #
    $bin_tput setaf 6

    #
    # Output message
    #
    echo -en "${OUT_PRE}\n"
    out_lines "$(${bin_tput} bold)$(echo "${@:1:1}" | tr '[:lower:]' '[:upper:]')$($bin_tput sgr0; $bin_tput setaf 6)"
    out_lines "${@:2}"
    echo -en "${OUT_PRE}\n\n"

    #
    # Reset window color
    #
    $bin_tput sgr0
}

## Display info messages
function out_info
{
    #
    # Set window text color
    #
    $bin_tput setaf 6

    #
    # Output message
    #
    echo -en "${OUT_PRE}\n"

    out_lines "${@}"
    echo -en "${OUT_PRE}\n\n"

    #
    # Reset window color
    #
    $bin_tput sgr0
}

## Display info messages
function out_info_config
{
    #
    # Set window text color
    #
    $bin_tput setaf 4

    #
    # Output message
    #
    echo -en "${OUT_PRE}\n"
    out_lines "$(${bin_tput} bold)$(echo "${@:1:1}" | tr '[:lower:]' '[:upper:]')$($bin_tput sgr0; $bin_tput setaf 4)"
    out_lines "${@:2}"
    echo -en "${OUT_PRE}\n\n"

    #
    # Reset window color
    #
    $bin_tput sgr0
}

## Display info messages
function out_stage
{
    #
    # Set window text color
    #
    $bin_tput setaf 5

    #
    # Output message
    #
    echo -en "${OUT_PRE}\n"
    out_lines "$(${bin_tput} bold)$(echo "Entering stage:" | tr '[:lower:]' '[:upper:]')$(${bin_tput} sgr0; ${bin_tput} setaf 5) ${3}"
    out_lines "  Step -> [$(${bin_tput} bold)${1}$(${bin_tput} sgr0; ${bin_tput} setaf 5)/${2}]"
    echo -en "${OUT_PRE}\n\n"

    #
    # Reset window color
    #
    $bin_tput sgr0
}

## Display info messages
function out_commands
{
    #
    # Local command count
    #
    local cmd_i=1
    local cmd_i_pad=$(echo "($# - 1) / 10" | bc)

    #
    # Set window text color
    #
    $bin_tput setaf 3

    #
    # Output message
    #
    echo -en "${OUT_PRE}\n"
    out_lines "$(${bin_tput} bold)$(echo "Executing commands:" | tr '[:lower:]' '[:upper:]')$(${bin_tput} sgr0; ${bin_tput} setaf 3) ${1}"
    out_lines ""
    for command in "${@:2}"; do
        out_lines "  Command [$(printf %0${cmd_i_pad}d ${cmd_i})] -> ${command}"
        cmd_i=$((cmd_i + 1))
    done
    echo -en "${OUT_PRE}\n\n"

    #
    # Reset window color
    #
    $bin_tput sgr0
}

## Display success messages
function out_success
{
    #
    # Set window text color
    #
    $bin_tput setaf 6

    #
    # Output message
    #
    out_lines "${@}"
    echo -en "\n"

    #
    # Reset window color
    #
    $bin_tput sgr0
}

## Display success messages
function out_done
{
    #
    # Set window text color
    #
    $bin_tput setaf 2

    #
    # Output message
    #
    echo -en "${OUT_PRE}\n"
    out_lines "$(${bin_tput} bold)$(echo "Done:" | tr '[:lower:]' '[:upper:]')$(${bin_tput} sgr0; ${bin_tput} setaf 2) ${1}"
    out_lines "${@:2}"
    echo -en "${OUT_PRE}\n"
    echo -en "\n"

    #
    # Reset window color
    #
    $bin_tput sgr0
}

## Display script usage (generic) and exit
function out_usage_generic
{
    #
    # Display script usage message
    #
    echo -en \
        "\n" \
        "Usage:\n\t${SELF_FILENAME}\n" \
        "\n"
}

## Display script usage, using specific function if defined or generic function if not
function out_usage
{
    #
    # Check for specific function definition
    #
    if [[ "$(test_exit_code type -t out_usage_custom)" == "0" ]]; then
        out_usage_custom
    else
        out_usage_generic
    fi

    #
    # Display error message if one was passed
    #
    if [[ "$#" -gt 0 ]]; then
        out_error_no_header "$@"
    fi

    #
    # Exit with non-zero return
    #
    exit 2
}

function out_usage_optls
{
    echo -en "\nUsage:\n\t./${SELF_FILENAME}"

    for opt in "$@"; do
        echo -en " ${opt}"
    done

    echo -en "\n\n"
}

function out_usage_optdt {
    local required=0;
    local i=0;

    if [[ ${1} -eq 1 ]]; then
        required=1
    fi

    echo -en "\t"

    for opt in "${@:2}"; do
        if [[ ${i} -gt 0 ]]; then
            echo -en "| "
        fi
        echo -en  "${opt} "
        i=$(( i + 1 ))
    done

    if [[ ${required} == 0 ]]; then
        echo -en "[optional]"
    else
        echo -en "[required]"
    fi

    echo -en "\n\n"
}

function out_usage_optdd
{
    local out="${@:1}"
    out="${out##*( )}"

    while read line; do
        echo -en "\t\t${line}\n"
    done <<< "$(echo ${out} | ${bin_fold} -w 80)"

    echo -en "\n"
}

function out_usage_optdd_p
{
    local out="${@:1}"
    out="${out##*( )}"

    while read line; do
        echo -en "\t\t${line}\n"
    done <<< "$(echo ${out} | ${bin_fold} -w 80)"

    echo -en "\n"
}

function out_usage_optls_start
{
    echo -en
}

function out_usage_optls_end
{
    echo -en "\n";
}

function out_usage_optls_i
{
    local i=0
    local oli=${1}
    local out="${@:2}"
    out="${out##*( )}"

    while read line; do
        if [[ ${i} -eq 0 ]]; then
            echo -en "\t\t    ${oli}) ${line}\n"
        else
            echo -en "\t\t       ${line}\n"
        fi
        i=$(( i + 1 ))
    done <<< "$(echo ${out} | ${bin_fold} -w 73)"
}

## Display welcome message
function out_welcome_generic
{
    #
    # Output message
    #
    out_lines \
        "${SELF_SCRIPT_NAME}" \
        "" \
        "Author    : ${SELF_AUTHOR_NAME} <${SELF_AUTHOR_EMAIL}>" \
        "Copyright : ${SELF_COPYRIGHT}" \
        "License   : ${SELF_LICENSE}"
}

## Display welcome message
function out_welcome
{
    #
    # Set window text color
    #
    $bin_tput bold
    $bin_tput setaf 7

    #
    # Output pre-message
    #
    echo -en "\n${OUT_PRE}\n${OUT_PRE}\n"

    #
    # Check for specific function definition
    #
    if [[ "$(test_exit_code type -t out_welcome_custom)" == "0" ]]; then
        out_welcome_custom
        out_lines \
            "" \
            "Author    : ${SELF_AUTHOR_NAME} <${SELF_AUTHOR_EMAIL}>" \
            "Copyright : ${SELF_COPYRIGHT}" \
            "License   : ${SELF_LICENSE}"
    else
        out_welcome_generic
    fi

    #
    # Output post-message
    #
    echo -en "${OUT_PRE}\n${OUT_PRE}\n\n"

    #
    # Reset window color
    #
    $bin_tput sgr0
}

##
## General functions
##

## Test exit code of any function and echo 0 or 1
function test_exit_code
{
    #
    # Run command to test
    #
    "$@" > /dev/null 2>&1

    #
    # Get command's exit code
    #
    local status=$?

    #
    # Return result as 0 (success) or 1 (error)
    #
    if [[ $status -eq 0 ]]; then
        echo 0
    else
        echo 1
    fi
}

## Check for required binaries
function check_bins_and_setup_abs_path_vars
{
    #
    # For each binary name passed
    #
    for bin in "${@}"; do

        #
        # Attempt to find the binary path and create a variable that holds it
        #
        eval "bin_$(echo ${bin} | tr -cd '[[:alnum:]]._-')=$(which ${bin})"

        #
        # Check to make sure we were able to find the bin path
        #
        if [[ -z "$(which ${bin})" ]]; then

            #
            # Output error if bin path could not be found
            #
            out_error \
                "Could not find '${bin}' command but it is required." \
                "Please install it on your system or ensure it is within your PATH."

        fi

    done
}

##
## Setup variables
##

## Require tputs and setup variable to call it via absolute path
check_bins_and_setup_abs_path_vars tput fold

## Out variables
OUT_PROMPT_RESPONSE=""
OUT_PROMPT_DEFAULT=""

## Set name of script
SELF_FILENAME="$(basename ${0})"
SELF_SCRIPT="${SELF_FILENAME}"
SELF_SCRIPT_NAME="${SELF_FILENAME}"

## Set welcome message info
SELF_AUTHOR_NAME="Rob Frawley 2nd"
SELF_AUTHOR_EMAIL="rmf@scribe.tools"
SELF_COPYRIGHT="Scribe Inc."
SELF_LICENSE="MIT License"

## Output function configuration
OUT_PRE="# "

## EOF
