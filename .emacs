;; === general config ==========================================================
(setq-default indent-tabs-mode nil)
(setq c-basic-offset 'set-from-style)
(setq tab-always-indent nil)
(setq c-tab-always-indent nil)
(setq tab-always-indent 'complete)

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
  (require 'use-package)
  (require 'use-package-ensure))

(use-package use-package
  :custom
  (use-package-always-defer t)
  (use-package-compute-statistics t))

;; --- packages ----------------------------------------------------------------
(use-package emacs
  :demand t
  :config
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  :custom
  (inhibit-startup-screen t)
  (tool-bar-mode nil)
  (menu-bar-mode nil)
  (scroll-bar-mode nil)
  (blink-cursor-mode nil)

  (completion-ignore-case t)
  (read-file-name-completion-ignore-case t)
  (read-buffer-completion-ignore-case t)
  (use-short-answers t)

  (column-number-mode t)
  (global-display-line-numbers-mode t)
  (display-line-numbers-type 'visual)

  (show-paren-mode t)
  (electric-pair-mode t)
  (blink-matching-paren-distance nil)
  (global-font-lock-mode t)
  (global-auto-revert-mode t)

  (truncate-lines t)
  (require-final-newline t)

  (fill-column 80)
  (global-display-fill-column-indicator-mode t)
  (global-hl-line-mode t)
  (global-hl-line-sticky-flag t)

  (tab-width 4)

  (custom-safe-themes
   ; solarized dark/light
   '("7fea145741b3ca719ae45e6533ad1f49b2a43bf199d9afaee5b6135fd9e6f9b8"
     "2b0fcc7cc9be4c09ec5c75405260a85e41691abb1ee28d29fcd5521e4fca575b"
     default)))

(use-package solarized-theme
  :demand t
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

(use-package icomplete
  :custom
  (icomplete-mode t)
  (icomplete-vertical-mode t)
  (completion-styles '(basic flex)))


(use-package rg)

(use-package tree-sitter
  :config
  (global-tree-sitter-mode)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs)


(use-package flymake
  :hook prog-mode
  :bind
  ("C-c ! n" . flymake-goto-next-error))

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
