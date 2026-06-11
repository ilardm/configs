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

  (windmove-default-keybindings)
  (windmove-swap-states-default-keybindings)

  :custom
  (source-directory (expand-file-name "~/downloads/src/emacs-30.2/"))

  (inhibit-startup-screen t)
  (tool-bar-mode nil)
  (menu-bar-mode nil)
  (scroll-bar-mode nil)
  (blink-cursor-mode nil)
  (shift-select-mode nil)

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
  (visual-line-fringe-indicators '(nil right-curly-arrow))
  (require-final-newline t)
  (show-trailing-whitespace t)

  (fill-column 80)

  (global-hl-line-mode t)
  (global-hl-line-sticky-flag t)

  (tab-width 4)

  (custom-safe-themes
   ; solarized dark/light
   '("7fea145741b3ca719ae45e6533ad1f49b2a43bf199d9afaee5b6135fd9e6f9b8"
     "2b0fcc7cc9be4c09ec5c75405260a85e41691abb1ee28d29fcd5521e4fca575b"
     default))

  :hook
  (text-mode . visual-line-mode)
  (text-mode . visual-wrap-prefix-mode)
  (text-mode . flyspell-mode)
  (prog-mode . display-fill-column-indicator-mode))

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
  :custom
  (global-hl-todo-mode 1))

(use-package indent-bars
  :custom
  (indent-bars-prefer-character t)
  :hook prog-mode)

(use-package markdown-mode)

(defun my-yaml-mode-hook ()
  (setq tab-width 2))

(use-package yaml-ts-mode
  :hook (yaml-ts-mode . my-yaml-mode-hook))

(use-package adoc-mode)

(use-package rust-mode)

(use-package magit
  :custom
  (magit-log-margin '(t "%Y-%m-%d %H:%M " magit-log-margin-width t 18)))

(use-package icomplete
  :custom
  (icomplete-mode t)
  (icomplete-vertical-mode t)
  (completion-styles '(basic flex)))

(use-package rg
  :custom
  (grep-command "rg")
  (xref-search-program 'ripgrep))

(use-package treesit
  :custom
  (treesit-font-lock-level 3))

(use-package treesit-auto
  :demand t
  :custom
  (treesit-auto-install 'prompt)
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package flymake
  :hook prog-mode
  :bind
  ("C-c ! n" . flymake-goto-next-error))

(use-package company
  :hook prog-mode
  :custom
  (company-transformers '(company-sort-by-occurrence)))

(use-package rainbow-delimiters
  :hook prog-mode)

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
  (org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)
  (org-babel-load-languages '((emacs-lisp . t)
                              (shell . t)))
  (org-icalendar-include-todo 'all))

(use-package org-roam
  :after org
  :bind (("C-c r t" . org-roam-dailies-goto-today)
         ("C-c r c" . org-roam-dailies-capture-today))
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
      (file+head "notes/${slug}.org" "#+title: ${title}")
      :unnarrowed t)))
  (org-roam-dailies-directory "")
  (org-roam-dailies-capture-templates
   '(("W" "i3d weekly" entry "* %<%Y-%m-%d %H:%M> %?" :target
      (file+head "i3d/weekly/%<%Y>/%<%Y-w%W>.org" "#+title: %<%Y - w%W>")
      nil nil))))

(use-package org-roam-ui
  :after org-roam)

(use-package js
  :mode "\\.mjs\\'")

(use-package poetry
  :after python
  :custom
  (poetry-tracking-mode t)
  (poetry-tracking-strategy 'project))

(use-package direnv
  :custom
  (direnv-mode t))

(defun my-go-mode-hook ()
  (setq tab-width 4
        indent-tabs-mode t))

(use-package go-mode
  :hook (go-mode . my-go-mode-hook))

(use-package elfeed
  :custom
  (elfeed-search-filter "@7-days-ago +unread")
  (elfeed-sort-order 'ascending)
  (shr-fill-text t)
  (shr-use-colors nil)
  (shr-use-fonts nil)
  (shr-width 80))

(use-package elfeed-org
  :demand t
  :after elfeed
  :custom
  (rmh-elfeed-org-files (list (expand-file-name "feeds.org" "~/.elfeed/")))
  :config
  (elfeed-org))

(use-package server
  :demand t
  :config
  ;; use "emacsclient -c" whenever possible
  (unless (server-running-p)
    (server-start)))
