**Step 1.**

Type

    make test

in a unix console, to set up a test database.

**Step 2.**

Use

    make clean

to remove this test database.

**Step 3.**

Edit `add-station.sql` to name a station of your own. Then type

    make create

to create a database named `qt.db` in the present directory.

**NOTES.**

1. If you decide you'd like to move the file, you'll need to alter some of the
   daemon and plotting code, as explained in `../daemon/README.md` and
`../plotting/README.md`.

2. To see what's in the database, type

    echo '.dump' | sqlite3 qt.db 


