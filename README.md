# Setting up the qt (humidity-temperature) logger

## 1. Arduino setup

Read and follow the instructions in

    arduino/README.md

## 2. Database setup

Read and follow the instructions in [database/README.md](database/README.md).

To see what's in the file, type

    echo '.dump' | sqlite3 database/qt.db 

If you want to store the database somewhere else, you'll need to alter the code
in LaunchDaemons and other spots, too.

## 3. Daemon setup

Read and follow the instructions in

    daemon/README.md


## 4. Plotting setup

Read and follow the instructions in

    plotting/README.md

