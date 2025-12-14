Install [Python](https://www.python.org/downloads)
<br>PowerShell
```shell
# $Env:http_proxy="http://192.168.10.103:10810" 
# $Env:https_proxy="http://192.168.10.103:10810"
# $Env:http_proxy="http://127.0.0.1:10808"
# $Env:https_proxy="http://127.0.0.1:10808"
python.exe -m pip install --upgrade pip
pip install pyinstaller
```
Install [Git](https://git-scm.com/install/windows)
```shell
winget install --id Git.Git -e --source winget
```
```shell
git clone --recurse-submodules https://github.com/openscopeproject/InteractiveHtmlBom.git
cd InteractiveHtmlBom
```

Copy `automated_build.ps1` and `bomicon.ico` into `InteractiveHtmlBom`.
```txt
InteractiveHtmlBom
|   .gitignore
|   .jsbeautifyrc
|   automated_build.ps1        # Copy here
|   bomicon.ico                # Copy here
|   DATAFORMAT.md
|   LICENSE
|   pyproject.toml
|   README.md
|   settings_dialog.fbp
|   __init__.py
+---.github
+---icons
+---InteractiveHtmlBom
\---tests
```

Change `automated_build.ps1`  from UTF-8 to ANSI.

```shell
Set-Content -Path "automated_build.ps1" -Value (Get-Content -Path "automated_build.ps1" -Raw  -Encoding UTF8) -Encoding Default
```

Package

```shell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
.\automated_build.ps1
```

Move `REG_HKCR_BOM.bat` into `InteractiveHtmlBom\dist\generate_interactive_bom\` , then share `generate_interactive_bom`.
<br><br>
Double click `REG_HKCR_BOM.bat` in `generate_interactive_bom`.
<br><br>
Shift + Rightclick `.json` from [EasyEDA Std Edition](https://easyeda.com/), Select `InteractiveBom`, enjoy.
