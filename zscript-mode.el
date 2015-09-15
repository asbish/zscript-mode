;;; zscript-mode.el --- ZScript for ZBrush editing mode

;; Copyright (C) 2014  asbi

;; Author: asbi <asbi@hobbyhorsemodels.com>
;; Version: 0.0.1

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; Put the following two lines to your "~/.emacs".
;; (require 'zscript-mode)
;; (define-key zscript-mode-map (kbd "C-c C-i") 'zscript-browse-command)
;;
;; If you hope to use the downloaded 'Zscript Command Reference' HTML file,
;; just add the following code.
;; (custom-set-variables
;;  '(zscript-command-reference-URL
;;    (browse-url-file-url "path/to/file.html")))


;;; TODO: Do something for <zscriptinsert>


;;; Code:

(require 'font-lock)
(require 'cl-lib)
(require 'browse-url)

(defconst zscript-mode-version "0.0.1"
  "ZScript mode version number.")

(defconst zscript-mode-modified "2014-11-03"
  "ZScript mode last modified date.")

(defgroup zscript nil
  "Major mode for ZScript."
  :group 'languages
  :prefix "zscript-")

(defcustom zscript-command-reference-URL
  "http://docs.pixologic.com/user-guide/customizing-zbrush/zscripting/command-reference"
  "The location of ZScript Ccommand Reference"
  :type 'string
  :set (lambda (var val) (set var val))
  :group 'zscript)

(defconst zscript-mode-keywords0
  '("Assert" "Delay" "Exit" "If" "IFreeze"
    "Loop" "LoopContinue" "LoopExit"
    "RoutineCall" "RoutineDef" "Sleep" "SleepAgain"
    "VarDef" "MVarDef"
    ))

(defconst zscript-mode-builtin-words1
  '("AND" "OR" "NOT" "BOOL" "INT" "FRAC" "ABS" "NEG"
    "MIN" "MAX" "SQRT" "RAND" "IRAND"
    "SIN" "COS" "TAN" "ASIN" "ACOS" "ATAN" "ATAN2" "LOG" "LOG10"
    ))

(defconst zscript-mode-builtin-words0
  '(;;"<zscriptinsert>"
    "Assert"
    "BackColorSet"
    "ButtonFind"
    "ButtonPress"
    "ButtonSet"
    "ButtonUnPress"
    "CanvasClick"
    "CanvasGyroHide"
    "CanvasGyroShow"
    "CanvasPanGetH"
    "CanvasPanGetV"
    "CanvasPanSet"
    "CanvasStroke"
    "CanvasStrokes"
    "CanvasZoomGet"
    "CanvasZoomSet"
    "Caption"
    "CurveAddPoint"
    "CurvesCreateMesh"
    "CurvesDelete"
    "CurvesNew"
    "CurvesNewCurve"
    "CurvesToUI"
    "Delay"
    "DispMapCreate"
    "Exit"
    "FileDelete"
    "FileExecute"
    "FileExists"
    "FileGetInfo"
    "FileNameAdvance"
    "FileNameAsk"
    "FileNameExtract"
    "FileNameGetLastTyped"
    "FileNameGetLastUsed"
    "FileNameMake"
    "FileNameResolvePath"
    "FileNameSetNext"
    "FontSetColor"
    "FontSetOpacity"
    "FontSetSize"
    "FontSetSizeLarge"
    "FontSetSizeMedium"
    "FontSetSizeSmall"
    "FrontColorSet"
    "GetActiveToolPath"
    "HotKeyText"
    "IButton"
    "IClick"
    "IClose"
    "IColorSet"
    "IConfig"
    "IDialog"
    "IDisable"
    "IEnable"
    "IExists"
    "If"
    "IFadeIn"
    "IFadeOut"
    "IFreeze"
    "IGet"
    "IGetFlags"
    "IGetHotkey"
    "IGetID"
    "IGetInfo"
    "IGetMax"
    "IGetMin"
    "IGetSecondary"
    "IGetStatus"
    "IGetTitle"
    "IHeight"
    "IHide"
    "IHPos"
    "IKeyPress"
    "ILock"
    "Image"
    "IMaximize"
    "IMinimize"
    "IModGet"
    "IModSet"
    "Interpolate"
    "IPress"
    "IReset"
    "IsDisabled"
    "IsEnabled"
    "ISet"
    "ISetHotkey"
    "ISetMax"
    "ISetMin"
    "ISetStatus"
    "IShow"
    "IShowActions"
    "ISlider"
    "IsLocked"
    "IStroke"
    "ISubPalette"
    "IsUnlocked"
    "ISwitch"
    "IToggle"
    "IUnlock"
    "IUnPress"
    "IUpdate"
    "IVPos"
    "IWidth"
    "Logical Operators"
    "Loop"
    "LoopContinue"
    "LoopExit"
    "Math Functions"
    "Math Operators"
    "MemCopy"
    "MemCreate"
    "MemCreateFromFile"
    "MemDelete"
    "MemGetSize"
    "MemMove"
    "MemMultiWrite"
    "MemRead"
    "MemReadString"
    "MemResize"
    "MemSaveToFile"
    "MemWrite"
    "MemWriteString"
    "Mesh3DGet"
    "MessageOK"
    "MessageOKCancel"
    "MessageYesNo"
    "MessageYesNoCancel"
    "MouseHPos"
    "MouseLButton"
    "MouseVPos"
    "MTransformGet"
    "MTransformSet"
    "MVarDef"
    "MVarGet"
    "MVarSet"
    "NormalMapCreate"
    "Note"
    "NoteBar"
    "NoteIButton"
    "NoteIGet"
    "NoteISwitch"
    "PageSetWidth"
    "PaintBackground"
    "PaintBackSliver"
    "PaintPageBreak"
    "PaintRect"
    "PaintTextRect"
    "PD"
    "PenMove"
    "PenMoveCenter"
    "PenMoveDown"
    "PenMoveLeft"
    "PenMoveRight"
    "PenSetColor"
    "PixolPick"
    "PropertySet"
    "Randomize"
    "RGB"
    "RoutineCall"
    "RoutineDef"
    "SectionBegin"
    "SectionEnd"
    "ShellExecute"
    "Sleep"
    "SleepAgain"
    "SoundPlay"
    "SoundStop"
    "StrAsk"
    "StrExtract"
    "StrFind"
    "StrFromAsc"
    "StrLength"
    "StrLower"
    "StrMerge"
    "StrokeGetInfo"
    "StrokeGetLast"
    "StrokeLoad"
    "StrokesLoad"
    "StrToAsc"
    "StrUpper"
    "SubTitle"
    "SubToolGetActiveIndex"
    "SubToolGetCount"
    "SubToolGetID"
    "SubToolLocate"
    "SubToolSelect"
    "TextCalcWidth"
    "Title"
    "ToolGetActiveIndex"
    "ToolGetCount"
    "ToolGetPath"
    "ToolGetSubToolID"
    "ToolGetSubToolsCount"
    "ToolLocateSubTool"
    "ToolSelect"
    "ToolSetPath"
    "TransformGet"
    "TransformSet"
    "TransposeGet"
    "TransposeIsShown"
    "TransposeSet"
    "Val"
    "Var"
    "VarAdd"
    "VarDec"
    "VarDef"
    "VarDiv"
    "VarInc"
    "VarListCopy"
    "VarLoad"
    "VarMul"
    "VarSave"
    "VarSet"
    "VarSize"
    "VarSub"
    "ZBrushInfo"
    "ZBrushPriorityGet"
    "ZBrushPrioritySet"
    "ZSphereAdd"
    "ZSphereDel"
    "ZSphereEdit"
    "ZSphereGet"
    "ZSphereSet"
    ))  ; end of zscript-mode-builtin-words0

(defvar zscript-mode-builtin-words
  (cl-set-difference
   (append zscript-mode-builtin-words0 zscript-mode-builtin-words1)
   zscript-mode-keywords0
   :test #'equal))

(defvar zscript-mode-font-lock
  `((,(concat "\\<" `,(regexp-opt zscript-mode-keywords0 'word) "\\>")
     . font-lock-keyword-face)
    (,(concat "\\<" `,(regexp-opt zscript-mode-builtin-words 'word) "\\>")
     . font-lock-builtin-face)
    ("\\<RoutineDef\\s-*,\\s-*\\(\\sw+\\)\\s-*,?"
     (1 font-lock-function-name-face))
    ("\\<\\(VarDef\\|MVarDef\\)\\s-*,\\s-*\\(\\sw+_?\\sW*\\)\\s-*,?"
     (2 font-lock-variable-name-face))
    ("\\<\\(\\sw+:\\)\\sw*\\s-*,?"
     (1 font-lock-type-face))
    ))

;; Use fundamental-mode
;;(defvar zscript-mode-syntax-table nil)

(define-derived-mode zscript-mode fundamental-mode
  "ZScript for ZBrush editing mode"
  ;; Code for syntax highlighting.
  (setq font-lock-defaults '(zscript-mode-font-lock))

  (setq mode-name "ZScript")

  ;; Modify from fundamental-mode
  (setq comment-start "/")
  (setq comment-end "")
  (modify-syntax-entry ?\/ ". 124b" zscript-mode-syntax-table)
  (modify-syntax-entry ?* ". 23" zscript-mode-syntax-table)
  (modify-syntax-entry ?\n "> b" zscript-mode-syntax-table)
  )


(defvar zscript-mode-command-regexp
  (concat "^" (regexp-opt zscript-mode-builtin-words0) "$"))

(defun zscript-browse-command ()
  (interactive)
  (let ((cname (zscript-mode-get-and-format-command-name)))
    (if (and (string-match "^[a-zA-Z3]+$" cname)
             (string-match zscript-mode-command-regexp cname))
        (progn
          (when case-fold-search
            (setq cname
                  (car (cl-member (concat "^" cname "$")
                                  zscript-mode-builtin-words0
                                  :test #'string-match))))
          (browse-url (concat zscript-command-reference-URL "/#" cname)))
      (message (format "Not found \"%s\"" cname)))))

(defun zscript-mode-get-and-format-command-name ()
  (replace-regexp-in-string
   "^\\s-+\\|\\s-+$"
   ""
   (read-string "Browse command: "
                (zscript-mode-get-command-word-point)
                nil "")))

(defun zscript-mode-get-command-word-point ()
  (save-excursion
    (skip-chars-backward " \t")
    (let ((beg (progn (skip-syntax-backward "w") (point)))
          (end (progn (skip-syntax-forward "w") (point))))
      (format "%s" (buffer-substring-no-properties beg end)))))

(provide 'zscript-mode)
;;; zscript-mode.el ends here
