# FileOperations.ps1

# Function to create a text file
function New-SampleFile {
    param (
        [string]$FilePath = "C:\Temp\SampleFile.txt"
    )
    try {
        "Hello, this is a test file!" | Out-File -FilePath $FilePath -Force
        return $true
    } catch {
        Write-Error "Failed to create file: $_"
        return $false
    }
}

# Function to move the file
function Move-SampleFile {
    param (
        [string]$SourcePath = "C:\Temp\SampleFile.txt",
        [string]$DestinationPath = "C:\Temp\MovedSampleFile.txt"
    )
    try {
        if (Test-Path $SourcePath) {
            Move-Item -Path $SourcePath -Destination $DestinationPath -Force
            return $true
        } else {
            Write-Error "Source file does not exist."
            return $false
        }
    } catch {
        Write-Error "Failed to move file: $_"
        return $false
    }
}

# Function to validate file existence
function Test-FileExists {
    param (
        [string]$FilePath = "C:\Temp\MovedSampleFile.txt"
    )
    return Test-Path $FilePath
}

# Function to show a popup
function Show-DonePopup {
    Add-Type -AssemblyName System.Windows.Forms
    [System.Windows.Forms.MessageBox]::Show("File operations completed!", "Done", 
        [System.Windows.Forms.MessageBoxButtons]::OK, 
        [System.Windows.Forms.MessageBoxIcon]::Information)
}

# Main execution
function Start-FileOperations {
    $created = New-SampleFile
    if ($created) {
        $moved = Move-SampleFile
        if ($moved) {
            $exists = Test-FileExists
            if ($exists) {
                Show-DonePopup
                Write-Output "All operations completed successfully."
            } else {
                Write-Error "Validation failed: File not found at destination."
            }
        }
    }
}

# Run the script
Start-FileOperations