Import-Module 'C:\Program Files\Pure Storage\D.O.E.S\DOES.Powershell.dll'

Add-DataEngine -DatabaseType MicrosoftSQL -Hostname localhost -DatabaseName db1 -Amount 500 -Unit Gigabytes -NumberOfThreads 4
