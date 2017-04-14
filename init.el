;;===========================================================================
;;
;; ~/.emacs.d/init.el
;; Author: Steve Phillips
;;
;;===========================================================================

;;---------------------------------------------------------------------------
;;
;; Add my personal elisp lib to the load path
(setq load-path (cons "~/.emacs.d/elisp" load-path))

(setq inhibit-default-init t)         ;; disable loading of
                                      ;; "default.el" at startup

(setq transient-mark-mode t)          ;; enable visual feedback on
                                      ;;    selections 
(set-scroll-bar-mode 'right)          ;; Put scrollbar on right to
                                      ;;   match other windows. Replace
				      ;;   'right with 'left to place it
				      ;;   to the left    
(setq frame-title-format              ;; default to better frame
                                      ;;   titles 
      (concat  "%b - emacs@" (system-name)))
(setq diff-switches "-u")             ;; default to unified diffs
(setq require-final-newline 'query)   ;; always end a file with a
                                      ;;   newline 
;; Try some mouse wheel settings
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
(setq mouse-wheel-progressive-speed nil)

;; Use isearch by default
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)

(show-paren-mode 1)                   ;; Highlight matching paren
(setq-default indent-tabs-mode nil)   ;; 
;;(setq x-select-enable-clipboard t)    ;; Under X, use X clipboard
;;(setq x-select-enable-primary t)      ;; Under X, use X clipboard
(setq save-interprogram-paste-before-kill t) 
(setq apropos-do-all t)
(setq mouse-yank-at-point t)          ;; Mouse yanking inserts at the
                                      ;;   point instead of the
                                      ;;   location of the click
(setq require-final-newline t)        ;; require file to end with newline 
(setq visible-bell t)
(setq load-prefer-newer t)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)
(setq save-place-file (concat user-emacs-directory "places"))
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory
					       "backups"))))

;;---------------------------------------------------------------------------
;;
;; Packages
;;
;; Lets use package.el and the Melpa repo
(require 'package) 
(add-to-list 'package-archives
             '("sjp" . "~/.emacs.d/packages/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; Lets use the "use-package" package to make loading of packages more
;; ephisiant. See https://goo.gl/LtWMy for details 
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-verbose t)

;; Ivy - https://goo.gl/uv6e2k
;; Configure to use ivy-mode for completion
(use-package ivy
  :init
  (ivy-mode 1))

;; Neotree - https://goo.gl/N05Cdj
;; DIrectory browser like in Finder
(use-package neotree
  :init
  (global-set-key [f8] 'neotree-toggle))

;; Smartscan - https://goo.gl/FWI0XF
;; Quickly search for symbol at point with M-n and M-p
;; Stored in ~/.emacs.d/packages/
(use-package smartscan
  :init
  (smartscan-mode 1))

;; which-key - https://goo.gl/vYPnea
;; Displays key bindings for buffer. After starting a command
;; sequence, it will show possible completions. For instance, hit C-x,
;; wait a sec, and a help window will pop up 
  (use-package which-key
   :init
   (which-key-mode)  ;; turn on which-key mode
   ;; try to use a side window if there is room, otherwise
   ;;   use a bottom window 
   (which-key-setup-side-window-right-bottom))

;; smart-mode-line - https://goo.gl/cJjp28
;; makes your modeline smarter
(use-package smart-mode-line
  :init
 (setq sml/no-confirm-load-theme t) ;; see web page
 (sml/setup))

;; arduino-mode -
(use-package arduino-mode
  :init
  (setq auto-mode-alist (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode) auto-mode-alist)))
  

;;--------------------------------------------------------------
;;
;; Verilog mode settings
;;
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))
(setq verilog-auto-newline nil)


;;---------------------------------------------------------------------------
;;
;; Org Mode
;;
;; The following lines are always needed. Choose your own keys.
;;(global-set-key "\C-cl" 'org-store-link)
;;(global-set-key "\C-ca" 'org-agenda)
;;(global-set-key "\C-cc" 'org-capture)
;;(global-set-key "\C-cb" 'org-iswitchb)

;;==================================================================================
;; Don't edit below this because Emacs maintains this stuff through it's
;; customize interface
;;==================================================================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(package-selected-packages
   (quote
    (powerline which-key use-package smartscan neotree ivy diffview)))
 '(sml/theme (quote dark)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
