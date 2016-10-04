| Branch        | Status        |
| ------------- | ------------- |
| master        | [![Build status](https://ci.appveyor.com/api/projects/status/id2vjxhw6gnbb66p/branch/master?svg=true&passingText=master%20-%20OK&pendingText=master%20-%20PENDING&failingText=master%20-%20FAILED)](https://ci.appveyor.com/project/javydekoning/shrinkdadatabase/branch/master) |

# Get-DaDataBaseSize
```powershell
Get-DaDatabaseSize | ft -auto

Name                  Length
----                  ------
RaAcctDb.mdf     15658254336
RaAcctDb_log.ldf   137363456
```

# Shrink-DaDataBase
```powershell
Shrink-DaDataBase
```