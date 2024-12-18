;; config changes made through the customize UI will be stored here
;; https://github.com/bbatsov/emacs.d/blob/3d3cb04bd69b05b040e7022b618f482da145e8ce/init.el#L900

;; set custom file path, but do not evaluate it: customize variables and move it
;; to the appropriate package config section
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))

;; (when (file-exists-p custom-file)
;;   (load custom-file))

;; === general config ==========================================================
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-font-lock-mode 1)
(global-hl-line-mode 1)
(blink-cursor-mode -1)
(column-number-mode t)
(show-paren-mode 1)
(electric-pair-mode t)
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(defalias 'yes-or-no-p 'y-or-n-p)
(define-key global-map (kbd "RET") 'newline)
(global-set-key (kbd "C-j") 'newline)

(setq c-basic-offset 4)
(setq c-tab-always-indent nil)

;; let's pick a nice font
;; https://github.com/bbatsov/emacs.d/blob/3d3cb04bd69b05b040e7022b618f482da145e8ce/init.el#L90
(cond
 ((find-font (font-spec :name "DejaVuSansM Nerd Font"))
  (set-frame-font "DejaVuSansM Nerd Font-10"))
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

(add-hook 'text-mode-hook 'auto-fill-mode)

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
(use-package emacs
  :demand t
  :custom
  (inhibit-startup-screen t)
  (indent-tabs-mode nil)
  (tab-always-indent nil)
  (tab-width 4)
  (fill-column 80)
  (truncate-lines t)
  (require-final-newline t)
  (blink-matching-paren-distance nil)
  (global-display-line-numbers-mode t)
  (display-line-numbers-type 'relative)
  (custom-safe-themes '("fee7287586b17efbfda432f05539b58e86e059e78006ce9237b8732fde991b4c"
                        "4c56af497ddf0e30f65a7232a8ee21b3d62a8c332c6b268c81e9ea99b11da0d3"
                        default)))

;; (use-package zenburn-theme
;;   :config
;;   (load-theme 'zenburn t))

(use-package solarized-theme
  :custom
  (solarized-use-variable-pitch nil)
  (solarized-scale-org-headlines nil)
  (solarized-scale-markdown-headlines nil)
  (x-underline-at-descent-line t)
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
  (add-hook 'prog-mode-hook 'company-mode)
  :custom
  (company-transformers '(company-sort-by-occurrence)))

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

(use-package org
  :bind
  ("C-c a" . org-agenda)
  :custom
  ;; visit org file, M-x org-agenda-file-to-front, visit ~/.emacs.d/custom.el,
  ;; edit files to a single directory
  (org-agenda-files '("~/doc/org-notes/tasks.org"))
  (org-agenda-span 14)
  (org-agenda-skip-scheduled-if-done t)
  (org-agenda-skip-deadline-if-done t)
  (org-agenda-skip-deadline-prewarning-if-scheduled t)
  (org-startup-indented t)
  (org-tags-column 0)
  (calendar-week-start-day 1)
  (org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id))

(use-package org-roam
  :after org
  :custom
  (org-roam-directory "~/doc/org-notes/")
  (org-roam-file-exclude-regexp '(".stversions/"))
  (org-roam-db-autosync-mode t)
  (org-roam-node-display-template "${title} :: ${file}")
  (org-roam-extract-new-file-path "${slug}.org")
  (org-roam-capture-templates
   '(("w" "work note" plain "%?" :target
      (file+head "i3d/${slug}.org" "#+title: ${title}")
      :unnarrowed t)
     ("d" "default" plain "%?" :target
      (file+head "${slug}.org" "#+title: ${title}")
      :unnarrowed t)))
  (org-roam-dailies-directory "")
  (org-roam-dailies-capture-templates
   '(("W" "i3d weekly" entry "* %<%Y-%m-%d %H:%M> %?" :target
      (file+head "i3d/weekly/%<%Y>/%<%Y-w%W>.org" "#+title: %<%Y - w%W>")
      nil nil)
     ("d" "default" entry "* %?" :target
      (file+head "daily/%<%Y>/%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>")
      nil nil))))

(use-package org-roam-ui
  :after org-roam)
