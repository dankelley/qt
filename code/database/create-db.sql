-- sqlite3 qt.db < create-db.sql
CREATE TABLE observations(
    id integer primary key,
    station_code integer,
    time integer,
    q real,
    t real);
CREATE TABLE stations(
    id integer primary key,
    station_code integer,
    station_name varchar(100));

