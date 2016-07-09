test:
	make clean
	sqlite3 qt.db < create-db.sql
	sqlite3 qt.db < add-station.sql
	sqlite3 qt.db < add-fake-data.sql
	sqlite3 qt.db ".dump"
	R --slave < test-db.R
	echo "Examine Rplots.pdf"
	
create:
	make clean
	sqlite3 qt.db < create-db.sql
	sqlite3 qt.db < add-station.sql
	sqlite3 qt.db ".dump"
	mv qt.db ../../database

clean:
	-rm qt.db *~
clean_web:
	-rm ~/Sites/qt/qt.db

force:
