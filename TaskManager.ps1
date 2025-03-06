# TaskManager.ps1

# Global variable to store tasks
$global:Tasks = @()

# Function to add a task
function Add-Task {
    param ([string]$Task)
    $global:Tasks += $Task
    Write-Output "Task added: $Task"
}

# Function to remove a task
function Remove-Task {
    param ([string]$Task)
    $index = $global:Tasks.IndexOf($Task)
    if ($index -ne -1) {
        $global:Tasks = $global:Tasks | Where { $_ -ne $Task }
        Write-Output "Task removed: $Task"
    } else {
        Write-Warning "Task not found: $Task"
    }
}

# Function to list all tasks
function List-Tasks {
    if ($global:Tasks.Count -gt 0) {
        Write-Output "Tasks:"
        for ($i = 0; $i -lt $global:Tasks.Count; $i++) {
            Write-Output "$($i+1). $($global:Tasks[$i])"
        }
    } else {
        Write-Output "No tasks found."
    }
}

# Example usage
Add-Task "Buy milk"
Add-Task "Walk the dog"
List-Tasks
Remove-Task "Buy milk"
List-Tasks