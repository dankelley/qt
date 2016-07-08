-- sqlite3 qt.db < create-db.sql
CREATE TABLE observations(
    id integer primary key,
    station_id int,
    time int,
    q real,
    t real);
CREATE TABLE stations(
    id integer primary key,
    latitude real, -- negative for southern hemisphere
    longitude real, -- negative for western hemisphere, e.g. Canada
    name varchar(100));

