# TaskManager.tests.ps1

# Import the script to test
. "$PSScriptRoot\TaskManager.ps1"

# Ensure Pester is installed (for local testing)
if (-not (Get-Module -ListAvailable -Name Pester)) {
    Install-Module -Name Pester -Force -SkipPublisherCheck
}
Import-Module Pester -MinimumVersion 5.0.0

Describe "TaskManager Tests" {
    BeforeEach {
        # Reset global tasks
        $global:Tasks = @()
        # Clear output buffer before each test
        $global:OutputBuffer = @()

        # Mock Write-Output to capture output
        Mock Write-Output {
            param ($Object)
            $global:OutputBuffer += $Object
        }

        # Mock Write-Warning to capture warnings
        Mock Write-Warning {
            param ($Message)
            $global:OutputBuffer += $Message
        }
    }

    AfterEach {
        # Reset global tasks again to ensure no leftover data
        $global:Tasks = @()
        # Clear output buffer after each test
        $global:OutputBuffer = @()
        #Clean up mocks
        Clear-Mock Write-Output
        Clear-Mock Write-Warning
    }

    Context "Add-Task" {
        It "Adds a task successfully" {
            Add-Task "Test task"
            $global:Tasks | Should -Contain "Test task"
            $global:OutputBuffer | Should -Contain "Task added: Test task"
        }

        It "Adds multiple tasks successfully" {
            Add-Task "Task 1"
            Add-Task "Task 2"
            $global:Tasks | Should -Contain "Task 1"
            $global:Tasks | Should -Contain "Task 2"
            $global:OutputBuffer | Should -Contain "Task added: Task 1"
            $global:OutputBuffer | Should -Contain "Task added: Task 2"
        }
    }

    Context "Remove-Task" {
        It "Removes a task successfully" {
            Add-Task "Test task"
            Remove-Task "Test task"
            $global:Tasks | Should -Be @()
            $global:OutputBuffer | Should -Contain "Task removed: Test task"
        }

        It "Does not remove a non-existent task" {
            Remove-Task "Non-existent task"
            $global:Tasks | Should -Be @()
            $global:OutputBuffer | Should -Contain "Task not found: Non-existent task"
        }

        It "Removes correct task from multiple tasks" {
            Add-Task "Task 1"
            Add-Task "Task 2"
            Remove-Task "Task 1"
            $global:Tasks | Should -Not -Contain "Task 1"
            $global:Tasks | Should -Contain "Task 2"
            $global:OutputBuffer | Should -Contain "Task removed: Task 1"
        }
    }

    Context "List-Tasks" {
        It "Lists tasks correctly when tasks are present" {
            Add-Task "Task 1"
            Add-Task "Task 2"
            List-Tasks
            $global:OutputBuffer | Should -Contain "Tasks:"
            $global:OutputBuffer | Should -Contain "1. Task 1"
            $global:OutputBuffer | Should -Contain "2. Task 2"
        }

        It "Lists no tasks when none are present" {
            List-Tasks
            $global:OutputBuffer | Should -Contain "No tasks found."
        }
    }
}
