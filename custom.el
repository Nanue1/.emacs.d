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
(global-set-key (kbd "C-x C-r" ) 'recentf-open-files)

;; org mode 个人配置
(setq org-agenda-files (quote ("~/github/org-pages/q&a.org")))
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-capture-templates
       '(
         ("r" "Read" entry (file+olp"~/github/org-pages/read.org" "Reading List")
          "* TODO %^{book:} %t\n%i\n"
          :clock-in t
          :clock-resume t
          :prepend t)
         ("w" "Write" entry (file+headline "~/github/org-pages/write.org" "Writing List")
          "* TODO  %?\n  %i\n"
          :prepend )
         ("c" "Code" entry (file+headline "~/github/org-pages/code.org" "Coding List")
          "* TODO %?\n  %i\n"
          :prepend t)
         ("a" "Q&A" entry (file+headline "~/github/org-pages/q&a.org" "Question & Answer")
          "* TODO %?\n  %i\n"
          :prepend t)
         ("b" "Body" entry (file+headline "~/github/org-pages/body.org" "Body Building")
          "* TODO %?\n  %i\n"
          :prepend t)
         ("h" "Habit" entry (file "~/github/org-pages/habit.org")
          "* NEXT %?\nSCHEDULED: <%<%Y-%m-%d %a .+1d>>\n:PROPETIES:\n:CREATED: %U\n:STYLE: habit\n:REPEAT_TO_STATE: NEXT\n:LOGGING: DONE(!)\n:ARCHIVE: %%s_archive::* Habits\n:END:\n%U\n")
         )
)
 ;; (defun capture-report-date-file (path)
 ;;   (interactive
 ;;        (setq name (read-string "Name:" nil))
 ;;        (expend-find-name(format "%s-%s.org" (format-time-string "%Y-%m-%d") name) path))
 ;;    )

 ;; (add-to-list 'org-capture-templates
 ;;              `("n" "note" plain (file,(capture-report-data-file "~/github/org-pages/note/"))
 ;;               ,(concat "#+startup: showall\n"
 ;;                         "#+options: toc:nil\n"
 ;;                         "#+begin_export html\n"
 ;;                         "---\n"
 ;;                         "layout     : post\n"
 ;;                         "title      : %^{标题}\n"
 ;;                         "categories : %^{类别}\n"
 ;;                         "tags       : %^{标签}\n"
 ;;                         "---\n"
 ;;                         "+end_export\n"
 ;;                         "#+TOC: headlines 2\n")))
                                        ; Task state settings
(setq org-todo-keywords '((sequence "TODO(t!)" "SOMEDAY(s)" "|" "DONE(d@/!)" "UNDO(u@/!)" "ABORT(a@/!)")))


;; blog
(setq org-export-with-section-numbers nil) ;this set the section with no number
(setq org-html-validation-link nil) ;makes no validation below.
(setq org-export-copy-to-kill-ring nil)
(setq org-export-with-sub-superscripts nil)
(setq org-html-postamble nil)

(setq org-publish-project-alist
       '(
         ("org-html"
          :base-directory "~/github/org-pages"
          :base-extension "org"
          :publishing-directory "~/github/html-pages"
          :section-numbers nil
          :recursive t
          :publishing-function org-html-publish-to-html
          :headline-levels 4
          :auto-sitemap t
          :sitemap-filename "sitemap.org"
          :sitemap-title "Sitemap"
          :auto-preamble t
          :author nil
          :creator-info nil
          :auto-postamble nil)
         ("org-static"
          :base-directory "~/github/org-pages"
          :base-extension "html\\|css\\|js\\|ico\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|ogg\\|swf\\|java\\|py\\|zip\\|arff\\|dat\\|cpp\\|xls\\|otf\\|woff"
          :publishing-directory "~/github/html-pages"
          :recursive t
          :publishing-function org-publish-attachment)
         ("org-pages" :components ("org-html" "org-static"))
         ))

;; TODO
(setq org-html-preamble "<a href=\"https://www.manue1.site/index.html\">Home</a>")

;; 等宽
;(set-face-attribute 'org-table nil :family "")

;; Org table font
(custom-set-faces
 '(org-table ((t (:family "Ubuntu Mono derivative Powerline")))))


;;emacs orgmode 默认开启图片显示
(setq org-toggle-inline-images t)
(setq org-image-actual-width 300)


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
;; 设置w3m主页
(setq w3m-home-page "http://www.baidu.com")
;; 默认显示图片
(setq w3m-default-display-inline-images t)
(setq w3m-default-toggle-inline-images t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; emms mpd config
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq exec-path (append exec-path '("/usr/local/bin")))
(emms-default-players)
(setq emms-player-list '(emms-player-mpd))
(setq emms-player-mpd-server-name "localhost")
(setq emms-player-mpd-server-port "6600")
(setq emms-info-functions '(emms-info-mpd))
(setq emms-volume-change-function 'emms-volume--change)
;;;emms快捷键设置
(global-set-key (kbd "C-c e b") 'emms-smart-browse)
(global-set-key (kbd "C-c e c") 'emms-player-mpd-update-all-reset-cache)
(global-set-key (kbd "C-c e l") 'emms-playlist-mode-go)
(global-set-key (kbd "C-c e n") 'emms-next)
(global-set-key (kbd "C-c e p") 'emms-previous)
(global-set-key (kbd "C-c e P") 'emms-pause)

(global-set-key (kbd "C-c e r")   'emms-toggle-repeat-track)
(global-set-key (kbd "C-c e R")   'emms-toggle-repeat-playlist)


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
