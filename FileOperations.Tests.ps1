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

    Mock New-SampleFile { return $true }
    Mock Move-SampleFile { return $true }
    Mock Test-FileExists { return $true }

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
# Additional tests for FileOperations.ps1

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

    Mock New-SampleFile { return $true }
    Mock Move-SampleFile { return $true }
    Mock Test-FileExists { return $true }
    Mock Show-DonePopup { }

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

    It "Show-DonePopup displays a message box" {
        Mock Add-Type { }
        Mock [System.Windows.Forms.MessageBox]::Show { return [System.Windows.Forms.DialogResult]::OK }
        Show-DonePopup
        Assert-MockCalled -CommandName [System.Windows.Forms.MessageBox]::Show -Exactly 1
    }

    It "Start-FileOperations completes all operations successfully" {
        Mock New-SampleFile { return $true }
        Mock Move-SampleFile { return $true }
        Mock Test-FileExists { return $true }
        Mock Show-DonePopup { }

        Start-FileOperations

        Assert-MockCalled -CommandName New-SampleFile -Exactly 1
        Assert-MockCalled -CommandName Move-SampleFile -Exactly 1
        Assert-MockCalled -CommandName Test-FileExists -Exactly 1
        Assert-MockCalled -CommandName Show-DonePopup -Exactly 1
    }

    It "Start-FileOperations handles file creation failure" {
        Mock New-SampleFile { return $false }
        Mock Move-SampleFile { }
        Mock Test-FileExists { }
        Mock Show-DonePopup { }

        Start-FileOperations

        Assert-MockCalled -CommandName New-SampleFile -Exactly 1
        Assert-MockCalled -CommandName Move-SampleFile -Exactly 0
        Assert-MockCalled -CommandName Test-FileExists -Exactly 0
        Assert-MockCalled -CommandName Show-DonePopup -Exactly 0
    }

    It "Start-FileOperations handles file move failure" {
        Mock New-SampleFile { return $true }
        Mock Move-SampleFile { return $false }
        Mock Test-FileExists { }
        Mock Show-DonePopup { }

        Start-FileOperations

        Assert-MockCalled -CommandName New-SampleFile -Exactly 1
        Assert-MockCalled -CommandName Move-SampleFile -Exactly 1
        Assert-MockCalled -CommandName Test-FileExists -Exactly 0
        Assert-MockCalled -CommandName Show-DonePopup -Exactly 0
    }

    It "Start-FileOperations handles file existence validation failure" {
        Mock New-SampleFile { return $true }
        Mock Move-SampleFile { return $true }
        Mock Test-FileExists { return $false }
        Mock Show-DonePopup { }

        Start-FileOperations

        Assert-MockCalled -CommandName New-SampleFile -Exactly 1
        Assert-MockCalled -CommandName Move-SampleFile -Exactly 1
        Assert-MockCalled -CommandName Test-FileExists -Exactly 1
        Assert-MockCalled -CommandName Show-DonePopup -Exactly 0
    }
}