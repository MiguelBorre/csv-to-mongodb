# Version 1.0

DBNAME=airbnb

NOW="$(date +%Y%m%dT%H%M%S)"
NOW=$(shell date +%Y-%m-%d_%H-%M-%S)

all: csv2json dropdb loaddb allqueries
csv2json:
	@echo Procesando csv para crear json
	@echo -- puede modificarse para introducir datos a csv2json por linea de comandos -- 
	@python3 csv2json.py
loaddb:
	@echo Poblando BBDD a partir de ficheros json
	@./db_load_files.sh

dropdb:
	@echo Eliminando BBDD
	@mongosh $(DBNAME) --eval "db.dropDatabase()"
dump:
	@echo Creando dumpfile de BBDD
	@mongodump -d $(DBNAME) --out $(DBNAME)-dump
backup:
	@echo Creando dumpfile con fecha de BBDD
	@mongodump -d $(DBNAME) --out $(DBNAME)-dump-$(NOW)
restore:
	@echo Restaurando dumpfile de BBDD
	@mongorestore $(DBNAME)-dump  
shell:
	@echo create mongo shell
	@mongosh $(DBNAME)

query1:
	@echo query1  | tee query1.log
	mongosh $(DBNAME) --quiet < query1.js | tee -a query1.log
query2a:
	@echo query2a | tee query2a.log
	mongosh $(DBNAME) --quiet < query2a.js | tee -a query2a.log

query2b:
	@echo query2b | tee query2b.log
	mongosh $(DBNAME) --quiet < query2b.js | tee -a query2b.log

query3:
	@echo query3 | tee query3.log
	mongosh $(DBNAME) --quiet < query3.js | tee -a query3.log

query4:
	@echo query4 | tee query4.log
	mongosh $(DBNAME) --quiet < query4.js | tee -a query4.log

query5:
	@echo query5 | tee query5.log
	mongosh $(DBNAME) --quiet < query5.js | tee -a query5.log

allqueries: query1 query2a query2b query3 query4 query5 
	@cat query*.log > all_queries.log

# execute any query, passing any sql file to execute, e.g. myquery.sql, with 
# make aquery QUERY=myquery.js
aquery: QUERYLOG = $(QUERY:.js=.log)
aquery: 
	echo "$(QUERYLOG)"
	@echo $(QUERY) | tee $(QUERYLOG)
	mongosh $(DBNAME) --quiet  < $(QUERY) | tee -a $(QUERYLOG)

removelogs: 
	rm -rf *.log
