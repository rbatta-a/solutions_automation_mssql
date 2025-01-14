USE [master]
GO
EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE', N'Software\Microsoft\MSSQLServer\MSSQLServer', N'LoginMode', REG_DWORD, 2
GO

USE [master]
GO
CREATE LOGIN [admin] WITH PASSWORD=N'VMware1!', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=ON
GO
ALTER SERVER ROLE [serveradmin] ADD MEMBER [admin]
GO
ALTER SERVER ROLE [sysadmin] ADD MEMBER [admin]
GO
use [tempdb];
GO
USE [db1]
GO
CREATE USER [admin] FOR LOGIN [admin]
GO
use [db1];
GO
USE [master]
GO
CREATE USER [admin] FOR LOGIN [admin]
GO
use [master];
GO
USE [model]
GO
CREATE USER [admin] FOR LOGIN [admin]
GO
use [model];
GO
USE [msdb]
GO
CREATE USER [admin] FOR LOGIN [admin]
GO
use [msdb];
GO
USE [tempdb]
GO
CREATE USER [admin] FOR LOGIN [admin]
GO