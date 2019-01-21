(require 'erc)
(require 'erc-log)
(require 'erc-notify)
(require 'erc-spelling)
(require 'erc-autoaway)
(require 'tls)
;; https://github.com/bbatsov/emacs-dev-kit/blob/master/erc-config.el

;; utf-8 always and forever
(setq erc-server-coding-system '(utf-8 . utf-8))
;; Interpret mIRC-style color commands in IRC chats
(setq erc-interpret-mirc-color t)
;; Kill buffers for channels after /part
(setq erc-kill-buffer-on-part t)
;; Kill buffers for private queries after quitting the server
(setq erc-kill-queries-on-quit t)
;; Kill buffers for server messages after quitting the server
(setq erc-kill-server-buffer-on-quit t)
;; exclude boring stuff from tracking
(erc-track-mode t)


(defun read-lines (filePath)
  "Return a list of lines of a file at filePath."
  (with-temp-buffer (insert-file-contents filePath)
                    (split-string (buffer-string) "\n" t)))
;; ~/.irc-account insert
;;username
;;\n
;;password
(defun start-irc ()
  (interactive)
  (when (y-or-n-p "Do you want to start IRC? ")
    (let* ((acc (read-lines "~/.irc-account"))
           (irc-nick (car acc))
           (irc-password (nth 1 acc))
           (tls-program '("gnutls-cli --insecure -p %p %h" "gnutls-cli --insecure -p %p %h --protocols ssl3" "openssl s_client -connect %h:%p -no_ssl2 -ign_eof")))
      (erc-tls :server "irc.freenode.net"
               :port 6697
               :nick irc-nick
               :password irc-password))))
;; (defun filter-server-buffers ()
;;   (delq nil
;;         (mapcar
;;          (lambda (x) (and (erc-server-buffer-p x) x))
;;          (buffer-list))))

(defun filter-server-buffers ()
  (delq nil
        (mapcar
         (lambda (x) (and (erc-server-buffer-p x) x))
         (buffer-list))))

(defun stop-irc ()
  (interactive)
  (dolist (buffer (filter-server-buffers))
    (message "Server buffer: %s" (buffer-name buffer))
    (with-current-buffer buffer
      (erc-quit-server "zzZZ"))))


;; http://emacser.com/erc.htm
;;自动进入
(erc-autojoin-mode 1)
(setq erc-autojoin-channels-alist
      '(("freenode.net"
         "#debian-zh"
         "#python"
         "#emacs"
         "#emacs-cn")))

;; 用户别名
(setq erc-nick "manue1"
      erc-user-full-name "nanue1")

;; 忽略消息
(setq erc-ignore-list nil)
(setq erc-hide-list
      '("JOIN" "PART" "QUIT" "MODE"))
;;高亮
(erc-match-mode 1)
(setq erc-keywords '("emms" "python"))
(setq erc-pals '("rms"))

;; 消息提醒


;; (defun xwl-erc-text-matched-hook (match-type nickuserhost message)
;;   "Shows a growl notification, when user's nick was mentioned.
;;      If the buffer is currently not visible, makes it sticky."
;;   (when (and (erc-match-current-nick-p nickuserhost message)
;;              (not (string-match (regexp-opt '("Users"
;;                                               "User"
;;                                               "topic set by"
;;                                               "Welcome to "
;;                                               "nickname"
;;                                               "identified"
;;                                               "invalid"
;;                                               ))
;;                                 message)))
;;     (let ((s (concat "ERC: " (buffer-name (current-buffer)))))
;;       (case system-type
;;         ((darwin)
;;          (xwl-growl s message))))))
;; (add-hook 'erc-text-matched-hook 'xwl-erc-text-matched-hook)
;; (defun xwl-growl (title message)
;;   (start-process "growl" " growl" growlnotify-command title "-a" "Emacs")
;;   (process-send-string " growl" message)
;;   (process-send-string " growl" "\n")
;;   (process-send-eof " growl"))

;;;;;;
;; (defvar growlnotify-command (executable-find "growlnotify") "/usr/local/bin/growlnotify")

;; (defun growl (title message)
;;   "Shows a message through the growl notification system using
;;  `growlnotify-command` as the program."
;;   (cl-flet ((encfn (s) (encode-coding-string s (keyboard-coding-system))) )
;;     (let* ((process (start-process "growlnotify" nil
;;                                    growlnotify-command
;;                                    (encfn title)
;;                                    "-a" "Emacs"
;;                                    "-n" "Emacs")))
;;       (process-send-string process (encfn message))
;;       (process-send-string process "\n")
;;       (process-send-eof process)))
;;   t)

;; (defun my-erc-hook (match-type nick message)
;;   "Shows a growl notification, when user's nick was mentioned. If the buffer is currently not visible, makes it sticky."
;;   (unless (posix-string-match "^\\** *Users on #" message)
;;     (growl
;;      (concat "ERC: name mentioned on: " (buffer-name (current-buffer)))
;;      message
;;      )))

;; (add-hook 'erc-text-matched-hook 'my-erc-hook)


;; 时间戳左侧显示
(erc-timestamp-mode 1)
(setq erc-insert-timestamp-function 'erc-insert-timestamp-left)

;; logging
(erc-log-mode 1)
(setq erc-log-channels-directory "~/var/erc/"
      erc-save-buffer-on-part t
      erc-log-file-coding-system 'utf-8
      erc-log-write-after-send t
      erc-log-write-after-insert t)
(unless (file-exists-p erc-log-channels-directory)
  (mkdir erc-log-channels-directory t))

(provide 'init-erc)