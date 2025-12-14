Install [Python](https://www.python.org/downloads)
<br>PowerShell
> ```shell
> # $Env:http_proxy="http://127.0.0.1:10808"
> # $Env:https_proxy="http://127.0.0.1:10808"
> ```
Or CMD
> ```cmd
> # set "http_proxy=http://192.168.10.103:10810"
> # set "https_proxy=http://192.168.10.103:10810"
> # set "http_proxy=http://127.0.0.1:10808
> # set "https_proxy=http://127.0.0.1:10808
> ```
```cmd
python.exe -m pip install --upgrade pip
pip install pyinstaller
```
```
git clone --recurse-submodules https://github.com/openscopeproject/InteractiveHtmlBom.git
```
Copy `automated_build.ps1` and `bomicon.ico` into `InteractiveHtmlBom`, `automated_build.ps1` must be changed to ANSI.
```txt
InteractiveHtmlBom
|   .gitignore
|   .jsbeautifyrc
|   automated_build.ps1        # Must be changed to ANSI.
|   bomicon.ico
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

PowerShell
```powershell
Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
```
```powershell
.\automated_build.ps1
```

Move `REG_HKCR_BOM.bat` into `InteractiveHtmlBom\dist\generate_interactive_bom\` , then share `generate_interactive_bom`.
<br>
Double click `REG_HKCR_BOM.bat` .
<br>
Shift + Rightclick `.json` from [EasyEDA Std Edition](https://easyeda.com/), Select `InteractiveBom`, enjoy.
