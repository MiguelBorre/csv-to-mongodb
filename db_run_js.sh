#!/usr/bin/bash
# run code from a js file in mongosh with the movilens database
# e.g. ./db_run_js db_info.js will run the code in db_info.js, which lists the collections in the database
if [ $# -ne 1 ]
then echo "Enter js file to run"
    exit
fi
mongosh airbnb -f $1 -p 
