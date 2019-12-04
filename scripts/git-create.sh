#!/usr/bin/env bash

helpMessage="
===================================================================================
git-create v0.1
===================================================================================
This script facilitates CLI based creation of git repositories on Babel's gitlab
server. To generate a list of accepted parameters run \"$0 -h\".

Date:           Dec, 3rd, 2019
Author:         Shashwat Mishra
Affiliation:    Babel, Spain
===================================================================================
"
usageMessage="
===================================================================================
Usage:

    $0 [OPTIONS]

where:

    [OPTIONS]

        [MANDATORY]
            -u LDAP user name.

        [OPTIONAL]
            -v Specify api version.
            -t Specify access token (overrides hard-coded value).
            -i Init repository, add remote after creation.
====================================================================================
"

babelGitlabURL="https://git.babel.es:4433"
apiVersion="v4"
accessToken="dummy_val"

exec 3>&1
set -o pipefail
set -e
getScreenWideSeparator(){
    separatorStages="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}
initColors(){
    # Bold colors
    red=$'\e[1;31m'
    grn=$'\e[1;32m'
    yel=$'\e[1;33m'
    blue=$'\e[1;34m'
    mag=$'\e[1;35m'
    cyn=$'\e[1;36m'
    end=$'\e[0m'

    # Dim colors
    grnDim=$'\e[5;32m'
    yelDim=$'\e[5;33m'
    bluDim=$'\e[5;34m'
    redDim=$'\e[5;31m'
    # Underlined colors
    grnUl=$'\e[5;32m'
}
logDebug(){
    echo "${yel}[$(date)]:${end} $*"
}
runStringAsStep(){
    logDebug "Executing: ${grn}$*${end}"
    eval $* > /dev/null 2>&1
}
logInfo(){
    echo "${yel}[$(date)]:${end} ${blu}$* ${end}"
}
logError(){
    echo "${yel}[$(date)]:${end} ${red}$* ${end}"
}
logImp(){
    echo "${yel}[$(date)]:${end} ${red}$* ${end}"
}

separateStages(){
    echo "${mag}$*${end}"
    echo "${mag}$*${end}"
}

errMsg() {
    echo -e "${usageMessage}"
    echo "${red}${errorMsg}: ${1}${end}"
    echo
    exit 1
}
helpMsg() {
    echo -e "${helpMessage}"
    echo -e "${usageMessage}"
    echo
    exit 0
}


init(){
    STARTTIME=$(date +%s)

    repositoryName=${PWD##*/}

    usernameSet=0
    apiVersionSet=0
    accessTokenSet=0
    flagInit=0

    errorMsg="ERROR"

    set +e
    while [ $# -gt 0 ]
    do         # get parameters
        case "${1}" in
            -h) # help
                helpMsg
                ;;
            -u) # get LDAP username
                shift # to get the next parameter
                username="${1}"
                usernameSet=1
                ;;
            -v) # get Gitlab api version
                shift
                apiVersion=`expr "${1}" : '\(v4\)'`
                [ "${apiVersion}" = "" ] && errMsg "Only version 4 is supported; specify v4."
                apiVersionSet=1
                ;;
            -t) # get Gitlab access token
                shift
                accessToken="${1}"
                accessTokenSet=1
                ;;
            -i) # get init flag.
                flagInit=1
                ;;
            -*) # any other - argument
                errMsg "Option (${1}) is not recognized."
                ;;
            -) # STDIN and end of arguments
                break
                ;;
            *) # end of arguments
                break
                ;;
        esac
        shift # next option
    done
    set -e

    if [[ ${usernameSet} -ne 1 ]]; then
        errMsg "You must specify LDAP username (-u)."
    fi


    set +e

    logInfo "Init call finished."
}
pause() {
    echo
    read -u 0 -p "Press Enter key to continue..."
}
askYesNo() {
    echo -n "${mag}$1${end} (y/n) "
    while read -r -n 1 -s answer; do
        if [[ ${answer} = [YyNn] ]]; then
            [[ ${answer} = [Yy] ]] && response=1
            [[ ${answer} = [Nn] ]] && response=0
            break
        fi
    done
    echo
    echo
}
end(){
    ENDTIME=$(date +%s)
    SPENTTIME=$(((ENDTIME-STARTTIME)));
}

cleanUP(){

    exec 1>&3

    separateStages "${separatorStages}"

    logError "Critical Failure. Retrace steps to debug."

    set +e

    end
    logError "Execution time: ${SPENTTIME} seconds."
    logError "FAILURE."

    exit 1
}

info(){
    formatConfig1="%-35s\t%-35s\n"
    formatConfig2="%-35s\t%-35d\n"
    sep="==========================================================================="
    sep2="---------------------------------------------------------------------------"
    echo
    echo ${sep}
    printf "${formatConfig1}" "Babel Gitlab" ${babelGitlabURL}
    printf "${formatConfig1}" "API Version" ${apiVersion}
    echo ${sep2}
    printf "${formatConfig1}" "LDAP Username" ${username}
    printf "${formatConfig1}" "Access Token" ${accessToken}
    echo ${sep2}
    printf "${formatConfig1}" "Repository Name" ${repositoryName}
    printf "${formatConfig1}" "Init" ${flagInit}
    echo ${sep}
    echo
}

getScreenWideSeparator
initColors
init $*
info

response=1
askYesNo "Do you want to create the repository with the above details?"


if [[ ${response} -eq 1 ]]; then

trap 'cleanUP' ERR TERM
set -eE
logInfo "Trap set."
logInfo "Commencing execution."

    runStringAsStep "curl -f -k -s -w '%{http_code}' -H \"Content-Type:application/json\" ${babelGitlabURL}/api/${apiVersion}/projects?private_token=${accessToken} -d \"{ \\\"name\\\": \\\"${repositoryName}\\\" }\""

    if [[ ${flagInit} -eq 1 ]]; then
        logInfo "Initing the repository."
        runStringAsStep "git init"
        runStringAsStep "git remote add origin ${babelGitlabURL}/${username}/${repositoryName}.git"
        logInfo "Added remote \"origin\"."
        logInfo "You can now start adding/commiting."
    fi

fi

end
logImp "Execution time: ${SPENTTIME} seconds."
logImp "SUCCESS."

exit 0
