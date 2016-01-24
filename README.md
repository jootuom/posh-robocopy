# Invoke-RoboCopy

PowerShell cmdlet wrapper for RoboCopy.

By default all output is suppressed and RoboCopy will log to a random file.
Specify a log location if you desire logs.

You can, of course, also specify the switches (but don't add "/LOG" yourself!), the default switches are "/NP /MIR /R:3 /W:5".

With -Verbose it shows you the src/dst, logfile and result of every RoboCopy invocation.
