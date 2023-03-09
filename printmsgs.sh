#!/bin/bash

## Function takes a message a parameter, and print it as an error
function printErrorMsg {
        MSG=${1}
        echo "ERRPR: ${MSG}"
        return 0
}
## Function to print menu for user 
function printMainMenu {
        echo "Main menu"
        echo -e "\t a) Authenticate"
        echo -e "\t 1) Add a customer"
        echo -e "\t 2) Update a customer email"
        echo -e "\t 3) Delete a customer"
        echo -e "\t 4) Query a customer email"
        echo -e "\t 5) Quit"
        echo -n "Please, select a option: "
}
exit 0
