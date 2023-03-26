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

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default fill-column 80)

(defalias 'yes-or-no-p 'y-or-n-p)
(define-key global-map (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-j") 'newline-and-indent)

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

;; === packages ================================================================
(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/"))

(package-initialize)

(eval-when-compile
  (require 'use-package))

(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package zenburn-theme
  :config
  (load-theme 'zenburn t))

(use-package hl-todo
  :config
  (global-hl-todo-mode 1))

(use-package markdown-mode)
(use-package yaml-mode)
(use-package toml)
(use-package rust-mode)

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

;; --- beancount ---------------------------------------------------------------
(add-to-list 'load-path
             (expand-file-name "packages-ext/beancount-mode/" user-emacs-directory))
(require 'beancount)
(add-to-list 'auto-mode-alist
             '("\\.beancount\\'" . beancount-mode))
(add-hook 'beancount-mode-hook 'outline-minor-mode)
