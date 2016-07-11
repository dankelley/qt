To install the website, type

    make

and install two entries in your crontab:

    @hourly /usr/local/bin/R --no-save < /Users/kelley/qt/plotting/plot01.R
    @hourly /usr/local/bin/R --no-save < /Users/kelley/qt/plotting/plot02.R

