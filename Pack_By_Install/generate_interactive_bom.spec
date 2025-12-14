# -*- mode: python ; coding: utf-8 -*-

# 1. 变量定义
PYTHON_LIB_PATH = 'C:\\Users\\WIN7\\AppData\\Local\\Programs\\Python\\Python38-32\\Lib\\site-packages'
SCRIPT_PATH = PYTHON_LIB_PATH + '\\InteractiveHtmlBom\\generate_interactive_bom.py'
BOM_SOURCE_DIR = PYTHON_LIB_PATH + '\\InteractiveHtmlBom'

# 资源文件路径 (对应实际的 'web' 目录)
BOM_WEB_SRC = PYTHON_LIB_PATH + '\\InteractiveHtmlBom\\web' 
BOM_DST_DIR = 'InteractiveHtmlBom' # 目标位置：在运行时目录下的 InteractiveHtmlBom 文件夹内

a = Analysis(
    [SCRIPT_PATH],
    pathex=[],
    binaries=[],
    # 2. 资源添加 (datas)
    datas=[
        # 2.1 添加整个 web 目录（HTML/JS 模板）
        (BOM_WEB_SRC, BOM_DST_DIR + '\\web'),
        # 2.2 添加根目录下的 icon.png
        (PYTHON_LIB_PATH + '\\InteractiveHtmlBom\\icon.png', BOM_DST_DIR),
        # 2.3 添加对话框中的位图资源
        (PYTHON_LIB_PATH + '\\InteractiveHtmlBom\\dialog\\bitmaps', BOM_DST_DIR + '\\dialog\\bitmaps')
    ],
    # 3. Python 模块树添加 (trees)
    trees=[
        ('InteractiveHtmlBom', BOM_SOURCE_DIR, 'PYZ')
    ],
    hiddenimports=['InteractiveHtmlBom.core', 'InteractiveHtmlBom.ecad', 'InteractiveHtmlBom.errors'],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    [],
    exclude_binaries=True,
    name='generate_interactive_bom',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)

coll = COLLECT(
    exe,
    a.binaries,
    a.datas,
    strip=False,
    upx=True,
    upx_exclude=[],
    name='generate_interactive_bom',
)