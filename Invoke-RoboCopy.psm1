Function Invoke-RoboCopy {
	<#
	Robocopy return codes
	
	Value	Description
	0		No files were copied. No failure was encountered. No files were mismatched. The files already exist in the destination directory; therefore, the copy operation was skipped.
	1		All files were copied successfully.
	2		There are some additional files in the destination directory that are not present in the source directory. No files were copied.
	3		Some files were copied. Additional files were present. No failure was encountered.
	5		Some files were copied. Some files were mismatched. No failure was encountered.
	6		Additional files and mismatched files exist. No files were copied and no failures were encountered. This means that the files already exist in the destination directory.
	7		Files were copied, a file mismatch was present, and additional files were present.
	8		Several files did not copy.
	
	Any value greater than 8 indicates that there was at least one failure during the copy operation.
	#>
	[CmdletBinding()]
	Param(
		[Parameter(Position=0,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
		[ValidateScript({Test-Path $_})]
		[string] $Src,
		
		[Parameter(Position=1,Mandatory=$true,ValueFromPipelineByPropertyName=$true)]
		[string] $Dst,
		
		[Parameter(Position=2,ValueFromPipelineByPropertyName=$true)]
		[string] $Log = [IO.Path]::GetTempFileName(),

		[Parameter()]
		[string] $Switches = "/NP /MIR /R:3 /W:5" 
	)

	begin {
		$ReturnCodes = @{
			0 = "No files were copied. No failure was encountered. No files were mismatched. The files already exist in the destination directory; therefore, the copy operation was skipped.";
			1 = "All files were copied successfully.";
			2 = "There are some additional files in the destination directory that are not present in the source directory. No files were copied.";
			3 = "Some files were copied. Additional files were present. No failure was encountered.";
			5 = "Some files were copied. Some files were mismatched. No failure was encountered.";
			6 = "Additional files and mismatched files exist. No files were copied and no failures were encountered. This means that the files already exist in the destination directory.";
			7 = "Files were copied, a file mismatch was present, and additional files were present.";
			8 = "Several files did not copy.";
		}
	}

	process {
		Write-Verbose ("Invoking RoboCopy: '{0}' -> '{1}'" -f $Src, $Dst)

		$expr = "robocopy.exe '{0}' '{1}' {2} /LOG:'{3}'" -f $Src, $Dst, $Switches, $Log

		Write-Debug "cmd: $expr"
		Write-Verbose "Log: $log"

		Invoke-Expression $expr | Out-Null

		Write-Debug "ret: $LastExitCode"
		Write-Verbose ("{0}" -f $ReturnCodes[$LastExitCode])

		#switch ($LastExitCode) {
		#	# no errors
		#	0 {}
		#	1 {}
		#	{$_ -ge 2 -and $_ -lt 8} {}
		#	# errors
		#	{$_ -ge 8} {}
		#}

		#return $LastExitCode
	}
}
