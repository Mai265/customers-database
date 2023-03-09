# customers-database
BASH script that handles customer database stored in `customers.db` file <br>

The script manages user data <br>
- Data files:<br>
  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp; 1.customers.db <br>
  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; id:name:email <br>
  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp; 2.accs.db <br>
  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; id:username:pass <br>
                       
- Operations:<br>
  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp; 1.Add a customer <br>
  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp; 2.Delete a customer <br>
  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp; 3.Update a customer email <br>
  &emsp;&emsp;&emsp;&emsp;&emsp;&emsp; 4.Query a customer <br>
               
**Notes:**<br>
&emsp;&emsp;&emsp;&emsp; * Add,Delete, update need authentication with any of the users stored in `accs.db` <br>
&emsp;&emsp;&emsp;&emsp; * Query can be anonymous <br>
&emsp;&emsp;&emsp;&emsp; * Must be root to access the script <br>
 
## Give x-permission to run the script
```
[x@server ~]# chmod   a+x   db.sh
```

## Run the script
```
[x@server ~]# ./db.sh 
```
## Output
```
 Main menu 
         a) Authenticate
         1) Add a customer
         2) Update a customer email
         3) Delete a customer
         4) Query a customer email
         5) Quit
 Please, select a option: 5
 Thank you, see you later Bye
