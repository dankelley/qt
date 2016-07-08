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
access: access.c
	gcc -o access access.c -lsqlite3
	./access qt.db 'SELECT * FROM observations'
test_insert: test_insert.c
	gcc -o $@ $< -lsqlite3
	./$@ 1 qt.db

flat2db: flat2db.c
	gcc -o flat2db -O flat2db.c -lsqlite3
do_flat2db: flat2db force
	sqlite3 ~/Sites/qt/qt.db < create-db.sql
	sqlite3 ~/Sites/qt/qt.db < add-station.sql
	./flat2db ~/Sites/qt/qt-01.dat ~/Sites/qt/qt.db
	
clean:
	-rm qt.db *~
clean_web:
	-rm ~/Sites/qt/qt.db

force:
