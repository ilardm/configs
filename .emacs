;; config changes made through the customize UI will be stored here
;; https://github.com/bbatsov/emacs.d/blob/3d3cb04bd69b05b040e7022b618f482da145e8ce/init.el#L900
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file))

;; === general config ==========================================================
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)
(global-font-lock-mode 1)
(global-hl-line-mode 1)
(blink-cursor-mode -1)
(column-number-mode t)
(show-paren-mode 1)
(electric-pair-mode t)
(global-auto-revert-mode t)
(add-hook 'text-mode-hook 'display-line-numbers-mode)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default fill-column 80)

(defalias 'yes-or-no-p 'y-or-n-p)
(define-key global-map (kbd "RET") 'newline)
(global-set-key (kbd "C-j") 'newline)

(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(setq c-basic-offset 4)
(setq tab-always-indent nil)
(setq c-tab-always-indent nil)
(setq require-final-newline 'visit-save)
(setq blink-matching-paren-distance nil)
(setq tab-always-indent 'complete)

;; let's pick a nice font
;; https://github.com/bbatsov/emacs.d/blob/3d3cb04bd69b05b040e7022b618f482da145e8ce/init.el#L90
(cond
 ((find-font (font-spec :name "DejaVu Sans Mono"))
  (set-frame-font "DejaVu Sans Mono-10"))
 ((find-font (font-spec :name "Menlo"))
  (set-frame-font "Menlo-12")))

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

;; store all backup and autosave files in the tmp dir
;; https://github.com/bbatsov/emacs.d/blob/3d3cb04bd69b05b040e7022b618f482da145e8ce/init.el#L135
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; spellcheck
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; === packages ================================================================
(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

;; --- use-package -------------------------------------------------------------
(eval-when-compile
  (require 'use-package))

;; auto-download missing packages
;; (require 'use-package-ensure)
;; (setq use-package-always-ensure t)

;; --- packages ----------------------------------------------------------------
;; (use-package zenburn-theme
;;   :config
;;   (load-theme 'zenburn t))

(use-package solarized-theme
  :init
  (setq solarized-use-variable-pitch nil)
  (setq solarized-scale-org-headlines nil)
  (setq solarized-scale-markdown-headlines nil)
  (setq x-underline-at-descent-line t)
  :config
  (load-theme 'solarized-dark t))

(use-package hl-todo
  :config
  (global-hl-todo-mode 1))

(use-package markdown-mode)
(use-package yaml-mode)
(use-package toml)
(use-package rust-mode)

(use-package magit)

(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-indexing-method 'hybrid)
  (projectile-mode +1))

(use-package ivy
  :config
  (ivy-mode 1))

(use-package rg)

(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs)

(use-package flycheck
  :config
  (add-hook 'prog-mode-hook 'flycheck-mode))

(use-package flycheck-pyflakes)

(use-package company
  :config
  (add-hook 'prog-mode-hook 'company-mode))

(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package todotxt-mode
  :bind
  ("C-c t" . todotxt-open-file)
  :init
  (defvar todotxt-due-tag "due")
  (add-to-list 'auto-mode-alist '("todo\\.txt\\'" . todotxt-mode))
  (add-to-list 'auto-mode-alist '("done\\.txt\\'" . todotxt-mode)))


(use-package ledger-mode)

;; --- beancount ---------------------------------------------------------------
(use-package beancount
  :load-path (lambda () (expand-file-name "packages-ext/beancount-mode/" user-emacs-directory))
  :init
  (add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode))
  (add-hook 'beancount-mode-hook 'outline-minor-mode))

;; --- org-mode ----------------------------------------------------------------
(use-package uuidgen)

;; visit org file, M-x org-agenda-file-to-front, visit ~/.emacs.d/custom.el,
;; edit files to a single directory
(global-set-key (kbd "C-c a") #'org-agenda)
(setq org-startup-indented t)
(setq org-tags-column 0)
(setq org-agenda-span 14)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq calendar-week-start-day 1)
(setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
