#!/bin/bash
### Script that handles customer info in file customers.db
#BASH script manages user data
#       Data files:
#               customers.db:
#                       id:name:email
#               accs.db:
#                       id,username,pass
#       Operations:
#               Add a customer
#               Delete a customer
#               Update a customer email
#               Query a customer
#       Notes:
#               Add,Delete, update need authentication
#               Query can be anonymous
#       Must be root to access the script
###################### TODO
#################################
### Exit codes:
##      0: Success
##      1: No customers.db file exists
##      2: No accs.db file exists
##      3: no read perm on customers.db
##      4: no read perm on accs.db
##      5: must be root to run the script
##      6: Can not write to customers.db
##      7: Customer name is not found
source ./checker.sh
source ./printmsgs.sh
source ./dbops.sh
checkFile 'customers.db'
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not find customers.db" &&  exit 1
checkFile "accs.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not find accs.db" &&  exit 2
checkFileR "customers.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not read from customers.db" &&  exit 3
checkFileR "accs.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not read from accs.db" &&  exit 4
checkFileW "customers.db"
[ ${?} -ne 0 ] && printErrorMsg "Sorry, can not write to customers.db" &&  exit 6
checkUser "root"
[ ${?} -ne 0 ] && printErrorMsg "You are not root, change to root and come back" && exit 5
CONT=1
USERID=0
while [ ${CONT} -eq 1 ]
do
        printMainMenu
        read OP
        case "${OP}" in
                "a")
                        echo "Authentication:"
                        echo "---------------"
                        read -p "Username: " ADMUSER
                        read -p "Password: " -s ADMPASS
                        authUser ${ADMUSER} ${ADMPASS}
                        USERID=${?}
                        if [ ${USERID} -eq 0 ]
                                then
                                        echo "Invalid username/password combination"
                                else
                                        echo "Welcome to the system"
                        fi
                        ;;
                "1")
                        if [ ${USERID} -eq 0 ]
                        then
                                printErrorMsg "You are not authenticated, please authenticate 1st"
                        else
                                echo "Adding a new customer"
                                echo "---------------------"
                                read -p "Enter customer ID : " CUSTID
                                read -p "Enter customer name : " CUSTNAME
                                read -p "Enter customer email : " CUSTEMAIL
                                checkCustID ${CUSTID}
                                CH1=${?}
                                checkCustName ${CUSTNAME}
                                CH2=${?}
                                checkCustEmail ${CUSTEMAIL}
                                CH3=${?}
                                checkIDExist ${CUSTID}
                                CH4=${?}
                                checkEmailExist ${CUSTEMAIL}
                                CH5=${?}
                                if [ ${CH1} -eq 0 ] && [ ${CH2} -eq 0 ] && [ ${CH3} -eq 0 ] && [ ${CH4} -eq 0 ] && [ ${CH5} -eq 0 ]
                                then
                                        echo "${CUSTID}:${CUSTNAME}:${CUSTEMAIL}" >> customers.db
                                        echo "customer ${CUSTID} saved.."
                                fi
                        fi
                        ;;
                "2")
                        if [ ${USERID} -eq 0 ]
                        then
                                printErrorMsg "You are not authenticated, please authenticate 1st"
                        else
                                echo "Updating an existing email"
                                echo "---------------------"    
                                read -p "Enter customer ID : " CUSTID
                                checkCustID ${CUSTID}
                                CH1=${?}
                                checkIDExist ${CUSTID}
                                CH2=${?}
                                if [ ${CH1} -eq 0 ] && [ ${CH2} -ne 0 ]
                                then
                                        echo "Printing customer details .. " 
                                        echo -e "\t $(grep -w "${CUSTID}" customers.db)"
                                        read -p "Press 'yes' to confirm customer details : " CON1
                                        if [ "${CON1}" == "yes" ]
                                        then
                                                read -p "Please enter a new email : " CUSTEMAIL
                                                checkCustEmail ${CUSTEMAIL}
                                                CH3=${?}
                                                checkEmailExist ${CUSTEMAIL}
                                                CH4=${?}
                                                if [ ${CH3} -eq 0 ] && [ ${CH4} -eq 0 ]
                                                then
                                                        echo "Updating customer details .. "
                                                        echo -e "\t The entered email is ${CUSTEMAIL}"
                                                        read -p "Press 'yes' to confirm email update : " CON2
                                                        if [ "${CON2}" == "yes" ]
                                                        then
                                                                OLDEMAIL=$(grep -w "${CUSTID}" customers.db | awk 'BEGIN {FS=":"} {print $3}')
                                                                sed -i "s/${OLDEMAIL}/${CUSTEMAIL}/" customers.db
                                                        fi
                                                fi
                                        fi
                                fi
                        fi
                        ;;
                "3")
                        if [ ${USERID} -eq 0 ]
                        then
                                printErrorMsg "You are not authenticated, please authenticate 1st"
                        else
                                echo "Deleting existing user"
                                echo "---------------------"
                                read -p "Enter customer ID : " CUSTID
                                checkCustID ${CUSTID}
                                CH1=${?}
                                checkIDExist ${CUSTID}
                                CH2=${?}
                                if [ ${CH1} -eq 0 ] && [ ${CH2} -eq 1 ]
                                then
                                        echo "Printing customer details .. "
                                        echo -e "\t $(grep -w "${CUSTID}" customers.db)"
                                        read -p "Press 'yes' to confirm deleting customer details : " CON1
                                        if [ "${CON1}" == "yes" ]
                                        then
                                                sed -i "/${CUSTID}/d" customers.db
                                        fi
                                fi
                        fi
                        ;;
                "4")

                        read -p "Enter name : " CUSTNAME
                        queryCustomer ${CUSTNAME}
                        ;;

                "5")
                        echo "Thank you, see you later Bye"
                        CONT=0
                        ;;
                *)
                        echo "Invalid option, try again"
        esac
done
exit 0
