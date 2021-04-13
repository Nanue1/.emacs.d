(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)
   (C . t)
   (go . t)
   (java . t)
   (emacs-lisp . t)
   (shell . t)))


;; 主题配置需要
(when (or (display-graphic-p)
          (string-match-p "256color"(getenv "TERM")))
  (load-theme 'doom-one t))

;; init enable proxy
;;(toggle-env-http-proxy)


;; utf-8 支持中文
(set-language-environment "UTF-8")

;; remove ^M
(defun remove-dos-eol ()
  "Replace Dos eolns CR LF with Unix eolns CR"
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match "")))

;;dird mode set
;; (fset 'yes-or-no-p 'y-or-n-p)
;; (setq dired-recursive-deletes 'alawys)
;; (setq dired-recursive-copies 'alawys)
;;复用 buffer
;; (put 'dired-find-alternate-file 'disabled nil)
;; (require 'dired) ;; 定义 dired-mode 下的快捷键需要开启 diredmode
;; (with-eval-after-load 'dired
;;   (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))
(require 'dired-x) ;; c-x c-j 快速打开当前文件所在目录
;; (setq dired-dwim-target t) ;;打开两个 dired 快速复制文件到另一个目录
(global-set-key (kbd "s-f") 'reveal-in-osx-finder) ;; mac 快速调用 finder 查看文件所在目录



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;补充 company 补全功能
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (setq hippie-expand-try-functions-list '(try-expand-dabbrev
;;                                          try-expand-all-abbrevs
;;                                          try-expand-dabbrev-from-kill
;;                                          try-complete-file-name
;;                                          try-complete-file-name-partially
;;                                          try-expand-dabbrev-all-buffers
;;                                          try-expand-list
;;                                          try-expand-line
;;                                          try-complete-lisp-symbol-partially
;;                                          try-complete-lisp-symbol))
;; (global-set-key (kbd "s-/") 'hippie-expand)

;;统一切换体验 c-n c-p
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))


;; (ac-config-default);; 全局开启了 ac
;; (setq ac-ignore-case t);; 联想忽略大小写
;; (setq ac-use-menu-map t);; 上下选择联想项的快捷键
;; (define-key ac-menu-map "\C-n" 'ac-next)
;; (define-key ac-menu-map "\C-p" 'ac-previous)

;;格式化缩进
(defun indent-buffer ()
  "Indent the currently visited buffer"
  (interactive)
  (indent-region (point-min) (point-max)))
(defun indent-region-or-buffer ()
  "Indent a region if selected , otherwise the whose buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
        (progn
          (indent-region (region-beginning) (region-end))
          (message "Indent selected region."))
      (progn
        (indent-buffer)
        (message "Indent buffer.")))))
(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer)


;; close warn sound
(setq ring-bell-function 'ignore)

;;定义缩写  space + esc
;; (abbrev-mode t)
;; (define-abbrev-table 'global-abbrev-table '(
;;                                             ;;manue1
;;                                             ("6m" "manue1")
;;                                             ;; Macrosoft
;;                                             ("8ms" "Macrosoft")
;;                                             ))

;;优化删除 cc-mode : c-<delete>
;;(require 'hungry-delete)
;;(global-hungry-delete-mode t)


;; close auto-save-list
(setq auto-save-default nil)

;;优化查看帮助信息窗口弹出 q & c-g exit
;; (require 'popwin)
;; (popwin-mode t)

;;快速学习 emacs
(global-set-key (kbd "C-h C-f") 'find-function)
(global-set-key (kbd "C-h C-v") 'find-variable)
(global-set-key (kbd "C-h C-k") 'find-function-on-key)

;;快速打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/github/.emacs.d/custom.el")
  )
(global-set-key (kbd "<f1>") 'open-init-file)

;; 最近使用文件
(recentf-mode 1)
(setq recentf-max-menu-items 25)


;; c-x c-o 使用 chrome 访问 url
;; (setq browse-url-browser-function 'browse-url-default-macosx-browser)
;; (add-to-list 'exec-path "/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome")
;; (setq browse-url-browser-function 'browse-url-generic
;;       browse-url-generic-program "chrome")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  设置 emacs-w3m 浏览器
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'exec-path "/home/manue1/opt/w3m/bin")
;; 默认显示图片
(setq w3m-default-display-inline-images t)
(setq w3m-default-toggle-inline-images t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; emms mpd config 使用前需要 c-c m c 同步 mpd 服务器状态
;; mpc search any 天空 | mpc add 添加新的专辑
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq exec-path (append exec-path '("/usr/local/bin")))
(emms-all)
(setq emms-player-list '(emms-player-mpd))
(add-to-list 'emms-player-list 'emms-player-mpv)
(setq emms-player-mpd-server-name "localhost")
(setq emms-player-mpd-server-port "6600")
(setq emms-player-mpd-music-directory "~/Music")
(setq emms-info-functions '(emms-info-mpd))
(setq emms-volume-change-function 'emms-volume-mpd-change)

(defun mpd/start-music-daemon ()
  "Start MPD, connects to it and syncs the metadata cache."
  (interactive)
  (shell-command "mpd")
  (mpd/update-database)
  (emms-player-mpd-connect)
  (emms-cache-set-from-mpd-all)
  (message "MPD Started!"))
(global-set-key (kbd "C-c m c") 'mpd/start-music-daemon)
(defun mpd/kill-music-daemon ()
  "Stops playback and kill the music daemon."
  (interactive)
  (emms-stop)
  (call-process "killall" nil nil nil "mpd")
  (message "MPD Killed!"))
(global-set-key (kbd "C-c m k") 'mpd/kill-music-daemon)
(defun mpd/update-database ()
  "Updates the MPD database synchronously."
  (interactive)
  (call-process "mpc" nil nil nil "update")
  (message "MPD Database Updated!"))
(global-set-key (kbd "C-c m u") 'mpd/update-database)

;; edit src
(global-set-key (kbd "C-c '") 'org-edit-src-code)

;; 默认 c-u 不能向上翻半页
(define-key evil-normal-state-map (kbd "C-u") 'evil-scroll-up)

;; 开启 org-mode <s 功能
;; (require 'org-tempo)

;; 关闭左右括号自动补全
;; (electric-pair-mode -1)



(require 'ox-md)

;; 1. xelatex install for macos
;; 2. org file head set:
;; #+LATEX_HEADER: \usepackage{fontspec}
;; #+LATEX_HEADER: \setmainfont{PingFang SC}
;; (setq org-latex-pdf-process '("xelatex -interaction nonstopmode %f"
;;                               "xelatex -interaction nonstopmode %f"))


;; 美化 org mode 层级
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(setq valign-mode t)


(setq org-image-actual-width 300)


;; 中英文间添加空白符
(global-pangu-spacing-mode 1)
(setq pangu-spacing-real-insert-separtor t)


(setq debug-on-error t)


;; (require 'org-wiki)
;; (setq org-wiki-location-list
;;       '(
;;         "~/github/org-wiki/note"
;;         "~/github/org-wiki/golang"
;;         "~/github/org-wiki/k8s"
;;         "~/github/caiorss/org-wiki/sandbox/wiki"
;;         ))
;; (setq org-wiki-location (car org-wiki-location-list))

;; mermaid-mod
(setq mermaid-mmdc-location "/usr/local/bin/mmdc")
(setq mermaid-output-format  "/Users/manue1/github/org-pages/images/mermaid")
