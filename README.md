# 🚀 GitHub Tool Helper

![PowerShell](https://img.shields.io/badge/Language-PowerShell-blue?logo=powershell)
![GitHub CLI](https://img.shields.io/badge/GitHub-CLI-black?logo=github)

> A sleek **PowerShell menu tool** to manage Git and GitHub repositories with ease. Built by **Oxygene**.

---

## 🌟 Features

- **Authentication**
  - Check GitHub login status
  - Login / Logout from GitHub CLI
- **Git Management**
  - Initialize a local repository
  - Add all or specific files
  - Commit changes with messages
- **Repository Handling**
  - Push to new or existing repositories
  - Pull and update branches
  - Remove `.git` folder safely
- **Interactive Experience**
  - Colorful terminal outputs
  - Menu-driven workflow
  - Easy navigation between options

---

## ⚡ Requirements

Before running the tool, make sure you have the following installed:

- [Git](https://git-scm.com/) – for version control  
- [GitHub CLI (`gh`)](https://cli.github.com/) – for authentication and repository management  
- PowerShell 5.1 or newer (Windows) / PowerShell Core (cross-platform)

---

## 🎬 Usage

1. Open **PowerShell**.  
2. Navigate to the folder where your script is located, for example:  
   ```powershell
   cd C:\PATH\TO\YOUR\GITHUBTOOL\gitool.ps1
   ```
**Optional Shortcut: Run `gitool` from anywhere**  

Instead of navigating to the script folder every time, you can:  

1. Open **Edit Environment Variables** in Windows.  
2. Add the **directory path** where `gitool.ps1` is located (e.g., `C:\PATH\TO\YOUR\GITHUBTOOL`) to your **system PATH**.  
3. Open a new PowerShell or Command Prompt window.  
4. Now you can simply type:  
   ```powershell or CMD
   gitool
   ```
   
