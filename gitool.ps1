<#
  ============================================================================================
            GITHUB TOOL
            Created By: Oxygene
            Version: 1.0.0
  ============================================================================================
#>

# ---------------- Global Vars ---------------- 
[string]$pages = "0"
[bool]$running = $true
[string]$LoggedIn = "Status Logged - In"
[string]$LoggedOut = "Status Logged - Out"
[int]$ListPage = 1
[bool]$isCommitted = $false

# ======================= Pages
[string]$List1 = @"
1.) Login           4.) Add Git             7.) Remove Git Folder
2.) Logout          5.) Push Git
3.) Initialise Git  6.) Remove Added Files
"@

function NewLine {
  return Write-Host ""
}

# === === === === === === === SYSTEM RUN === === === === === === === 
while ($running) {
  # ================================================ FUNCTIONS HERE
  # Activity Status
  function Get-Git-Status-Authentication {
    $authenticationJSON = gh auth status --json hosts 2>$null | ConvertFrom-Json
    $authStatus = $authenticationJSON.hosts.PSObject.Properties.Count -gt 0
    
    if ($authStatus) {
      return Write-Host "$LoggedIn" -ForegroundColor Green
    } else {
      return Write-Host "$LoggedOut" -ForegroundColor Red
    }
  }

  # List Function
  function Get-List-Options {
    if ($ListPage -eq 1) {
      return Write-Host "$List1" -ForegroundColor Cyan
    }
  }

  # === === === === === === PAGE HERE === === === === === ===
  # Lobby
  if ($pages -eq "0"){
    Clear-Host
    Write-Host "=================== Welcome to Github Tool Helper ===================" -ForegroundColor Green
    Get-Git-Status-Authentication
    NewLine
    Get-List-Options
    Write-Host ""
    Write-Host "===================== || Type 'Exit' to end || =====================" -ForegroundColor Green
    NewLine
    $pick = Read-Host ">>>"
    if ($pick.ToLower() -eq "n") {
      $ListPage++
    } elseif ($pick.ToLower() -eq "p" -and $ListPage -gt 1) {
      $ListPage--
    } else {
      $pages = $pick
    }
  }

  # ================================================ Authentication Login
  elseif ($pages -eq "1") {
    Clear-Host
    gh auth login
    Pause
    $pages = "0"
  }

  # ================================================ Authentication Logout
  elseif ($pages -eq "2") {
    Clear-Host
    gh auth logout
    Pause
    $pages = "0"
  }

  # ================================================ Initialised Git
  elseif ($pages -eq "3") {
    Clear-Host
    git init
    Write-Host "Git Initialised Successfully!" -ForegroundColor Green
    Pause
    $pages = "0"
  }

  # ================================================ Git Add
  elseif ($pages -eq "4") {
    Clear-Host
    if (-not (Test-Path .\.git)) {
      Write-Host "Initialise your git first!" -ForegroundColor Red
      Pause
      $pages = "0"
    } else {
      Write-Host "====================" -ForegroundColor Green
      NewLine
      Write-Host "1.) Add all Files"
      Write-Host "2.) Add specific file/s"
      Write-Host "3.) Go Back"
      NewLine
      Write-Host "====================" -ForegroundColor Green
      NewLine
      $choose4 = Read-Host ">>>"
      if ($choose4 -eq "1") {
        Clear-Host
        git add .
        Write-Host "Added Files to git successfully!" -ForegroundColor Green
        Pause
        $pages = "0"
      }  elseif ($choose4 -eq "2") {
        Clear-Host
        Write-Host "For Specific file (e.g., file.txt)" -ForegroundColor Yellow
        Write-Host "For Multiple Files (e.g., file1.txt file2.txt)" -ForegroundColor Yellow
        Write-Host "For Specific Directory (e.g., src/page)" -ForegroundColor Yellow
        Write-Host "For Specific Directory and specific file (e.g., src/page/file.txt)" -ForegroundColor Yellow
        NewLine
        $fileInput4 = (Read-Host ">>>").Split(" ")
        if (($fileInput4 | Test-Path) -notcontains $false) {
          git add $fileInput4
          Write-Host "Added File/s to git successfully!" -ForegroundColor Green
          Pause
          $pages = "0"
        } else {
          Clear-Host
          Write-Host "File or Directory does not exist..." -ForegroundColor Red
          Pause
          $pages = "4"
        }
      } elseif ($choose4 -eq "3") {
        $pages = "0"
      }
      
      # Invalid Input
      else {
        Clear-Host
        Write-Host "Invalid Input... " -ForegroundColor Red
        Pause
        $pages = "4"
      }
    }
  }

  # ================================================ Push Git Files
  elseif ($pages -eq "5") {
    Clear-Host
    $authenticationJSONCHECK = gh auth status --json hosts 2>$null | ConvertFrom-Json
    $authStatusBool = $authenticationJSONCHECK.hosts.PSObject.Properties.Count -gt 0
    if (-not (Test-Path .\.git)) {
      Write-Host "Initialise your git first!" -ForegroundColor Red
      Pause
      $pages = "0"
    } elseif (-not $authStatusBool) {
      Write-Host "Loggin First before you push!" -ForegroundColor Red
      Pause
      $pages = "0"
    } else {
      if (-not $isCommitted) {
        Write-Host "Add a commit message for your files (e.g. this file is updated or released)" -ForegroundColor Yellow
        NewLine
        $CommitMessage = Read-Host ">>>"
        git commit -m "$CommitMessage"
        $isCommitted = $true
        Clear-Host
      }
      Write-Host "====================" -ForegroundColor Green
      NewLine
      Write-Host "1.) Create New Repository" -ForegroundColor Cyan
      Write-Host "2.) Existed Repository" -ForegroundColor Cyan
      Write-Host "3.) Go Back" -ForegroundColor Cyan
      NewLine
      Write-Host "====================" -ForegroundColor Green
      NewLine
      $choose5 = Read-Host ">>>"

      if ($choose5 -eq "1") {
        Clear-Host
        Write-Host "Give a name of your Repository" -ForegroundColor Yellow
        $RepoName = Read-Host ">>>"
        Write-Host "Make is public? (y/n)" -ForegroundColor Yellow
        $PublicPrompt = Read-Host ">>>"
        Write-Host "Type your branch if you have; Just press 'ENTER' if you choose main" -ForegroundColor Yellow
        $BranchInput1 = Read-Host ">>>"

        if ($PublicPrompt.ToLower() -eq "y") {
          # Default Main Branch
          if (-not $BranchInput1) {
            gh repo create $RepoName --public --source=. --remote=origin
            git push -u origin main
            Write-Host "File is Pushed Successfully!" -ForegroundColor Green
            $isCommitted = $false
            Pause
            $pages = "0"
          } else {
            gh repo create $RepoName --public --source=. --remote=origin
            git push -u origin $BranchInput1
            Write-Host "File is Pushed Successfully!" -ForegroundColor Green
            $isCommitted = $false
            Pause
            $pages = "0"
          }
        } elseif ($PublicPrompt.ToLower() -eq "n") {
          gh repo create $RepoName --private --source=. --remote=origin
          git push -u origin main
          Write-Host "File is Pushed Successfully!" -ForegroundColor Green
          $isCommitted = $false
          Pause
          $pages = "0"
        } else {
          Clear-Host
          Write-Host "Invalid Input... " -ForegroundColor Red
          Pause
          $pages = "5"
        }
      } elseif ($choose5 -eq "2") {
        Clear-Host
        Write-Host "Copy the Github Link of your Repository, Press 'ENTER' after copying it, Or Type it manually" -ForegroundColor Yellow
        $RepoExistLink = Read-Host ">>>"
        if (-not $RepoExistLink) {
            $RepoExistLink = Get-Clipboard
        }
        Write-Host "Type your branch if you have; Just press 'ENTER' if you choose main" -ForegroundColor Yellow
        $BranchInput2 = Read-Host ">>>"

        # Default Main
        if (-not $BranchInput2) {
          if (-not (git remote get-url origin 2>&1 | Out-Null)) {
            git remote add origin $RepoExistLink
          } else {
            git remote set-url origin $RepoExistLink
          }
          git pull origin main --allow-unrelated-histories
          git push -u origin main
          Write-Host "File is Pushed Successfully!" -ForegroundColor Green
          $isCommitted = $false
          Pause
          $pages = "0"
        } else {
          if (-not (git remote get-url origin 2>&1 | Out-Null)) {
            git remote add origin $RepoExistLink
          } else {
            git remote set-url origin $RepoExistLink
          }
          git pull origin $BranchInput2 --allow-unrelated-histories
          git push -u origin $BranchInput2
          Write-Host "File is Pushed Successfully!" -ForegroundColor Green
          $isCommitted = $false
          Pause
          $pages = "0"
        }
      } elseif ($choose5 -eq "3") {
        $pages = "0"
      } else {
        Clear-Host
        Write-Host "Invalid Input... " -ForegroundColor Red
        Pause
      }
    }
  }

  # ================================================ Removing Git Added Files
  elseif ($pages -eq "6") {
    if (-not (Test-Path .\.git)) {
      Write-Host "Initialise your git first!" -ForegroundColor Red
      Pause
      $pages = "0"
    } else {
      Clear-Host
      Write-Host "====================" -ForegroundColor Green
      NewLine
      Write-Host "1.) Remove all Files"
      Write-Host "2.) Remove specific file/s"
      Write-Host "3.) Go Back"
      NewLine
      Write-Host "====================" -ForegroundColor Green
      NewLine
      $choose6 = Read-Host ">>>"
      if ($choose6 -eq "1") {
        Clear-Host
        git reset
        Write-Host "Removed Files to git successfully!" -ForegroundColor Green
        Pause
      }  elseif ($choose6 -eq "2") {
        Clear-Host
        Write-Host "For Specific file (e.g., file.txt)" -ForegroundColor Yellow
        Write-Host "For Multiple Files (e.g., file1.txt file2.txt)" -ForegroundColor Yellow
        Write-Host "For Specific Directory (e.g., src/page)" -ForegroundColor Yellow
        Write-Host "For Specific Directory and specific file (e.g., src/page/file.txt)" -ForegroundColor Yellow
        NewLine
        $fileInput6 = (Read-Host ">>>").Split(" ")
        if (($fileInput6 | Test-Path) -notcontains $false) {
          git reset HEAD -- $fileInput6
          Write-Host "Removed File/s to git successfully!" -ForegroundColor Green
          Pause
          $pages = "0"
        } else {
          Clear-Host
          Write-Host "File or Directory does not exist..." -ForegroundColor Red
          Pause
          $pages = "4"
        }
      } elseif ($choose6 -eq "3") {
        $pages = "0"
      }
      
      else {
        Clear-Host
        Write-Host "Invalid Input... " -ForegroundColor Red
        Pause
      }
    }
  }

  # ================================================ Exit Program
  elseif ($pages -eq "7") {
    Clear-Host
    if (-not (Test-Path .\.git)) {
      Write-Host "Initialise your git first!" -ForegroundColor Red
      Pause
      $pages = "0"
    } else {
      Write-Host "WARNING! Removing the .git Folder will delete everything locally!" -ForegroundColor Red
      Write-Host "Type 'DELETE' to proceed; otherwise press 'ENTER' button to cancel"
      NewLine
      $input7 = Read-Host ">>>"
      if ($input7.ToLower() -eq "delete") {
        Remove-Item -Recurse -Force .git
        Write-Host ".git folder removed successfully!" -ForegroundColor Green
        Pause
        $pages = "0"
      } else {
        $pages = "0"
      }
    }
  }

  # ================================================ Exit Program
  elseif ($pages.ToLower() -eq "exit") {
    $running = $false
  }

  # ================================================ Invalid input
  else {
    Clear-Host
    Write-Host "Invalid Input... " -ForegroundColor Red
    Pause
    $pages = "0"
  }
}
Clear-Host
