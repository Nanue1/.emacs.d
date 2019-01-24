;; -*- coding: utf-8; lexical-binding: t; -*-

;; some cool org tricks
;; @see http://emacs.stackexchange.com/questions/13820/inline-verbatim-and-code-with-quotes-in-org-mode

;; {{ NO spell check for embedded snippets

(defun org-mode-is-code-snippet ()
  (let* (rlt
         (begin-regexp "^[ \t]*#\\+begin_\\(src\\|html\\|latex\\|example\\)")
         (end-regexp "^[ \t]*#\\+end_\\(src\\|html\\|latex\\|example\\)")
         (case-fold-search t)
         b e)
    (save-excursion
      (if (setq b (re-search-backward begin-regexp nil t))
          (setq e (re-search-forward end-regexp nil t))))
    (if (and b e (< (point) e)) (setq rlt t))
    rlt))

;; no spell check for property
(defun org-mode-current-line-is-property ()
  (string-match-p "^[ \t]+:[A-Z]+:[ \t]+" (my-line-str)))

;; Please note flyspell only use ispell-word
(defadvice org-mode-flyspell-verify (after org-mode-flyspell-verify-hack activate)
  (let* ((run-spellcheck ad-return-value))
    (if ad-return-value
      (cond
       ((org-mode-is-code-snippet)
        (setq run-spellcheck nil))
       ((org-mode-current-line-is-property)
        (setq run-spellcheck nil))))
    (setq ad-return-value run-spellcheck)))
;; }}

;; Org v8 change log:
;; @see http://orgmode.org/worg/org-8.0.html

;; {{ export org-mode in Chinese into PDF
;; @see http://freizl.github.io/posts/tech/2012-04-06-export-orgmode-file-in-Chinese.html
;; and you need install texlive-xetex on different platforms
;; To install texlive-xetex:
;;    `sudo USE="cjk" emerge texlive-xetex` on Gentoo Linux
(setq org-latex-to-pdf-process ;; org v7
      '("xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"
        "xelatex -interaction nonstopmode -output-directory %o %f"))
(setq org-latex-pdf-process org-latex-to-pdf-process) ;; org v8
;; }}

(defun my-setup-odt-org-convert-process ()
  (interactive)
  (let* ((cmd "/Applications/LibreOffice.app/Contents/MacOS/soffice"))
    (when (and *is-a-mac* (file-exists-p cmd))
      ;; org v7
      (setq org-export-odt-convert-processes '(("LibreOffice" "/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to %f%x --outdir %d %i")))
      ;; org v8
      (setq org-odt-convert-processes '(("LibreOffice" "/Applications/LibreOffice.app/Contents/MacOS/soffice --headless --convert-to %f%x --outdir %d %i"))))
    ))

(my-setup-odt-org-convert-process)

(defun narrow-to-region-indirect-buffer-maybe (start end use-indirect-buffer)
  "Indirect buffer could multiple widen on same file."
  (if (region-active-p) (deactivate-mark))
  (if use-indirect-buffer
      (with-current-buffer (clone-indirect-buffer
                            (generate-new-buffer-name
                             (concat (buffer-name) "-indirect-"
                                     (number-to-string start) "-"
                                     (number-to-string end)))
                            'display)
        (narrow-to-region start end)
        (goto-char (point-min)))
      (narrow-to-region start end)))

;; @see https://gist.github.com/mwfogleman/95cc60c87a9323876c6c
(defun narrow-or-widen-dwim (&optional use-indirect-buffer)
  "If the buffer is narrowed, it widens.
 Otherwise, it narrows to region, or Org subtree.
If use-indirect-buffer is not nil, use `indirect-buffer' to hold the widen content."
  (interactive "P")
  (cond ((buffer-narrowed-p) (widen))
        ((region-active-p)
         (narrow-to-region-indirect-buffer-maybe (region-beginning)
                                                 (region-end)
                                                 use-indirect-buffer))
        ((equal major-mode 'org-mode)
         (org-narrow-to-subtree))
        ((derived-mode-p 'diff-mode)
         (let* (b e)
           (save-excursion
             ;; If the (point) is already beginning or end of file diff,
             ;; the `diff-beginning-of-file' and `diff-end-of-file' return nil
             (setq b (progn (diff-beginning-of-file) (point)))
             (setq e (progn (diff-end-of-file) (point))))
           (when (and b e (< b e))
             (narrow-to-region-indirect-buffer-maybe b e use-indirect-buffer))))
        ((derived-mode-p 'prog-mode)
         (mark-defun)
         (narrow-to-region-indirect-buffer-maybe (region-beginning)
                                                 (region-end)
                                                 use-indirect-buffer))
        (t (error "Please select a region to narrow to"))))

;; Various preferences
(setq org-log-done t
      org-completion-use-ido t
      org-edit-src-content-indentation 0
      org-edit-timestamp-down-means-later t
      org-agenda-start-on-weekday nil
      org-agenda-span 14
      org-agenda-include-diary t
      org-agenda-window-setup 'current-window
      org-fast-tag-selection-single-key 'expert
      org-export-kill-product-buffer-when-displayed t
      ;; org v7
      org-export-odt-preferred-output-format "doc"
      ;; org v8
      org-odt-preferred-output-format "doc"
      org-tags-column 80
      ;; org-startup-indented t
      ;; {{ org 8.2.6 has some performance issue. Here is the workaround.
      ;; @see http://punchagan.muse-amuse.in/posts/how-i-learnt-to-use-emacs-profiler.html
      org-agenda-inhibit-startup t ;; ~50x speedup
      org-agenda-use-tag-inheritance nil ;; 3-4x speedup
      ;; }}
      )

;; Refile targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets '((nil :maxlevel . 5) (org-agenda-files :maxlevel . 5)))
(setq org-refile-use-outline-path 'file)
(setq org-outline-path-complete-in-steps nil)
(defadvice org-refile (around org-refile-hack activate)
  ;; when `org-refile' scanning org files, disable user's org-mode hooks
  (let* ((force-buffer-file-temp-p t))
    ad-do-it))


(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "STARTED(s)" "|" "DONE(d!/!)")
              (sequence "WAITING(w@/!)" "SOMEDAY(S)" "PROJECT(P@)" "|" "CANCELLED(c@/!)"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org clock
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Change task state to STARTED when clocking in
(setq org-clock-in-switch-to-state "STARTED")
;; Save clock data and notes in the LOGBOOK drawer
(setq org-clock-into-drawer t)
;; Removes clocked tasks with 0:00 duration
(setq org-clock-out-remove-zero-time-clocks t)

;; Show the clocked-in task - if any - in the header line
(defun sanityinc/show-org-clock-in-header-line ()
  (setq-default header-line-format '((" " org-mode-line-string " "))))

(defun sanityinc/hide-org-clock-from-header-line ()
  (setq-default header-line-format nil))

(add-hook 'org-clock-in-hook 'sanityinc/show-org-clock-in-header-line)
(add-hook 'org-clock-out-hook 'sanityinc/hide-org-clock-from-header-line)
(add-hook 'org-clock-cancel-hook 'sanityinc/hide-org-clock-from-header-line)

(eval-after-load 'org-clock
  '(progn
     (define-key org-clock-mode-line-map [header-line mouse-2] 'org-clock-goto)
     (define-key org-clock-mode-line-map [header-line mouse-1] 'org-clock-menu)))

(eval-after-load 'org
  '(progn
     (setq org-imenu-depth 9)
     (require 'org-clock)
     ;; @see http://irreal.org/blog/1
     (setq org-src-fontify-natively t)))

(defun org-mode-hook-setup ()
  (unless (is-buffer-file-temp)
    (setq evil-auto-indent nil)
    ;; org-mode's own flycheck will be loaded
    (enable-flyspell-mode-conditionally)

    ;; No auto spell check during Emacs startup
    ;; please comment out `(flyspell-mode -1)` if you prefer auto spell check
    (flyspell-mode -1)

    ;; for some reason, org8 disable odt export by default
    (add-to-list 'org-export-backends 'odt)
    ;; (add-to-list 'org-export-backends 'org) ; for org-mime

    ;; org-mime setup, run this command in org-file, than yank in `message-mode'
    (local-set-key (kbd "C-c M-o") 'org-mime-org-buffer-htmlize)

    ;; don't spell check double words
    (setq flyspell-check-doublon nil)

    ;; create updated table of contents of org file
    ;; @see https://github.com/snosov1/toc-org
    (toc-org-enable)

    ;; display wrapped lines instead of truncated lines
    (setq truncate-lines nil)
    (setq word-wrap t)))
(add-hook 'org-mode-hook 'org-mode-hook-setup)

(defadvice org-open-at-point (around org-open-at-point-choose-browser activate)
  "`C-u M-x org-open-at-point` open link with `browse-url-generic-program'"
  (let* ((browse-url-browser-function
          (cond
           ;; open with `browse-url-generic-program'
           ((equal (ad-get-arg 0) '(4)) 'browse-url-generic)
           ;; open with w3m
           (t 'w3m-browse-url))))
    ad-do-it))

(defadvice org-publish (around org-publish-advice activate)
  "Stop running `major-mode' hook when org-publish."
  (let* ((load-user-customized-major-mode-hook nil))
    ad-do-it))

;; {{ org2nikola set up
(setq org2nikola-output-root-directory "~/.config/nikola")
(setq org2nikola-use-google-code-prettify t)
(setq org2nikola-prettify-unsupported-language '(elisp "lisp" emacs-lisp "lisp"))
;; }}

(defun org-demote-or-promote (&optional is-promote)
  (interactive "P")
  (unless (region-active-p)
    (org-mark-subtree))
  (if is-promote (org-do-promote) (org-do-demote)))

;; {{ @see http://orgmode.org/worg/org-contrib/org-mime.html
(defun org-mime-html-hook-setup ()
  (org-mime-change-element-style "pre"
                                 "color:#E6E1DC; background-color:#232323; padding:0.5em;")
  (org-mime-change-element-style "blockquote"
                                 "border-left: 2px solid gray; padding-left: 4px;"))

(eval-after-load 'org-mime
  '(progn
     (setq org-mime-export-options '(:section-numbers nil :with-author nil :with-toc nil))
     (add-hook 'org-mime-html-hook 'org-mime-html-hook-setup)))

;; demo video: http://vimeo.com/album/1970594/video/13158054
(add-hook 'message-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c M-o") 'org-mime-htmlize)))
;; }}

(defun org-agenda-show-agenda-and-todo (&optional arg)
  "Better org-mode agenda view."
  (interactive "P")
  (org-agenda arg "n"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; org mode 个人配置
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; 添加chrome link
(defun zilongshanren/insert-chrome-current-tab-url()
  "Get the URL of the active tab of the first window"
  (interactive)
  (insert (zilongshanren/retrieve-chrome-current-tab-url)))

(defun zilongshanren/retrieve-chrome-current-tab-url()
  "Get the URL of the active tab of the first window"
  (interactive)
  (let ((result (do-applescript
		 (concat
		  "set frontmostApplication to path to frontmost application\n"
		  "tell application \"Google Chrome\"\n"
		  "	set theUrl to get URL of active tab of first window\n"
		  "	set theResult to (get theUrl) \n"
		  "end tell\n"
		  "activate application (frontmostApplication as text)\n"
		  "set links to {}\n"
		  "copy theResult to the end of links\n"
		  "return links as string\n"))))
    (format "%s" (s-chop-suffix "\"" (s-chop-prefix "\"" result)))))

(setq org-agenda-files '("~/github/org-pages"))
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-capture-templates
      '(
        ("a" "Q&A" entry (file+headline "~/github/org-pages/q&a.org" "Question & Answer")
         "* TODO %^u %?\n  #+BEGIN_QUOTE\n  SCHEDULED: %^T\n %i\n  #+END_QUOTE\n"
         :prepend t)
        ("b" "Body" entry (file+headline "~/github/org-pages/body.org" "Body Building")
         "* TODO %^u %?\n  %i\n"
         :prepend t)
        ("c" "Code" entry (file+headline "~/github/org-pages/code.org" "Coding List")
         "* TODO %^u %?\n  %i\n"
         :prepend t)
        ("g" "Bugs" entry (file+headline "~/github/org-pages/bug.org" "Bug List")
         "* TODO %^u %?\n  #+BEGIN_QUOTE\n  SCHEDULED: %^T\n %i\n  #+END_QUOTE\n"
         :prepend t)
        ("k" "Knowledge Fragment" plain
         (file+headline "~/github/org-pages/fragment.org" "Knowledge Fragment")
         "- %^u \n  #+BEGIN_QUOTE\n  %? \n  #+END_QUOTE\n"
         :prepend t)
        ("p" "Python Promodoro" entry
         (file+headline "~/github/org-pages/note/python.org" "Python Promodoro")
         "* %^u %?\n  #+BEGIN_QUOTE\n  %i\n  #+END_QUOTE\n"
         :prepend t)
        ("r" "Read" entry (file+olp"~/github/org-pages/read.org" "Reading List")
         "* TODO %^u %? \n  #+BEGIN_QUOTE\n  SCHEDULED: <%<%Y-%m-%d %a .+1d>>\n  %i\n  #+END_QUOTE\n"
         :clock-in t
         :clock-resume t
         :prepend t)
        ("w" "Write" entry (file+headline "~/github/org-pages/write.org" "Writing List")
         "* TODO %^T %?\n  %i\n"
         :prepend t)
        ("l" "Chrome" entry (file+headline "~/github/org-pages/link.org" "Link Notes")
         "* TODO %^u %?\n #+BEGIN_QUOTE\n %(zilongshanren/retrieve-chrome-current-tab-url) \n\n SCHEDULED:%^T\n  %i\n #+END_QUOTE\n"
         :empty-lines 1
         :prepend t)
        ("h" "Habit" entry (file "~/github/org-pages/habit.org")
         "* TODO %^u %?\nSCHEDULED: <%<%Y-%m-%d %a .+1d>>\n:PROPETIES:\n:CREATED: %U\n\n:STYLE: habit\n\n:REPEAT_TO_STATE: TODO\n\n:LOGGING: DONE(!)\n\n:ARCHIVE: %%s_archive::* Habits\n\n:END:\n%U\n"
         :empty-lines 1
         :prepend t)
      ))
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
(require 'ox-publish)
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
;; (custom-set-faces
;;  '(org-table ((t (:family "Ubuntu Mono derivative Powerline")))))


;;emacs orgmode 默认开启图片显示
(setq org-toggle-inline-images t)
(setq org-image-actual-width 300)

(provide 'init-org)
