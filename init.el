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

(setq inhibit-splash-screen t)        ;; no splash screen at startup
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

;; Lets use the "use-package" package to make loading of packages easier
;; See https://goo.gl/LtWMy for details 
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

;; flycheck - linter for many languages - https://www.flycheck.org/
(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

;; arduino-mode -
(use-package arduino-mode
  :init
  (setq auto-mode-alist (cons '("\\.\\(pde\\|ino\\)$" . arduino-mode) auto-mode-alist)))
  
;; smartscan - FIXME: Why do I have this twice?
(use-package smartscan
  :init
  (global-smartscan-mode 1))

;; markdown-mode
(use-package markdown-mode
  :mode ("\\.\\(m\\(ark\\)?down\\|md\\)$" . markdown-mode)
  :config)

;; elpy - Extension for Python - https://elpy.readthedocs.io/en/latest/index.html#elpy
(use-package elpy
  :ensure t
  :init
  (elpy-enable))

;;--------------------------------------------------------------
;;
;; Verilog mode settings
;;
(autoload 'verilog-mode "verilog-mode" "Verilog mode" t )
(add-to-list 'auto-mode-alist '("\\.[ds]?vh?\\'" . verilog-mode))
(add-hook 'verilog-mode-hook
          '(lambda ()
             (setq verilog-auto-newline nil)
             (setq ggtags-mode t) ;; always run ggtags-mode in verilog mode
             ))


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
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#ebdbb2" "#9d0006" "#98971a" "#b57614" "#076678" "#d3869b" "#689d6a" "#3c3836"])
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#689d6a")
 '(cua-normal-cursor-color "#7c6f64")
 '(cua-overwrite-cursor-color "#b57614")
 '(cua-read-only-cursor-color "#98971a")
 '(custom-enabled-themes '(tango-dark))
 '(custom-safe-themes
   '("96998f6f11ef9f551b427b8853d947a7857ea5a578c75aa9c4e7c73fe04d10b4" "3d5ef3d7ed58c9ad321f05360ad8a6b24585b9c49abcee67bdcbb0fe583a6950" "b3775ba758e7d31f3bb849e7c9e48ff60929a792961a2d536edec8f68c671ca5" "9b59e147dbbde5e638ea1cde5ec0a358d5f269d27bd2b893a0947c4a867e14c1" "621595cbf6c622556432e881945dda779528e48bb57107b65d428e61a8bb7955" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default))
 '(fci-rule-color "#ebdbb2")
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
 '(linum-format " %7i ")
 '(lsp-ui-doc-border "#665c54")
 '(nrepl-message-colors
   '("#9d0006" "#af3a03" "#b57614" "#747400" "#c6c148" "#004858" "#689d6a" "#d3869b" "#8f3f71"))
 '(package-selected-packages
   '(ggtags flycheck elpy nhexl-mode dimmer dired-du sublime-themes white-sand-theme solarized-theme spacemacs-theme markdown-mode magit powerline which-key use-package smartscan neotree ivy diffview))
 '(pdf-view-midnight-colors '("#655370" . "#fbf8ef"))
 '(pos-tip-background-color "#ebdbb2")
 '(pos-tip-foreground-color "#665c54")
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
