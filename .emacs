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
  ;; (use-package-always-ensure t)
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
  ;; https://ftp.gnu.org/gnu/emacs/emacs-30.2.tar.gz
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
  (completion-styles '(substring flex)))

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
  :load-path "packages-ext/todotxt-mode/"
  :bind
  ("C-c t" . todotxt-open-file)
  :mode ("todo\\.txt\\'" "done\\.txt\\'")
  :init
  (defvar todotxt-due-tag "due"))


(use-package ledger-mode)

;; --- beancount ---------------------------------------------------------------
(use-package beancount
  ;; git@github.com:beancount/beancount-mode.git
  :load-path "packages-ext/beancount-mode/"
  :mode "\\.beancount\\'"
  :hook (beancount-mode . outline-minor-mode))


;; --- org-mode ----------------------------------------------------------------
(use-package org
  :bind
  (("C-c a" . org-agenda)
   ("C-c s l" . org-store-link))
  :custom
  ;; visit org file, M-x org-agenda-file-to-front, visit ~/.emacs.d/custom.el,
  ;; edit files to a single directory
  (org-agenda-files '("~/doc/org-notes/19700101T000006--tasks.org"))
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


(defun my-denote-today-journal ()
  (interactive)
  (let* ((title (format-time-string "%Y-w%W"))
         (journal-regex (concat "--" title))
         (journal-file (car (denote-directory-files journal-regex))))
    (if journal-file
        (find-file journal-file)
      (let ((denote-use-title title)
            (denote-use-directory
             (expand-file-name
              (concat "journal/" (format-time-string "%Y"))
              denote-directory))
            (denote-use-template (alist-get 'weekly denote-templates)))
        (call-interactively #'denote)))))

(use-package f
  ;; f-read-text for denote templates
  :demand t)

(use-package denote
  :after f
  :demand t
  :bind
  (("C-c d t" . my-denote-today-journal)
   ("C-c d o" . denote-open-or-create)
   ("C-c d l" . denote-link-or-create))
  :custom
  (denote-directory "~/doc/org-notes/")
  (denote-prompts '(title template keywords subdirectory))
  (denote-rename-buffer-mode t)
  (denote-org-store-link-to-heading 'id)
  (denote-templates
   '((weekly . (lambda () (f-read-text (expand-file-name "journal/template.org" denote-directory)))))))


(use-package js
  :mode "\\.mjs\\'")

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
