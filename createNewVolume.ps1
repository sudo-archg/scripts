# $diskToBeFormatted = "TestVM-dataDisk0"
Get-Disk | Where PartitionStyle -eq 'raw' |
    Initialize-Disk -PartitionStyle MBR -PassThru |
    New-Partition -AssignDriveLetter -UseMaximumSize |
    Format-Volume -FileSystem NTFS -NewFileSystemLabel "myNewDataDisk" -Confirm:$false