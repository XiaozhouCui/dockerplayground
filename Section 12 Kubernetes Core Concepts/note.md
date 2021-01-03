## Install Chocolatey
- Open power-shell as admin
- Run `Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))`

## Install kubectl
- Open power-shell as admin
- Run `choco install kubernetes-cli`
- To chekc if it's installed, run `kubectl version --client`

## Setup user folder
- In CMD, run `cd %USERPROFILE%` to goto the user folder
- Run `mkdir .kube` to create a new folder named `.kube`
- Goto the `.kube` folder and create a new file `config`, NO EXT.
