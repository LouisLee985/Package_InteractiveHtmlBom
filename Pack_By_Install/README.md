Install [Python](https://www.python.org/downloads)
<br>

```cmd
set "http_proxy=http://192.168.10.103:10810"
set "https_proxy=http://192.168.10.103:10810"
# set "http_proxy=http://127.0.0.1:10808
# set "https_proxy=http://127.0.0.1:10808
```
```cmd
python.exe -m pip install --upgrade pip
pip install pyinstaller
```
```cmd
pip install InteractiveHtmlBom
```

Edit `C:\Users\WIN7\AppData\Local\Programs\Python\Python38-32\Lib\site-packages\InteractiveHtmlBom\generate_interactive_bom.py`
<br>
```patch
-    from .core import ibom
-    from .core.config import Config
-    from .ecad import get_parser_by_extension
-    from .version import version
-    from .errors import (ExitCodes, ParsingException, exit_error)
+    from InteractiveHtmlBom.core import ibom
+    from InteractiveHtmlBom.core.config import Config
+    from InteractiveHtmlBom.ecad import get_parser_by_extension
+    from InteractiveHtmlBom.version import version
+    from InteractiveHtmlBom.errors import (ExitCodes, ParsingException, exit_error)
```

```cmd
"C:\Users\WIN7\AppData\Local\Programs\Python\Python38-32\Scripts\pyinstaller.exe" --noconfirm "C:\Users\WIN7\Desktop\generate_interactive_bom.spec" >outlog.txt 2>&1
```
