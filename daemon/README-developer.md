**Developer notes.**

1. Originally I was doing fancy things with an infinite loop in the daemon, and the `KeepAlive` argument, but eventually I gave up on all that. Now, the daemon just gets two numbers from the Arduino, stores the results in the database, and then exits, to be recalled again later as dictated by the `StartInterval` value (presently 300s).
2. See [apple launchd docs](https://developer.apple.com/library/mac/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html)
