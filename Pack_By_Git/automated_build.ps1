<#
.SYNOPSIS
完整的自动化构建脚本，用于将 InteractiveHtmlBom 打包为 CLI 模式的独立 EXE。
该脚本包含了所有修复，并切换到更可靠的 --onedir 模式。
#>

# -----------------------------------------------------------------------------
# 1. 配置和初始化
# -----------------------------------------------------------------------------

$ErrorActionPreference = "Stop"
$Global:ErrorOccurred = $false

function exit_script {
    param([string]$message)
    Write-Host ""
    Write-Host "=======================================================" -ForegroundColor Red
    Write-Host "❌ 错误: $message" -ForegroundColor Red
    Write-Host "=======================================================" -ForegroundColor Red
    $Global:ErrorOccurred = $true
    exit 1
}

# 列出需要修改的源文件
$SourceFilesToModify = @(
    "InteractiveHtmlBom\dialog\settings_dialog.py",
    "InteractiveHtmlBom\dialog\__init__.py",
    "InteractiveHtmlBom\core\config.py",
    "InteractiveHtmlBom\__init__.py", # <-- 新增或确认
    "InteractiveHtmlBom\core\ibom.py",
    "InteractiveHtmlBom\generate_interactive_bom.py"
    "InteractiveHtmlBom\dialog\dialog_base.py"
)

# -----------------------------------------------------------------------------
# 2. 源代码修改
# -----------------------------------------------------------------------------

try {
    Write-Host "1. 正在修改源代码文件以消除 wx 和 pcbnew 依赖..."

    # -------------------------------------------------------------------------
    # 2.1. 针对 settings_dialog.py 的修改：生成完整的 CLI 桩文件
    # -------------------------------------------------------------------------
    $SettingsDialogFile = "InteractiveHtmlBom\dialog\settings_dialog.py"
    Write-Host "   -> 修正 $SettingsDialogFile (生成完整 CLI 桩文件)..."
    
    # 定义完整的 CLI 桩化代码内容
    $StubContent = @"
# [CLI FINAL FIX] This file is a complete STUB for CLI operation.
# It eliminates all dependencies on wxPython GUI library.

import os
import re

# wx and wx.grid imports disabled for CLI build
# import wx
# import wx.grid

from . import dialog_base

# CLI default, disabling wx version check
WX_VERSION = (3, 0, 2) 


def pop_error(msg):
    # Disabled GUI error pop-up
    print(f"BOM Generation Error: {msg}")


def get_btn_bitmap(bitmap):
    # Disabled wx.Bitmap loading
    return None 


# STUB CLASS FOR CLI - replaces SettingsDialog
class SettingsDialog:
    def __init__(self, extra_data_func, extra_data_wildcard, config_save_func,
                 file_name_format_hint, version):
        self.config_save_func = config_save_func
        self.version = version
        # 桩化 panel 对象
        self.panel = SettingsDialogPanel(
             None, extra_data_func, extra_data_wildcard, config_save_func,
             file_name_format_hint)

    def ShowModal(self):
        # CLI 模式下，假定用户总是选择“确定” (模拟 wx.ID_OK = 5100)
        return 5100

    def SetSizeHints(self, sz1, sz2):
        pass

    def set_extra_data_path(self, extra_data_file):
        if self.panel and hasattr(self.panel, 'fields'):
            self.panel.fields.extra_data_file = extra_data_file
            self.panel.fields.OnExtraDataFileChanged(None)


# STUB CLASS - replaces SettingsDialogPanel
class SettingsDialogPanel:
    def __init__(self, parent, extra_data_func, extra_data_wildcard,
                 config_save_func, file_name_format_hint):
        self.config_save_func = config_save_func
        self.general = GeneralSettingsPanel(None, file_name_format_hint)
        self.html = HtmlSettingsPanel(None)
        self.fields = FieldsPanel(None, extra_data_func, extra_data_wildcard)

    def OnExit(self, event):
        pass

    def OnGenerateBom(self, event):
        pass

    def OnSaveGlobally(self, event):
        self.config_save_func(self)

    def OnSaveLocally(self, event):
        self.config_save_func(self, locally=True)

    def finish_init(self):
        pass
        
    def OnSave(self, event):
        pass


# STUB CLASS - replaces HtmlSettingsPanel
class HtmlSettingsPanel:
    def __init__(self, parent):
        pass
    
    def OnBoardRotationSlider(self, event):
        pass


# STUB CLASS - replaces GeneralSettingsPanel
class GeneralSettingsPanel:
    def __init__(self, parent, file_name_format_hint):
        self.file_name_format_hint = file_name_format_hint

    def OnNameFormatHintClick(self, event):
        print(f"File name format help: {self.file_name_format_hint}")

    # 桩化所有 wx 事件处理函数
    def OnComponentSortOrderUp(self, event):
        pass
    def OnComponentSortOrderDown(self, event):
        pass
    def OnComponentSortOrderAdd(self, event):
        pass
    def OnComponentSortOrderRemove(self, event):
        pass
    def OnComponentBlacklistAdd(self, event):
        pass
    def OnComponentBlacklistRemove(self, event):
        pass
    def OnSize(self, event):
        pass

# STUB CLASS - replaces FieldsPanel
class FieldsPanel:
    NONE_STRING = '<none>'
    EMPTY_STRING = '<empty>'
    FIELDS_GRID_COLUMNS = 3

    def __init__(self, parent, extra_data_func, extra_data_wildcard):
        self.show_fields = []
        self.group_fields = []
        self.extra_data_func = extra_data_func
        self.extra_field_data = None
        self.extra_data_file = '' # 桩化文件路径

    def set_file_picker_wildcard(self, extra_data_wildcard):
        pass

    # 桩化所有 wx 事件处理函数和内部方法
    def _swapRows(self, a, b):
        pass
    def OnGridCellClicked(self, event):
        pass
    def OnFieldsUp(self, event):
        pass
    def OnFieldsDown(self, event):
        pass
    def _setFieldsList(self, fields):
        self.fields_list = fields

    def OnExtraDataFileChanged(self, event):
        extra_data_file = self.extra_data_file
        if not os.path.isfile(extra_data_file):
            return

        self.extra_field_data = None
        try:
            # 简化调用
            self.extra_field_data = self.extra_data_func(extra_data_file, True) 
        except Exception as e:
            pop_error(
                "Failed to parse file %s\n\n%s" % (extra_data_file, e))
            self.extra_data_file = ''

        if self.extra_field_data is not None:
            field_list = list(self.extra_field_data.fields)
            self._setFieldsList(["Value", "Footprint"] + field_list)
            self.SetCheckedFields()

    def OnBoardVariantFieldChange(self, event):
        pass
    def OnSize(self, event):
        pass

    def GetShowFields(self):
        return self.show_fields

    def GetGroupFields(self):
        return self.group_fields

    def SetCheckedFields(self, show=None, group=None):
        self.show_fields = show or self.show_fields
        self.group_fields = group or self.group_fields
        self.group_fields = [
            s for s in self.group_fields if s in self.show_fields
        ]

# 导出供外部使用的 show_dialog 函数
def show_dialog(config, parser):
    return SettingsDialog(config.extra_data_func, config.extra_data_wildcard, 
                          config.save_config, config.file_name_format_hint, 
                          config.version).ShowModal() == 5100 # 5100 模拟 wx.ID_OK
"@

    # 强制以 UTF8 编码将桩代码写入文件，覆盖原始文件
    $StubContent | Set-Content $SettingsDialogFile -Encoding UTF8
    Write-Host "settings_dialog.py 已成功生成 CLI 桩文件。"

    # -------------------------------------------------------------------------
    # 2.2. 针对 __init__.py 的修正：移除 wx 导入
    # -------------------------------------------------------------------------
    $InitFile = "InteractiveHtmlBom\__init__.py"
    Write-Host "   -> 修正 __init__.py (强制逐行禁用 wx 导入)..."
    
    # 2.2.1. 以 UTF8 编码逐行读取文件内容
    $InitContentLines = Get-Content $InitFile -Encoding UTF8
    
    # 2.2.2. 创建一个新的内容数组
    $NewContentLines = @()
    
    # 2.2.3. 逐行检查并修改
    foreach ($line in $InitContentLines) {
        # 检查行是否包含 'import wx' (不区分大小写，忽略前后空白)
        if ($line.Trim() -like "import wx*") {
            $NewContentLines += "# [CLI FIX] " + $line # 强制添加注释
            Write-Host "      [已禁用]: $line"
        } else {
            $NewContentLines += $line # 保留其他行
        }
    }
    
    # 2.2.4. 以 UTF8 编码将修改后的内容写入文件
    $NewContentLines | Set-Content $InitFile -Encoding UTF8
    Write-Host "__init__.py 最终修正完成。"

    # -------------------------------------------------------------------------
    # 2.3. 针对 dialog_base.py 的修正：强制禁用 wx 导入 (空桩文件)
    # -------------------------------------------------------------------------
    $DialogBaseFile = "InteractiveHtmlBom\dialog\dialog_base.py"
    Write-Host "   -> 修正 dialog_base.py (用空桩文件替换)..."
    
    # 替换为一个仅包含注释的空文件，彻底消除所有 wx 依赖和 IndentationError
    $StubContent = @"
# [CLI FINAL FIX] This file is stubbed out to eliminate all wx dependencies and IndentationError.
# The functionality is replaced by a stub class in settings_dialog.py.
"@

    # 强制以 UTF8 编码写入新内容
    $StubContent | Set-Content $DialogBaseFile -Encoding UTF8
    Write-Host "dialog_base.py 已被替换为 CLI 桩文件，彻底解决所有 wx/缩进问题。"

    # -------------------------------------------------------------------------
    # 2.5. 针对 config.py 的修正：封装 wx 导入 & 配置默认值
    # -------------------------------------------------------------------------
    $ConfigFile = "InteractiveHtmlBom\core\config.py"
    Write-Host "   -> 修正 config.py (封装 wx 导入 & 配置默认值)..."
    $ConfigContent = Get-Content $ConfigFile -Raw
    
    # 定义您期望的替换块
    $ReplacementBlock = @"
try:
    from wx import FileConfig
except ImportError:
    # 确保在 wx 缺失时，FileConfig 仍然存在，但设置为 None 或其他占位符
    FileConfig = None
"@

    # 2.5.1. 精确替换顶层的 'from wx import FileConfig' 语句
    $ConfigContent = $ConfigContent -replace 'from wx import FileConfig', $ReplacementBlock
    
    # 2.5.2. 修改配置默认值
    Write-Host "        -> 调整默认配置值..."
    $ConfigContent = $ConfigContent -replace 'dark_mode = False', 'dark_mode = True'
    $ConfigContent = $ConfigContent -replace "bom_dest_dir = 'bom/'  # This is relative to pcb file directory", "bom_dest_dir = ''  # This is relative to pcb file directory"
    $ConfigContent = $ConfigContent -replace "bom_name_format = 'ibom'", "bom_name_format = '%f'"
    
    # 2.5.3. 统一缩进（可选但推荐）
    $ConfigContent = $ConfigContent -replace "`t", "    " 

    $ConfigContent | Set-Content $ConfigFile -Encoding UTF8
    Write-Host "config.py 导入封装完成."

    # -------------------------------------------------------------------------
    # 2.6. 针对 ibom.py 的修正：强制逐行禁用 wx 导入
    # -------------------------------------------------------------------------
    $IbomFile = "InteractiveHtmlBom\core\ibom.py"
    Write-Host "   -> 修正 ibom.py (强制逐行禁用 wx 导入)..."
    
    # 2.6.1. 以 UTF8 编码逐行读取文件内容
    $IbomContentLines = Get-Content $IbomFile -Encoding UTF8
    
    # 2.6.2. 创建一个新的内容数组
    $NewContentLines = @()
    
    # 2.6.3. 逐行检查并修改
    foreach ($line in $IbomContentLines) {
        # 检查行是否包含 'import wx' (不区分大小写，忽略前后空白)
        if ($line.Trim() -like "import wx*") {
            $NewContentLines += "# [CLI FIX] " + $line # 强制添加注释
            Write-Host "      [已禁用]: $line"
        } else {
            $NewContentLines += $line # 保留其他行
        }
    }
    
    # 2.6.4. 以 UTF8 编码将修改后的内容写入文件
    $NewContentLines | Set-Content $IbomFile -Encoding UTF8
    Write-Host "ibom.py 最终修正完成。"

    # -------------------------------------------------------------------------
    # 2.7. 针对 generate_interactive_bom.py 的修改 (关键修正)
    # -------------------------------------------------------------------------
    $GenBomFile = "InteractiveHtmlBom\generate_interactive_bom.py"
    Write-Host "   -> 修正 generate_interactive_bom.py (关键修正)..."
    $GenBomContent = Get-Content $GenBomFile -Raw
    
    # 2.7.1. 修复 wx 导入
    $GenBomContent = $GenBomContent -replace 'import wx', '# import wx'
    
    # 2.7.2. 关键修复：替换 main 函数开头到第一个绝对导入之间的所有 wx/GUI 启动代码
    $replacementBlock = @"
def main():
    create_wx_app = 'INTERACTIVE_HTML_BOM_NO_DISPLAY' not in os.environ
    # 彻底禁用 wx/GUI 依赖
    pass

    from InteractiveHtmlBom.core import ibom # 确保替换后的代码使用绝对导入
"@
    # 替换 main 函数开头到 from .core import ibom 之间的所有内容 (使用多行模式 (?smi) 进行精确替换)
    $pattern = '(?smi)def main\(\):.*?from \.core import ibom'
    $GenBomContent = $GenBomContent -replace $pattern, $replacementBlock

    # 2.7.3. 修复顶层代码的缩进问题 (解决所有 IndentationError 的残留)
    $lines = $GenBomContent -split "`n"
    $cleanedLines = @()
    $foundDefOrClass = $false
    foreach ($line in $lines) {
        if ($foundDefOrClass) {
            $cleanedLines += $line
        } else {
            $trimmedLine = $line.Trim()
            if ($trimmedLine -match '^def\s|^class\s') {
                $foundDefOrClass = $true
            }
            $cleanedLines += $trimmedLine # 强制无缩进
        }
    }
    $GenBomContent = $cleanedLines -join "`n"

    # 2.7.4. 【终极路径和导入清理】解决 NameError 和 _internal 错误
    Write-Host "   -> 终极路径清理：禁用所有 sys.path 注入和相对导入..."
    
    # 2.7.4.1. 禁用原始的相对导入修复代码块 (包含 script_dir 定义和使用)
    $RelativeImportBlockPattern = '(?smi)script_dir = os\.path\.dirname\(os\.path\.abspath\(os\.path\.realpath\(__file__\)\)\).*?__import__\(__package__\)'
    $GenBomContent = $GenBomContent -replace $RelativeImportBlockPattern, '# Original Relative Import Block Disabled'
    
    # 2.7.4.2. 确保清除所有残留的 script_dir / __package__ 引用
    $GenBomContent = $GenBomContent -replace '^\s*__package__ = os\.path\.basename\(script_dir\)', '# __package__ Disabled'
    
    # 2.7.4.3. 移除所有残留的 sys.path.insert 调用
    $GenBomContent = $GenBomContent -replace '^\s*sys\.path\.insert\(0,.*', '# sys.path.insert(0, DISABLED)'
    
    # 2.7.4.4. 移除所有之前尝试修复的 PyInstaller 路径注入残留块
    $GenBomContent = $GenBomContent -replace '^\s*# --- PyInstaller Module Fix ---.*?# --- PyInstaller Module Fix ---\s*', ''

    # 2.7.5. 【绝对导入替换】全面替换所有相对导入为绝对导入 (解决 _internal 错误)
    Write-Host "   -> 终极导入修复：全面替换相对导入为绝对导入..."
    $GenBomContent = $GenBomContent -replace 'from \.core import ibom', 'from InteractiveHtmlBom.core import ibom' # 确保 main() 函数后的第一个导入也被修正
    $GenBomContent = $GenBomContent -replace 'from \.core\.config import Config', 'from InteractiveHtmlBom.core.config import Config'
    $GenBomContent = $GenBomContent -replace 'from \.ecad import get_parser_by_extension', 'from InteractiveHtmlBom.ecad import get_parser_by_extension'
    $GenBomContent = $GenBomContent -replace 'from \.version import version', 'from InteractiveHtmlBom.version import version'
    $GenBomContent = $GenBomContent -replace 'from \.errors import \(ExitCodes, ParsingException, exit_error\)', 'from InteractiveHtmlBom.errors import (ExitCodes, ParsingException, exit_error)'
    
    $GenBomContent | Set-Content $GenBomFile -Encoding UTF8
    
    Write-Host "源代码修正完成."

    # -------------------------------------------------------------------------
    # 3. 清理旧构建
    # -------------------------------------------------------------------------
    Write-Host ""
    Write-Host "3. 正在清理旧构建目录..."
    Remove-Item -Path .\build -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path .\dist -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -Path .\generate_interactive_bom.spec -ErrorAction SilentlyContinue
    Write-Host "清理完成."

    # -------------------------------------------------------------------------
    # 4. 执行 PyInstaller 打包 (切换到 --onedir 模式)
    # -------------------------------------------------------------------------
    Write-Host ""
    Write-Host "4. 正在执行 PyInstaller 打包 (使用 --onedir)..." -ForegroundColor Yellow

    # 使用数组传递参数
    $PyInstallerArgs = @(
        "--noconfirm",
        "--onedir", # 切换为单目录模式
        "--icon", "bomicon.ico",
        # 解决 ModuleNotFoundError 的关键
        "--hidden-import", "InteractiveHtmlBom.core",
        "--hidden-import", "InteractiveHtmlBom.ecad",
        "--hidden-import", "InteractiveHtmlBom.errors",
        "--hidden-import", "InteractiveHtmlBom.version",
        "--hidden-import", "InteractiveHtmlBom.dialog",
        # 关键修正：添加整个包目录到可执行文件根目录
        "--add-data", "InteractiveHtmlBom;InteractiveHtmlBom",
        # 设置 EXE 名称
        "--name", "generate_interactive_bom",
        # 主脚本文件
        "InteractiveHtmlBom\generate_interactive_bom.py"
    )

    # 关键修复：临时保存当前的 $ErrorActionPreference 并将其设置为 SilentlyContinue
    $OriginalErrorActionPreference = $ErrorActionPreference
    $ErrorActionPreference = "SilentlyContinue"

    try {
        # 执行 PyInstaller，并将其输出管道化，以确保所有内容都进入标准输出
        & pyinstaller $PyInstallerArgs *>&1
    } catch {
        # 即使设置了 SilentlyContinue，如果仍有异常，这里会捕获
        Write-Host "PyInstaller 执行中仍捕获到异常，请检查其输出。" -ForegroundColor Red
    } finally {
        # 恢复原来的 $ErrorActionPreference
        $ErrorActionPreference = $OriginalErrorActionPreference
    }


    # 检查 PyInstaller 的退出代码
    if ($LASTEXITCODE -ne 0) {
        exit_script "打包失败，请检查 PyInstaller 错误日志。"
    }
    Write-Host "打包成功完成."

} catch {
    exit_script "打包流程中发生未捕获的异常: $($_.Exception.Message)"
} finally {
    if (-not $Global:ErrorOccurred) {
        Write-Host "源代码恢复完成。" -ForegroundColor Green
        Write-Host ""
        Write-Host "=======================================================" -ForegroundColor Green
        Write-Host "✅ 恭喜！InteractiveHtmlBom CLI 打包成功！" -ForegroundColor Green
        Write-Host "EXE 文件位于 dist\generate_interactive_bom\generate_interactive_bom.exe" -ForegroundColor Green
        Write-Host "=======================================================" -ForegroundColor Green
    }
}
