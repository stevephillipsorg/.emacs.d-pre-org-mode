;;===========================================================================
;;
;; ~/.emacs.d/init.el
;; Author: Steve Phillips
;;
;;===========================================================================
;; Useful commands
;;
;; Key Seq  Command
;; =======  ==================================
;; C-x C-e  eval-last-sexp
;; C-h k    describe-key
;; M-q      fill-paragraph
;; C-x C-=  text-scale-adjust increase
;; C-x C--  text-scale-adjust decrease
;; <F5>     Select another theme
;;---------------------------------------------------------------------------
;;
;; Packages I'm using:
;;
;;  DESKTOP         - Saves session and restores on restart
;;  FLYCHECK        - Syntax checker 
;;  ELPY            - Python extension
;;  IVY             - Enhanced mini-buffer completion
;;    COUNSEL         - Ivy enhancements
;;    IVY-RICH        - Make Ivy and Counsel pretty
;;  NEOTREE         - Directory browser like in Finder
;;  ORG-MODE        - Super duper Markdown mode
;;    ORG-BULLETS     - Make Org headlines have bullet icons
;;  PACKAGE         - Package management and use-package function
;;  SMART-MODE-LINE - Enhanced mode line
;;  SMARTSCAN       - Quickly search for symbol at point with M-n and M-p
;;  SWIPER          - Enhanced isearch with completion list in mini-buffer
;;  TRY             - Try a package without use-package
;;  WHICH-KEY       - Interactively show command completions
;;  
;; Packages I've heard are good to try:
;;
;;---------------------------------------------------------------------------

;; Add my personal elisp lib to the load path
(setq load-path (cons "~/.emacs.d/elisp" load-path))

(setq inhibit-splash-screen t)        ;; no splash screen at startup
(tool-bar-mode -1)                    ;; no graphical toolbar
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
(defalias 'list-buffers 'ibuffer)     ;; Use ibuffer instead of plain buffer list
(setq diff-switches "-u")             ;; default to unified diffs
(setq require-final-newline 'query)   ;; always end a file with a
                                      ;;   newline
(fset 'yes-or-no-p 'y-or-n-p)         ;; brevity

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

;; Set some mode hooks
(setq c-mode-common-hook ;; will be used by all modes derived from c-mode
      '(lambda ()
         (ggtags-mode 1)
         ))

;;---------------------------------------------------------------------------
;; Desktop - A system for saving current session and restoring on restart

;;   You can set an environment variable change the location of the
;;   save file. The default is the ~/.emacs.d/
(when (getenv "EMACSSAVEMODEDIR")
  (setq desktop-path (list (getenv "EMACSSAVEMODEDIR"))) )

;; Turn on the desktop save function
(desktop-save-mode 1)

; from http://www.emacswiki.org/emacs/Desktop#toc3
; "add something like this to your init file to auto-save your desktop when Emacs is idle: – Doom"
(require 'desktop)
  (defun my-desktop-save ()
    (interactive)
    ;; Don't call desktop-save-in-desktop-dir, as it prints a message.
    (if (eq (desktop-owner) (emacs-pid))
        (desktop-save desktop-dirname)))
  (add-hook 'auto-save-hook 'my-desktop-save)

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
(add-to-list 'package-archives
             '("org" . "https://orgmode.org/elpa/"))
;;sjp-not needed anymore;;(when (< emacs-major-version 24)
;;sjp-not needed anymore;;  ;; For important compatibility libraries like cl-lib
;;sjp-not needed anymore;;  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; Lets use the "use-package" package to make loading of packages easier
;; See https://goo.gl/LtWMy for details 
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t
      use-package-verbose t)

;; Try - Allows one to try a new package without adding it to
;; use-package. The package will go away the next time emacs is
;; restarted
(use-package try
  :ensure t)
  
;; which-key - https://goo.gl/vYPnea
;; Displays key bindings for buffer. After starting a command
;; sequence, it will show possible completions. For instance, hit C-x,
;; wait a sec, and a help window will pop up 
(use-package which-key
  :ensure t  ;; make sure it loads correctly
  :init
  (which-key-mode)  ;; turn on which-key mode
  ;; try to use a side window if there is room, otherwise
  ;;   use a bottom window 
  (which-key-setup-side-window-right-bottom))

;; Color Themes 
(use-package modus-themes
  :ensure
  :init
  ;; Add all your customizations prior to loading the themes
  (setq modus-themes-slanted-constructs t
        modus-themes-bold-constructs nil)

  ;; Load the theme files before enabling a theme
  (modus-themes-load-themes)
  :config
  ;; Load the theme of your choice:
  (modus-themes-load-operandi) ;; OR (modus-themes-load-vivendi)
;;  :bind ("<f5>" . modus-themes-toggle)
  )

;; Ivy/Counsel/Swiper - https://goo.gl/uv6e2k
;; Configure to use ivy-mode for completion
;; These config lines stolen from - https://tinyurl.com/yxas68kw
(use-package ivy
  :defer 0.1
  :diminish
  :bind (("C-c C-r" . ivy-resume)
         ("C-x B" . ivy-switch-buffer-other-window))
  :custom
  (ivy-count-format "(%d/%d) ")
  (ivy-use-virtual-buffers t)
  :config (ivy-mode))

(use-package counsel
  :after ivy
  :config (counsel-mode)
  :bind ("<f5>" . counsel-load-theme)
)

(use-package ivy-rich
  :ensure t
  :after (:all ivy counsel)
  :init (setq ivy-rich-parse-remote-file-path t)
  :config (ivy-rich-mode 1))

(use-package swiper
  :after ivy
  :bind (("C-s" . swiper)
         ("C-r" . swiper)))

;;sjp;; This adds a help utility to complete variable names as you
;;sjp;; type them, which is nice, except that it throws my typing
;;sjp;; off because it grabs control of curser movement. More
;;sjp;; trouble than its worh.
;;;; auto-complete - enhanced autocomplete function
;;;;  compare with "company"
;;(use-package auto-complete
;;  :ensure t
;;  :init
;;  (progn
;;    (ac-config-default) ;; use default settings
;;    (global-auto-complete-mode t) ;; use everywhere
;;    ))
;;sjp;; end of commenting out auto-complete package

;; command-log-mode
;; - Displays commands key strokes and the associated functions in a
;;   right hand buffer
;; - Must first enable it for the buffer
;;   - M-x command-log-mode
;; - Then enable the display buffer
;;   - M-x clm/toggle-command-log-buffer OR
;;   - C-c o
(use-package command-log-mode
  :ensure t)

;; Magit - https://magit.vc/
;;   Interface to Git
;;(use-package magit
;;  :ensure t
;;  :bind ("C-x g" . magit-status)
;;  )

;; Neotree - https://goo.gl/N05Cdj
;; Directory browser like in Finder
(use-package neotree
  :init
  (global-set-key [f8] 'neotree-toggle))

;; smart-mode-line - https://goo.gl/cJjp28
;; makes your modeline smarter
(use-package smart-mode-line
  :init
 (setq sml/no-confirm-load-theme t) ;; see web page
 (sml/setup))

;; flycheck - linter for many languages - https://www.flycheck.org/
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; arduino-mode -
(use-package arduino-mode
  :init
  (setq auto-mode-alist (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode) auto-mode-alist)))
  
;;sjp;;;; smartscan - FIXME: Why do I have this twice?
;;sjp;;(use-package smartscan
;;sjp;;  :init
;;sjp;;  (global-smartscan-mode 1))

;; markdown-mode
(use-package markdown-mode
  :mode ("\\.\\(m\\(ark\\)?down\\|md\\)$" . markdown-mode)
  :config)

;; elpy - Extension for Python - https://elpy.readthedocs.io/en/latest/index.html#elpy
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

;; Smartscan - https://goo.gl/FWI0XF
;; Quickly search for symbol at point with M-n and M-p
;; Stored in ~/.emacs.d/packages/
(use-package smartscan
  :init
  (global-smartscan-mode 1))

;; disk-usage
(use-package disk-usage
  :load-path "packages/disk-usage"
  )
;;--------------------------------------------------------------
;;
;; Verilog mode settings
;;
(use-package verilog-mode
  :mode ("\\.[ds]?vh?\\'" . verilog-mode)
  :init (setq verilog-auto-newline nil) ;; Non-nil means automatically newline after semicolons.
  )
;;sjp;;;; This is how I always used to load verilog mode 
;;sjp;;(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
;;sjp;;(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))
;;sjp;;(add-hook 'verilog-mode-hook
;;sjp;;          '(lambda ()
;;sjp;;             (setq verilog-auto-newline nil)
;;sjp;;             (setq ggtags-mode t) ;; always run ggtags-mode in verilog mode
;;sjp;;             ))


;;---------------------------------------------------------------------------
;;
;; Org Mode
;;
;; org-bullets - enables the use of nice graphical bullets for lists
(use-package org-bullets
  :ensure t
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

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
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#ebdbb2" "#9d0006" "#98971a" "#b57614" "#076678" "#d3869b" "#689d6a" "#3c3836"])
 '(awesome-tray-mode-line-active-color "#0031a9")
 '(awesome-tray-mode-line-inactive-color "#d7d7d7")
 '(beacon-color "#c82829")
 '(company-quickhelp-color-background "#e8e8e8")
 '(company-quickhelp-color-foreground "#444444")
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#689d6a")
 '(cua-normal-cursor-color "#7c6f64")
 '(cua-overwrite-cursor-color "#b57614")
 '(cua-read-only-cursor-color "#98971a")
 '(custom-enabled-themes '(smart-mode-line-dark hc-zenburn))
 '(custom-safe-themes
   '("c2e1201bb538b68c0c1fdcf31771de3360263bd0e497d9ca8b7a32d5019f2fae" "da53c5d117ebada2664048682a345935caf8e54094a58febd5f021462ef20ba2" "33ea268218b70aa106ba51a85fe976bfae9cf6931b18ceaf57159c558bbcd1e6" "89885317e7136d4e86fb842605d47d8329320f0326b62efa236e63ed4be23c58" "7922b14d8971cce37ddb5e487dbc18da5444c47f766178e5a4e72f90437c0711" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "a37d20710ab581792b7c9f8a075fcbb775d4ffa6c8bce9137c84951b1b453016" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "58c6711a3b568437bab07a30385d34aacf64156cc5137ea20e799984f4227265" "72a81c54c97b9e5efcc3ea214382615649ebb539cb4f2fe3a46cd12af72c7607" "e9776d12e4ccb722a2a732c6e80423331bcb93f02e089ba2a4b02e85de1cf00e" "3cc2385c39257fed66238921602d8104d8fd6266ad88a006d0a4325336f5ee02" "3cd28471e80be3bd2657ca3f03fbb2884ab669662271794360866ab60b6cb6e6" "e0d42a58c84161a0744ceab595370cbe290949968ab62273aed6212df0ea94b4" "987b709680284a5858d5fe7e4e428463a20dfabe0a6f2a6146b3b8c7c529f08b" "c48551a5fb7b9fc019bf3f61ebf14cf7c9cdca79bcb2a4219195371c02268f11" "a10ca93d065921865932b9d7afae98362ce3c347f43cb0266d025d70bec57af1" "d2db4af7153c5d44cb7a67318891e2692b8bf5ddd70f47ee7a1b2d03ad25fcd9" "96998f6f11ef9f551b427b8853d947a7857ea5a578c75aa9c4e7c73fe04d10b4" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "b3775ba758e7d31f3bb849e7c9e48ff60929a792961a2d536edec8f68c671ca5" "9b59e147dbbde5e638ea1cde5ec0a358d5f269d27bd2b893a0947c4a867e14c1" "621595cbf6c622556432e881945dda779528e48bb57107b65d428e61a8bb7955" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default))
 '(desktop-save-mode t)
 '(exwm-floating-border-color "#888888")
 '(fci-rule-color "#ebdbb2")
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(flymake-error-bitmap '(flymake-double-exclamation-mark modus-theme-fringe-red))
 '(flymake-note-bitmap '(exclamation-mark modus-theme-fringe-cyan))
 '(flymake-warning-bitmap '(exclamation-mark modus-theme-fringe-yellow))
 '(frame-background-mode 'light)
 '(global-smartscan-mode t)
 '(highlight-changes-colors '("#d3869b" "#8f3f71"))
 '(highlight-symbol-colors
   '("#ecd19a" "#d5dbae" "#eabb92" "#e0c3b1" "#e3d99d" "#eec394" "#c5ccb3"))
 '(highlight-symbol-foreground-color "#665c54")
 '(highlight-tail-colors
   '(("#ebdbb2" . 0)
     ("#c6c148" . 20)
     ("#82cc73" . 30)
     ("#5b919b" . 50)
     ("#e29a3f" . 60)
     ("#df6835" . 70)
     ("#f598a7" . 85)
     ("#ebdbb2" . 100)))
 '(hl-bg-colors
   '("#e29a3f" "#df6835" "#cf5130" "#f598a7" "#c2608f" "#5b919b" "#82cc73" "#c6c148"))
 '(hl-fg-colors
   '("#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7" "#fbf1c7"))
 '(hl-paren-colors '("#689d6a" "#b57614" "#076678" "#8f3f71" "#98971a"))
 '(hl-sexp-background-color "#1c1f26")
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#3a81c3")
     ("OKAY" . "#3a81c3")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#42ae2c")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f")))
 '(ibuffer-deletion-face 'modus-theme-mark-del)
 '(ibuffer-filter-group-name-face 'modus-theme-mark-symbol)
 '(ibuffer-marked-face 'modus-theme-mark-sel)
 '(ibuffer-title-face 'modus-theme-pseudo-header)
 '(ivy-count-format "(%d/%d) ")
 '(ivy-use-virtual-buffers t)
 '(linum-format " %7i ")
 '(lsp-ui-doc-border "#665c54")
 '(nrepl-message-colors
   '("#9d0006" "#af3a03" "#b57614" "#747400" "#c6c148" "#004858" "#689d6a" "#d3869b" "#8f3f71"))
 '(org-src-block-faces 'nil)
 '(package-selected-packages
   '(doneburn-theme labburn-theme anti-zenburn-theme material-theme color-theme-sanityinc-tomorrow hc-zenburn-theme zenburn-theme auto-complete ivy-rich counsel ggtags flycheck elpy nhexl-mode dimmer dired-du sublime-themes white-sand-theme solarized-theme spacemacs-theme markdown-mode magit powerline which-key use-package smartscan neotree ivy diffview))
 '(pdf-view-midnight-colors '("#655370" . "#fbf8ef"))
 '(pos-tip-background-color "#ebdbb2")
 '(pos-tip-foreground-color "#665c54")
 '(rainbow-identifiers-choose-face-function 'rainbow-identifiers-cie-l*a*b*-choose-face)
 '(rainbow-identifiers-cie-l*a*b*-color-count 1024)
 '(rainbow-identifiers-cie-l*a*b*-lightness 80)
 '(rainbow-identifiers-cie-l*a*b*-saturation 25)
 '(safe-local-variable-values
   '((org-ascii-headline-spacing 0 . 0)
     (org-ascii-bullets
      (ascii 42)
      (latin1 167)
      (utf-8 8226))
     (org-ascii-headline-spacing)))
 '(show-paren-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#98971a" "#ebdbb2" 0.2))
 '(sml/theme 'dark)
 '(term-default-bg-color "#fbf1c7")
 '(term-default-fg-color "#7c6f64")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#9d0006")
     (40 . "#aa4a0b")
     (60 . "#b0600f")
     (80 . "#b57614")
     (100 . "#ac8115")
     (120 . "#a78716")
     (140 . "#a28c17")
     (160 . "#9d9118")
     (180 . "#98971a")
     (200 . "#8b993a")
     (220 . "#849a47")
     (240 . "#7b9b53")
     (260 . "#729c5e")
     (280 . "#689d6a")
     (300 . "#4d8670")
     (320 . "#3e7b73")
     (340 . "#2a7075")
     (360 . "#076678")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#fbf1c7" "#ebdbb2" "#750000" "#9d0006" "#747400" "#98971a" "#8a5100" "#b57614" "#004858" "#076678" "#9f4d64" "#d3869b" "#2e7d33" "#689d6a" "#7c6f64" "#3c3836"))
 '(window-divider-mode nil)
 '(xterm-color-names
   ["#ebdbb2" "#9d0006" "#98971a" "#b57614" "#076678" "#d3869b" "#689d6a" "#32302f"])
 '(xterm-color-names-bright
   ["#fbf1c7" "#af3a03" "#a89984" "#3c3836" "#7c6f64" "#8f3f71" "#665c54" "#282828"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:background nil)))))
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
