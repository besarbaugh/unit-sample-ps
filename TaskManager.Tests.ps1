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
    }

    AfterEach {
        # Reset global tasks again to ensure no leftover data
        $global:Tasks = @()
    }

    It "Adds a task successfully" {
        Add-Task "Test task"
        $global:Tasks | Should -Contain "Test task"
    }

    It "Removes a task successfully" {
        Add-Task "Test task"
        Remove-Task "Test task"
        $global:Tasks | Should -Be @()
    }

    It "Does not remove a non-existent task" {
        Remove-Task "Non-existent task"
        List-Tasks | Should -Be "No tasks found."
    }

    It "Lists tasks correctly when tasks are present" {
        Add-Task "Task 1"
        Add-Task "Task 2"
        List-Tasks | Should -Match "Tasks:`n1. Task 1`n2. Task 2"
    }

    It "Lists no tasks when none are present" {
        List-Tasks | Should -Be "No tasks found."
    }
}