# FileOperations.Tests.ps1

# Import the script to test
. "$PSScriptRoot\FileOperations.ps1"

# Ensure Pester is installed (for local testing)
if (-not (Get-Module -ListAvailable -Name Pester)) {
    Install-Module -Name Pester -Force -SkipPublisherCheck
}
Import-Module Pester -MinimumVersion 5.0.0

Describe "FileOperations Tests" {
    BeforeEach {
        # Setup: Create a temp directory if it doesn't exist
        if (-not (Test-Path "C:\Temp")) {
            New-Item -Path "C:\Temp" -ItemType Directory -Force
        }
        # Clean up any existing files
        Remove-Item -Path "C:\Temp\SampleFile.txt" -ErrorAction SilentlyContinue
        Remove-Item -Path "C:\Temp\MovedSampleFile.txt" -ErrorAction SilentlyContinue
    }

    AfterEach {
        # Cleanup
        Remove-Item -Path "C:\Temp\SampleFile.txt" -ErrorAction SilentlyContinue
        Remove-Item -Path "C:\Temp\MovedSampleFile.txt" -ErrorAction SilentlyContinue
    }

    It "New-SampleFile creates a file successfully" {
        $result = New-SampleFile -FilePath "C:\Temp\SampleFile.txt"
        $result | Should -Be $true
        Test-Path "C:\Temp\SampleFile.txt" | Should -Be $true
    }

    It "New-SampleFile handles errors gracefully" {
        # Simulate an error by using a read-only path (mocking could be better, but keeping it simple)
        Mock Out-File { throw "Permission denied" }
        $result = New-SampleFile -FilePath "C:\Temp\SampleFile.txt"
        $result | Should -Be $false
    }

    It "Move-SampleFile moves the file successfully" {
        New-SampleFile -FilePath "C:\Temp\SampleFile.txt"
        $result = Move-SampleFile -SourcePath "C:\Temp\SampleFile.txt" -DestinationPath "C:\Temp\MovedSampleFile.txt"
        $result | Should -Be $true
        Test-Path "C:\Temp\MovedSampleFile.txt" | Should -Be $true
        Test-Path "C:\Temp\SampleFile.txt" | Should -Be $false
    }

    It "Move-SampleFile fails if source doesn't exist" {
        $result = Move-SampleFile -SourcePath "C:\Temp\NonExistent.txt" -DestinationPath "C:\Temp\MovedSampleFile.txt"
        $result | Should -Be $false
    }

    It "Test-FileExists validates file presence" {
        New-SampleFile -FilePath "C:\Temp\MovedSampleFile.txt"
        $result = Test-FileExists -FilePath "C:\Temp\MovedSampleFile.txt"
        $result | Should -Be $true
    }

    It "Test-FileExists returns false for missing file" {
        $result = Test-FileExists -FilePath "C:\Temp\NonExistent.txt"
        $result | Should -Be $false
    }
}