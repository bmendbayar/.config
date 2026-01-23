;;; init.el --- Emacs configuration inspired by Neovim  -*- lexical-binding: t; -*-

;; -------------------------------------------------------------------------
;; 1. PACKAGE MANAGER SETUP
;; -------------------------------------------------------------------------
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Bootstrap 'use-package' (built-in in Emacs 29+)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile (require 'use-package))
(setq use-package-always-ensure t)

;; -------------------------------------------------------------------------
;; 2. BASIC UI & SETTINGS (vim.opt equivalents)
;; -------------------------------------------------------------------------

;; opt.guicursor = "" (Disable blinking cursor in some contexts, simplified here)
(blink-cursor-mode -1)

;; opt.number & opt.relativenumber
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; opt.colorcolumn = "80"
(use-package display-fill-column-indicator
  :hook (prog-mode . display-fill-column-indicator-mode)
  :custom (display-fill-column-indicator-column 80))

;; opt.termguicolors (Emacs defaults to 24bit in GUI, tty needs support)
(set-term-mlint-string "") 

;; opt.ignorecase
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; opt.autoindent / smartindent / expandtab
(setq-default indent-tabs-mode nil) ; expandtab
(setq-default tab-width 4)          ; tabstop
(setq-default c-basic-offset 4)     ; shiftwidth (for C/C++)

;; opt.wrap = false
(setq-default truncate-lines t)

;; opt.scrolloff = 8
(setq scroll-margin 8)

;; opt.undodir / opt.undofile
(use-package undo-fu)      ; Better undo logic
(use-package undo-fu-session ; Persistent undo history
  :config
  (setq undo-fu-session-directory (expand-file-name "undo-fu-session" user-emacs-directory))
  (global-undo-fu-session-mode))

;; opt.swapfile = false
(setq make-backup-files nil)
(setq auto-save-default nil)

;; opt.clipboard = "unnamed"
(setq select-enable-clipboard t)

;; opt.list = true (whitespace visualization)
(setq-default show-trailing-whitespace t)

;; -------------------------------------------------------------------------
;; 3. EVIL MODE (Vim Bindings)
;; -------------------------------------------------------------------------
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil) ; Required for evil-collection
  (setq evil-undo-system 'undo-fu)
  :config
  (evil-mode 1)
  ;; Map ; to : like your config
  (define-key evil-motion-state-map ";" 'evil-ex)
  (define-key evil-motion-state-map ":" 'evil-repeat-find-char))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; -------------------------------------------------------------------------
;; 4. THEME (Gruber Darker)
;; -------------------------------------------------------------------------
(use-package gruber-darker-theme
  :config
  (load-theme 'gruber-darker t)
  ;; Custom highlights to match your color_my_pencils
  (set-face-attribute 'font-lock-comment-face nil :slant 'normal) ; No italics
  (set-face-attribute 'font-lock-string-face nil :slant 'normal))

;; -------------------------------------------------------------------------
;; 5. COMPLETION (The "Mason/Blink/LSP" Stack)
;; -------------------------------------------------------------------------

;; VERTICO + CONSULT (Replaces Telescope)
(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult) ; Provides the "grep", "find", "buffer" commands

;; CORFU (Replaces Blink.cmp)
(use-package corfu
  :init
  (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.5) ; 500ms
  (corfu-cycle t)
  (corfu-quit-no-match 'separator))

;; -------------------------------------------------------------------------
;; 6. LSP (Language Server Protocol)
;; -------------------------------------------------------------------------
;; Using Eglot (Built-in to Emacs 29), lighter than lsp-mode
(use-package eglot
  :hook ((lua-mode . eglot-ensure)
         (c-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (python-mode . eglot-ensure)
         (bash-ts-mode . eglot-ensure)
         (rust-mode . eglot-ensure))
  :config
  ;; Turn off semantic highlighting (lsp_color_off)
  (add-to-list 'eglot-ignored-server-capabilities :semanticTokensProvider))

;; Language Modes
(use-package lua-mode)
(use-package cmake-mode)
(use-package rust-mode)
(use-package markdown-mode)

;; -------------------------------------------------------------------------
;; 7. FORMATTING (Conform equivalent)
;; -------------------------------------------------------------------------
(use-package apheleia
  :config
  (apheleia-global-mode +1)
  ;; Apheleia automatically detects clang-format, stylua, etc.
  )

;; -------------------------------------------------------------------------
;; 8. GIT (Gitsigns equivalent)
;; -------------------------------------------------------------------------
(use-package git-gutter
  :config
  (global-git-gutter-mode +1)
  (custom-set-variables
   '(git-gutter:modified-sign "~")
   '(git-gutter:added-sign "+")
   '(git-gutter:deleted-sign "_")))

;; -------------------------------------------------------------------------
;; 9. EXTRA PLUGINS
;; -------------------------------------------------------------------------

;; Zen Mode
(use-package writeroom-mode
  :custom (writeroom-width 100))

;; Harpoon equivalent
(use-package harpoon
  :config
  ;; We map these in the Keymaps section
  )

;; -------------------------------------------------------------------------
;; 10. KEYMAPPINGS (general.el)
;; -------------------------------------------------------------------------
(use-package general
  :config
  (general-create-definer my-leader-def
    :prefix "SPC")

  (my-leader-def
    :states '(normal visual)
    ;; File / Buffer Management
    "w"   '(save-buffer :which-key "save")
    "q"   '(kill-current-buffer :which-key "quit buffer")
    "Q"   '(save-buffers-kill-terminal :which-key "quit emacs")
    "ex"  '(dired-jump :which-key "explore") ; Like <Leader>ex

    ;; Telescope Equivalents (Consult)
    "ff"  '(consult-find :which-key "find files") ; or consult-fd
    "fg"  '(consult-ripgrep :which-key "grep")
    "fh"  '(consult-apropos :which-key "help tags")
    "bb"  '(consult-buffer :which-key "buffers") ; <leader><leader> replacement
    "fc"  '(lambda () (interactive) (find-file user-init-file) :which-key "config")

    ;; Git
    "hb"  '(git-gutter:popup-hunk :which-key "blame line") ; approximate

    ;; Zen Mode
    "zz"  '(writeroom-mode :which-key "toggle zen")

    ;; Harpoon Replacement (Your custom Arglist logic)
    "a"   '(harpoon-add-file :which-key "harpoon add")
    "d"   '(harpoon-delete-item :which-key "harpoon delete")
    "l"   '(harpoon-toggle-file :which-key "harpoon menu")
    
    ;; LSP
    "cf"  '(apheleia-format-buffer :which-key "format")
    "rn"  '(eglot-rename :which-key "rename")
    "ca"  '(eglot-code-actions :which-key "code action")
    )

  ;; Harpoon Navigation (Ctrl-h/j/k/l)
  (general-define-key
   :states '(normal)
   "C-h" 'harpoon-go-to-1
   "C-j" 'harpoon-go-to-2
   "C-k" 'harpoon-go-to-3
   "C-l" 'harpoon-go-to-4)

  ;; LSP Navigation (Go to Definition, etc)
  (general-define-key
   :states '(normal)
   "gd" 'xref-find-definitions
   "gD" 'xref-find-definitions-other-window
   "K"  'eldoc-doc-buffer ; Hover equivalent
   )
  )

(provide 'init)
