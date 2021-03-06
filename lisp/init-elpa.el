;; -*- coding: utf-8; lexical-binding: t; -*-

;; List of visible packages from melpa-unstable (http://melpa.org).
;; Please add the package name into `melpa-include-packages`
;; if it's not visible after  `list-packages'.
(defvar melpa-include-packages
  '(ace-mc
    ace-window ; lastest stable is released on year 2014
    artbollocks-mode
    auto-package-update
    bbdb
    evil-textobj-syntax
    command-log-mode
    vimrc-mode
    auto-yasnippet
    dumb-jump
    websocket ; to talk to the browser
    evil-exchange
    evil-find-char-pinyin
    evil-lion
    counsel-css
    iedit
    undo-tree
    js-doc
    jss ; remote debugger of browser
    ;; {{ since stable v0.9.1 released, we go back to stable version
    ivy ; stable counsel dependent unstable ivy
    ;;counsel
    ;;swiper
    ;; }}
    gruber-darker-theme
    wgrep
    robe
    slime
    groovy-mode
    inf-ruby
    simple-httpd
    dsvn
    findr
    mwe-log-commands
    yaml-mode
    counsel-gtags ; the stable version is never released
    noflet
    db
    package-lint
    creole
    web
    buffer-move
    regex-tool
    legalese
    htmlize
    scratch
    session
    flymake-lua
    multi-term
    inflections
    lua-mode
    auto-compile
    packed
    ;;keyfreq
    gitconfig-mode
    textile-mode
    w3m
    ;;erlang
    workgroups2
    zoutline
    ;;company ; I won't wait another 2 years for stable
    company-c-headers
    company-statistics)
  "Packages to install from melpa-unstable.")

(defvar melpa-stable-banned-packages nil
  "Banned packages from melpa-stable")

;; I don't use any packages from GNU ELPA because I want to minimize
;; dependency on 3rd party web site.
(setq package-archives
      '(("localelpa" . "~/.emacs.d/localelpa/")
        ;; uncomment below line if you need use GNU ELPA
        ;; remove emacs itself org
        ("org" . "https://orgmode.org/elpa/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ;; emacs-china
        ;;("org" . "http://elpa.emacs-china.org/org/")
        ;;("gnu"   . "http://elpa.emacs-china.org/gnu/")
        ;;("melpa" . "http://elpa.emacs-china.org/melpa/")
        ;; Use either 163 or tsinghua mirror repository when official melpa
        ;; is too slow or shutdown.
        ;; ;; {{ Option 1: 163 mirror repository:
        ;; ("gnu" . "https://mirrors.163.com/elpa/gnu/")
        ;; ("melpa" . "https://mirrors.163.com/elpa/melpa/")
        ;; ("melpa-stable" . "https://mirrors.163.com/elpa/melpa-stable/")
        ;; ;; }}

        ;; ("melpa" . "https://www.mirrorservice.org/sites/melpa.org/packages/")


        ;; ("gnu" . "https://mirrors.ustc.edu.cn/elpa/gnu/")
        ;; ("melpa" . "https://mirrors.ustc.edu.cn/elpa/melpa/")


        ;; ("gnu" . "https://mirrors.cloud.tencent.com/elpa/gnu/")
        ;; ("melpa" . "https://mirrors.cloud.tencent.com/elpa/melpa/")


        ;; ("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ;; ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ;; ;; {{ Option 2: tsinghua mirror repository
        ;; ;; @see https://mirror.tuna.tsinghua.edu.cn/help/elpa/ on usage:
        ;; ;; ("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ;; ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
        ;; ("melpa-stable" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa-stable/")
        ;; }}
        ))

;; Un-comment below line if you follow "Install stable version in easiest way"
;; (setq package-archives '(("localelpa" . "~/.emacs.d/localelpa/") ("myelpa" . "~/projs/myelpa/")))

;;------------------------------------------------------------------------------
;; Internal implementation, newbies should NOT touch code below this line!
;;------------------------------------------------------------------------------

;; Patch up annoying package.el quirks
(defadvice package-generate-autoloads (after close-autoloads (name pkg-dir) activate)
  "Stop package.el from leaving open autoload files lying around."
  (let* ((path (expand-file-name (concat
                                  ;; name is string when emacs <= 24.3.1,
                                  (if (symbolp name) (symbol-name name) name)
                                  "-autoloads.el") pkg-dir)))
    (with-current-buffer (find-file-existing path)
      (kill-buffer nil))))

(defun package-filter-function (package version archive)
  "Optional predicate function used to internally filter packages used by package.el.

  The function is called with the arguments PACKAGE VERSION ARCHIVE, where
  PACKAGE is a symbol, VERSION is a vector as produced by `version-to-list', and
  ARCHIVE is the string name of the package archive."
  (let* (rlt)
    (cond
     ((string= archive "melpa-stable")
      (setq rlt (not (memq package melpa-stable-banned-packages))))
     ((string= archive "melpa")
      ;; We still need use some unstable packages
      (setq rlt (or (string-match-p (format "%s" package)
                                    (mapconcat (lambda (s) (format "%s" s)) melpa-include-packages " "))
                    ;; color themes are welcomed
                    (string-match-p "-theme" (format "%s" package)))))
     (t
      ;; I'm not picky on other repositories
      (setq rlt t)))
    rlt))

(defadvice package--add-to-archive-contents
    (around filter-packages (package archive) activate)
  "Add filtering of available packages using `package-filter-function'."
  (if (package-filter-function (car package)
                               (funcall (if (fboundp 'package-desc-version)
                                            'package--ac-desc-version
                                          'package-desc-vers)
                                        (cdr package))
                               archive)
      ad-do-it))

;; On-demand installation of packages
(defun require-package (package &optional min-version no-refresh)
  "Ask elpa to install given PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

;;------------------------------------------------------------------------------
;; Fire up package.el and ensure the following packages are installed.
;;------------------------------------------------------------------------------

(require-package 'async)
                                        ; color-theme 6.6.1 in elpa is buggy
(require-package 'auto-compile)
;; M-x 提示包
(require-package 'smex)
(require-package 'avy)
(require-package 'auto-yasnippet)
(require-package 'ace-link)
(require-package 'expand-region) ; I prefer stable version
(require-package 'fringe-helper)
(require-package 'haskell-mode)
(require-package 'gitignore-mode)
(require-package 'gitconfig-mode)
(require-package 'gist)
(require-package 'wgrep)
(require-package 'request)
(require-package 'lua-mode)
(require-package 'robe)
(require-package 'inf-ruby)
(require-package 'workgroups2)
(require-package 'yaml-mode)
(require-package 'paredit)
;;(require-package 'erlang)
(require-package 'findr)
(require-package 'pinyinlib)
(require-package 'find-by-pinyin-dired)
(require-package 'jump)
(require-package 'nvm)
(require-package 'writeroom-mode)
(require-package 'haml-mode)
(require-package 'scss-mode)
(require-package 'markdown-mode)
(require-package 'link)
(require-package 'connection)
(require-package 'dictionary) ; dictionary requires 'link and 'connection
(require-package 'diminish)
(require-package 'scratch)
(require-package 'rainbow-delimiters)
(require-package 'textile-mode)
(require-package 'dsvn)
(require-package 'git-timemachine)
(require-package 'exec-path-from-shell) ;; mac requires
;; (require-package 'flymake-css)
;; (require-package 'flymake-jslint)
;; (require-package 'flymake-ruby)
(require-package 'ivy)
(require-package 'swiper)
(require-package 'company-jedi)
(require-package 'counsel) ; counsel => swiper => ivy
(require-package 'find-file-in-project)
(require-package 'counsel-bbdb)
(require-package 'ibuffer-vc)
(require-package 'less-css-mode)
(require-package 'command-log-mode)
(require-package 'regex-tool)
(require-package 'groovy-mode)
(require-package 'ruby-compilation)
(require-package 'emmet-mode)
(require-package 'session)
(require-package 'unfill)
(require-package 'w3m)
(require-package 'counsel-gtags)
(require-package 'buffer-move)
(require-package 'ace-window)
(require-package 'cmake-mode)
(require-package 'cpputils-cmake)
(require-package 'flyspell-lazy)
(require-package 'bbdb)
(require-package 'ox-gfm)
;; (require-package 'pomodoro)
;; (require-package 'flymake-lua)
;; rvm-open-gem to get gem's code
(require-package 'rvm)
;; C-x r l to list bookmarks
(require-package 'multi-term)
(require-package 'js-doc)
(require-package 'js2-mode)
(require-package 'js2-refactor)
(require-package 'rjsx-mode)
(require-package 's)
;;运行 js
(require-package 'nodejs-repl)
;; js2-refactor requires js2, dash, s, multiple-cursors, yasnippet
;; I don't use multiple-cursors, but js2-refactor requires it
(require-package 'multiple-cursors)
(require-package 'ace-mc)
(require-package 'tagedit)
(require-package 'git-link)
(require-package 'cliphist)
(require-package 'yasnippet)
(require-package 'yasnippet-snippets)
;;自动补全
(require-package 'company)

(require-package 'company-c-headers)
(require-package 'company-statistics)
(require-package 'auto-complete)
(require-package 'elpy)
(require-package 'anaconda-mode)
(require-package 'legalese)
(require-package 'simple-httpd)
;; (require-package 'git-gutter) ; use my patched version
(require-package 'neotree)
(require-package 'hydra)
(require-package 'ivy-hydra) ; @see https://oremacs.com/2015/07/23/ivy-multiaction/
(require-package 'pyim)
(require-package 'web-mode)
(require-package 'dumb-jump)
(require-package 'emms)
(require-package 'package-lint) ; lint package before submit it to MELPA
(require-package 'iedit)
(require-package 'helm-ag)
(require-package 'hungry-delete)
(require-package 'org)
(require-package 'org-plus-contrib)
(require-package 'org-bullets)
(require-package 'htmlize)

(require-package 'ace-pinyin)
(require-package 'bash-completion)
(require-package 'websocket) ; for debug debugging of browsers
(require-package 'jss)
(require-package 'undo-tree)
(require-package 'evil)
(require-package 'evil-escape)
(require-package 'evil-exchange)
(require-package 'evil-find-char-pinyin)
(require-package 'evil-iedit-state)
(require-package 'evil-mark-replace)
(require-package 'evil-matchit)
(require-package 'evil-nerd-commenter)
(require-package 'evil-surround)
(require-package 'evil-visualstar)
(require-package 'evil-lion)
(require-package 'evil-args)
(require-package 'evil-textobj-syntax)
(require-package 'slime)
(require-package 'counsel-css)
(require-package 'auto-package-update)
                                        ;(require-package 'keyfreq)
(require-package 'adoc-mode) ; asciidoc files
(require-package 'magit) ; Magit 2.12 is the last feature release to support Emacs 24.4.
(require-package 'shackle)
(require-package 'toc-org)
(require-package 'popwin)
(require-package 'artbollocks-mode)
(require-package 'elpa-mirror)
;; {{ @see https://pawelbx.github.io/emacs-theme-gallery/
(require-package 'color-theme)
;; emms v5.0 need seq
(require-package 'seq)
(require-package 'use-package)
(require-package 'lsp-mode)
;; (require-package 'rust-mode)
;; (require-package 'rustic)
(require-package 'go-mode)
(require-package 'lsp-ui)
(require-package 'stripe-buffer)
(require-package 'visual-regexp) ;; Press "M-x vr-*"
(require-package 'vimrc-mode)
(require-package 'flycheck)
(require-package 'json-mode)
(require-package 'yaml-mode)
(require-package 'pangu-spacing)
                                        ;(require-package 'go-mode)
(require-package 'protobuf-mode)
(require-package 'reveal-in-osx-finder)

(when *emacs25*
  (require-package 'molokai-theme) ; recommended
  (require-package 'cyberpunk-theme) ; recommended
  (require-package 'darkburn-theme) ; recommended
  (require-package 'dakrone-theme)
  (require-package 'doom-themes))
;; }}

;; kill buffer without my confirmation
(setq kill-buffer-query-functions (delq 'process-kill-buffer-query-function kill-buffer-query-functions))

(provide 'init-elpa)
