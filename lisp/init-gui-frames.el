;; -*- coding: utf-8; lexical-binding: t; -*-

;; Suppress GUI features
(setq use-file-dialog nil)
(setq use-dialog-box nil)
(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)

;; Show a marker in the left fringe for lines not in the buffer
(setq indicate-empty-lines t)

;; NO tool bar
(if (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
;; no scroll bar
(if (fboundp 'set-scroll-bar-mode)
  (set-scroll-bar-mode nil))
;; no menu bar
(if (fboundp 'menu-bar-mode)
  (menu-bar-mode -1))

;;高亮显示当前行
(global-hl-line-mode t)

;; 最大化
;;(setq initial-frame-alist (quote ((fullscreen . maximized))))
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;;鼠标选中后高亮括号
(show-paren-mode 1)

(provide 'init-gui-frames)
