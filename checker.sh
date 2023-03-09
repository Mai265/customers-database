#!/bin/bash

##Function takes a parameters. which is file name and return 0 if the file exists
function checkFile {
        FILENAME=${1}
        [ ! -f ${FILENAME} ] && return 1
        return 0
}
##Function takes a parameter which is filename and return 0 if the file has read perm
function checkFileR {

        FILENAME=${1}
        [ ! -r ${FILENAME} ] && return 1
        return 0
}
##Function takes a paremter which is filename and returns 0 if the file has write permission
function checkFileW {

        FILENAME=${1}
        [ ! -w ${FILENAME} ]    && return 1
        return 0
}
## Function takes a parameter with username, and return 0 if the user requested is the same as current user
function checkUser {

        RUSER=${1}
        [ ${USER} != ${RUSER} ] && return 1
        return 0
}
### Function takes a username, and password then check them in accs.db, and returns 0 if match otherwise returns 1
function authUser {
        USERNAME=${1}
        USERPASS=${2}
        ###1-Get the password hash from accs.db for this user if user found
        ###2-Extract the salt key from the hash
        ###3-Generate the hash for the userpass against the salt key
        ###4-Compare hash calculated, and hash comes from the file.
        ###5-IF match returns 0,otherwise returns 1
        USERLINE=$(grep ":${USERNAME}:" accs.db)
        [ -z ${USERLINE} ] && return 0
        PASSHASH=$(echo ${USERLINE} | awk ' BEGIN { FS=":" } { print $3} ')
        SALTKEY=$(echo ${PASSHASH} | awk ' BEGIN { FS="$" } { print $3 } ')
        NEWHASH=$(openssl passwd -salt ${SALTKEY} -6 ${USERPASS})
        if [ "${PASSHASH}" == "${NEWHASH}" ]
        then
                USERID=$(echo ${USERLINE} | awk ' BEGIN { FS=":" } { print $1} ')
                return ${USERID}
        else
                return 0
        fi
}
### Function takes a customer id and checks if it is a valid integer and return 0 if match otherwise returns 1

function checkCustID {

        CUSTID=${1}
        CH=$(echo "${CUSTID}" | grep "^[0-9]*$" | wc -l)
        [ ${CH} -ne 1 ] && echo -e "Invalid customer id.. \nplease enter a valid integer " && return 1
        return 0
}
### Function takes a customer name and checks if it is a valid alphabet and return 0 if match otherwise returns 1
function checkCustName {

        CUSTNAME=${1}
        CH=$(echo "${CUSTNAME}" | grep "^[[:alpha:]]*[-_]\{0,1\}[[:alpha:]]*$"  | wc -l)
        [ ${CH} -ne 1 ] && echo -e "Invalid customer name.. \nplease enter a valid alphaet " && return 1
        return 0
}
### Function takes a customer email and checks if it is in a valid format and return 0 if match otherwise returns 1
function checkCustEmail {

        CUSTEMAIL=${1}
        CH=$(echo "${CUSTEMAIL}" | grep "^[[:alnum:]]*[-_]\{0,1\}[[:alnum:]]*\@[[:alnum:]]*[-_]\{0,1\}[[:alnum:]]*\.[[:alpha:]]*$"  | wc -l)
        [ ${CH} -ne 1 ] && echo -e "Invalid email format.. \n\t the acepted format is name@domain.domain " && return 1
        return 0
}
### Function takes a customer id and checks if it is exist  and return 0 if not match otherwise returns 1
function checkIDExist {

        CUSTID=${1}
        CH=$( grep  -w "${CUSTID}" customers.db | wc -l)
        [ ${CH} -ne 0 ] && echo "customer id exists..  " && return 1
        return 0
}

### Function takes a customer email and checks if it is exist and return 0 if not match otherwise returns 1
function checkEmailExist {

        CUSTEMAIL=${1}
        CH=$( grep -w "${CUSTEMAIL}" customers.db | wc -l)
        [ ${CH} -ne 0 ] && echo "customer email exists..  " && return 1
        return 0
}
exit 0
