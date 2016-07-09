Use

    make test

for testing (local database) and

    make create

to create a working (empty) database in the parent directory, i.e. for Kelley
this is created as a file named `qt.db` in the present directory. (If you
decide you'd like to move the file, you'll need to alter some of the daemon and
plotting code, as explained in `../daemon/README.md` and
`../plotting/README.md`.

To see what's in the file, type

    echo '.dump' | sqlite3 qt.db 


