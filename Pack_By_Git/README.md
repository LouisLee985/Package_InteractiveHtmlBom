Install [Python](https://www.python.org/downloads)
<br>PowerShell
> ```shell
> # $Env:http_proxy="http://192.168.10.103:10810" 
> # $Env:http_proxy="http://192.168.10.103:10810"
> # $Env:http_proxy="http://127.0.0.1:10808"
> # $Env:https_proxy="http://127.0.0.1:10808"
> python.exe -m pip install --upgrade pip
> pip install pyinstaller
>```

>```shell
>git clone --recurse-submodules https://github.com/openscopeproject/InteractiveHtmlBom.git
>cd InteractiveHtmlBom
>```

Copy `automated_build.ps1` and `bomicon.ico` into `InteractiveHtmlBom`.
>```txt
>InteractiveHtmlBom
>|   .gitignore
>|   .jsbeautifyrc
>|   automated_build.ps1        # Copy here
>|   bomicon.ico                # Copy here
>|   DATAFORMAT.md
>|   LICENSE
>|   pyproject.toml
>|   README.md
>|   settings_dialog.fbp
>|   __init__.py
>+---.github
>+---icons
>+---InteractiveHtmlBom
>\---tests
>```

`automated_build.ps1` must be changed to ANSI from UTF-8.

>```shell
>Set-Content -Path "automated_build.ps1" -Value (Get-Content -Path "automated_build.ps1" -Raw  -Encoding UTF8) -Encoding Default
>```

>```shell
>Set-ExecutionPolicy -Scope CurrentUser Bypass -Force
>```
Package
>```shell
>.\automated_build.ps1
>```

Move `REG_HKCR_BOM.bat` into `InteractiveHtmlBom\dist\generate_interactive_bom\` , then share `generate_interactive_bom`.
<br><br>
Double click `REG_HKCR_BOM.bat` .
<br><br>
Shift + Rightclick `.json` from [EasyEDA Std Edition](https://easyeda.com/), Select `InteractiveBom`, enjoy.
