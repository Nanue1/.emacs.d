;; init enable proxy
;;(toggle-env-http-proxy)



;; ag quick search word
(global-set-key (kbd "C-c s") 'helm-do-ag-project-root)

;; utf-8 支持中文
(set-language-environment "UTF-8")

;; iedit 批量修改
;(global-set-key (kbd "M-s e") 'iedit-mode)

;;快速选中
(global-set-key (kbd "C-;") 'er/expand-region)

;; occur 默认查找当前选中字段
;; (defun occur-dwim ()
;;   "Call occur with a sane default"
;;   (interactive)
;;   (push (if (region-active-p)
;;             (buffer-substring-no-properties
;;              (region-beginning)
;;              (regin-end))
;;           (let ((sym (thing-at-point 'symbol)))
;;             (when (stringp sym)
;;               (regexp-quote sym))))
;;         regexp-history)
;;   (call-interactively 'occur))
;; (global-set-key (kbd "M-s o" ) 'occur-dwim)


;; remove ^M
(defun remove-dos-eol ()
  "Replace Dos eolns CR LF with Unix eolns CR"
  (interactive)
  (goto-char (point-min))
  (while (search-forward "\r" nil t) (replace-match "")))

;;dird mode set
(fset 'yes-or-no-p 'y-or-n-p)
(setq dired-recursive-deletes 'alawys)
(setq dired-recursive-copies 'alawys)
;;复用buffer
(put 'dired-find-alternate-file 'disabled nil)
;;(require 'dired) ;; 定义dired-mode下的快捷键需要开启diredmode
(with-eval-after-load 'dired
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file))
(require 'dired-x) ;; c-x c-j 快速打开当前文件所在目录
(setq dired-dwim-target t) ;;打开两个dired 快速复制文件到另一个目录
(global-set-key (kbd "s-f") 'reveal-in-osx-finder) ;; mac 快速调用finder查看文件所在目录



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;补充company补全功能
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq hippie-expand-try-functions-list '(try-expand-dabbrev
                                         try-expand-all-abbrevs
                                         try-expand-dabbrev-from-kill
                                         try-complete-file-name
                                         try-complete-file-name-partially
                                         try-expand-dabbrev-all-buffers
                                         try-expand-list
                                         try-expand-line
                                         try-complete-lisp-symbol-partially
                                         try-complete-lisp-symbol))
;;(global-set-key (kbd "s-/") 'hippie-expand)
;;统一切换体验c-n c-p
(with-eval-after-load 'company
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous))

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
(abbrev-mode t)
(define-abbrev-table 'global-abbrev-table '(
                                            ;;manue1
                                            ("6m" "manue1")
                                            ;; Macrosoft
                                            ("8ms" "Macrosoft")
                                            ))

;;优化删除 cc-mode : c-<delete>
;;(require 'hungry-delete)
;;(global-hungry-delete-mode t)


;; close auto-save-list
(setq auto-save-default nil)

;;优化查看帮助信息窗口弹出 q & c-g exit
(require 'popwin)
(popwin-mode t)

;;快速学习emacs
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





;; c-x c-o 使用chrome访问url
(add-to-list 'exec-path "/opt/google/chrome")
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chrome")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;  设置emacs-w3m浏览器
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'exec-path "/home/manue1/opt/w3m/bin")
;; 默认显示图片
(setq w3m-default-display-inline-images t)
(setq w3m-default-toggle-inline-images t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; emms mpd config 使用前需要c-c m c 同步mpd服务器状态
;; mpc search any 天空 | mpc add 添加新的专辑
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq exec-path (append exec-path '("/usr/local/bin")))
(emms-default-players)
(setq emms-player-list '(emms-player-mpd))
(setq emms-player-mpd-server-name "localhost")
(setq emms-player-mpd-server-port "6600")
(setq emms-info-functions '(emms-info-mpd))
(setq emms-volume-change-function 'emms-volume-mpd-change)

;;;emms快捷键设置
(global-set-key (kbd "C-c e b") 'emms-smart-browse)
(global-set-key (kbd "C-c e c") 'emms-player-mpd-update-all-reset-cache)
(global-set-key (kbd "C-c e l") 'emms-playlist-mode-go)
(global-set-key (kbd "C-c e n") 'emms-next)
(global-set-key (kbd "C-c e p") 'emms-previous)
(global-set-key (kbd "C-c e P") 'emms-pause)
(global-set-key (kbd "C-c e r") 'emms-toggle-random-playlist)
(global-set-key (kbd "C-c e R") 'emms-toggle-repeat-playlist)
(global-set-key (kbd "C-=") 'emms-volume-mode-plus)
(global-set-key (kbd "C--") 'emms-volume-mode-minus)


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

