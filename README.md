# Requirement
need to have `make` command first.

### install make for windows
run the command in powershell with administrator user
```
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install make -y
make --version
```

### install make for macos
`brew install make`


# setup venv
```make```
