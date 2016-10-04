function Get-DaDatabaseSize {
  <#
      .Synopsis
      Checks if the Direct Access Database size

      .DESCRIPTION
      This function connects to the Windows Internal Database (WID) in order to check the DirectAccess DB file sizes.

      .NOTES   
      Name:        Get-DaDatabaseSize
      Author:      Javy de Koning
      Version:     1.0.0
      DateCreated: 2016-10-04
      DateUpdated: 2016-10-04
      Blog:        http://www.javydekoning.com

      .EXAMPLE
      Get-DaDatabaseSize

      Description:
      Will get filesize for the DA DB files.
  #>
  [cmdletbinding(SupportsShouldProcess=$true)]
  param()

  process {
      $ConnectionString = 'Server=np:\\.\pipe\MICROSOFT##WID\tsql\query;Integrated Security=True;Initial Catalog=RaAcctDb;'
      Write-Verbose "Connecting using: '$ConnectionString'"

      if ($PSCmdlet.ShouldProcess('.','Creating index')) {
        try {
          #Setup Connection to WID
          $Connection       = New-Object System.Data.SqlClient.SqlConnection
          $Connection.ConnectionString = $ConnectionString
          $Connection.Open()

          #Prep Query
          $Query             = $Connection.CreateCommand()
          $Query.CommandText = "SELECT name, physical_name AS current_file_location FROM sys.master_files`r`n"
          $SQLOutput         = $Query.ExecuteReader()
          
          $Table = New-Object -TypeName 'System.Data.DataTable'
          $Table.Load($SQLOutput)
          
          #Get FileSize
          $Files = $Table | Where-Object {$_.name -match 'RaAcctDb|RaAcctDb_log'}
          $Size  = $Files | ForEach-Object {Get-Item $_.current_file_location} | Select-Object Name,Length

          #Close connection and return object
          $Connection.Close()
          Return $Size
        } catch {
          throw $_
        }
    }
  }
}

function Shrink-DaDatabase {
  <#
      .Synopsis
      Shirnks the Direct Access Database

      .DESCRIPTION
      This function connects to the Windows Internal Database (WID) in order to Shrink the DirectAccess DB files.

      .NOTES   
      Name:        Shrink-DaDatabase
      Author:      Javy de Koning
      Version:     1.0.0
      DateCreated: 2016-10-04
      DateUpdated: 2016-10-04
      Blog:        http://www.javydekoning.com

      .EXAMPLE
      Shrink-DaDatabase

      Description:
      Will shrink the DA DB files (Default C:\Windows\DirectAccess\db).
  #>
  [cmdletbinding(SupportsShouldProcess=$true)]
  param()

  process {
      $ConnectionString = 'Server=np:\\.\pipe\MICROSOFT##WID\tsql\query;Integrated Security=True;Initial Catalog=RaAcctDb;'
      Write-Verbose "Connecting using: '$ConnectionString'"

      if ($PSCmdlet.ShouldProcess('.','Creating index')) {
        try {
          #Setup Connection to WID
          $Connection       = New-Object System.Data.SqlClient.SqlConnection
          $Connection.ConnectionString = $ConnectionString
          $Connection.Open()

          #ShrinkDB_Log
          $Query                = $Connection.CreateCommand()
          $query.CommandTimeout = 3600
          $Query.CommandText    = "DBCC SHRINKFILE ('RaAcctDb_log')`r`n"
          $Query.ExecuteReader()
          $Query = $null
          
          #ShrinkDB_Log
          $Query                = $Connection.CreateCommand()
          $query.CommandTimeout = 3600
          $Query.CommandText    = "DBCC SHRINKFILE ('RaAcctDb')`r`n"
          $Query.ExecuteReader()          
                 
          #Close connection and return object
          $Connection.Close()
          
        } catch {
          throw $_
        }
    }
  }
}