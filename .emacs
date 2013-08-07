;; =============================================================================
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("dd4db38519d2ad7eb9e2f30bc03fba61a7af49a185edfd44e020aa5345e3dca7" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; === emacs wiki stuff ========================================================
; --- misc functions -----------------------------------------------------------
(defun my-dbl (x)
  (cons x x))
(defun my-is-x-window-ret ( w-nw )
  (if (eq window-system nil)
      (cdr w-nw)
    (car w-nw)))
(defun my-set-local-key ( k w-nw )
  (local-set-key k (my-is-x-window-ret w-nw)))

; --- configs ----------------------------------------------------------------
(tool-bar-mode -1)
(menu-bar-mode -1)
(set-scroll-bar-mode 'right)
(scroll-bar-mode -1)
(setq inhibit-startup-message t)
(global-font-lock-mode 1)
(global-hl-line-mode 1)
(if (eq window-system nil)
    ((lambda ()
       (set-face-background 'hl-line "white")
       (set-face-foreground 'hl-line "black"))))

(blink-cursor-mode 0)
(setq mouse-yank-at-point t)
(column-number-mode t)

(setq backup-directory-alist '(("." . "~/.emacs.d/saves")))

(setq display-time-day-and-date 1)
(setq display-time-mail-string "✉")
(setq display-time-default-load-average nil)
(setq display-time-format
      "%Y-%m-%d %I:%M %p")
(display-time)

(defalias 'yes-or-no-p 'y-or-n-p)
(define-key global-map (kbd "RET") 'newline-and-indent)

(add-hook 'text-mode-hook 'auto-fill-mode)
(add-hook 'html-mode-hook (lambda ()
                            (auto-fill-mode -1)))

(add-hook 'prog-mode-hook
          (lambda ()
            (font-lock-add-keywords nil
                                    '(("\\<\\(FIXME\\|TODO\\):" 1 'font-lock-warning-face prepend)
                                      ("\\<\\(and\\|or\\|not\\)\\>" .
                                       'font-lock-keyword-face)))))

(electric-pair-mode t)

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

;; --- flyspell ----------------------------------------------------------------
(let ((langs '("american"
               "russian")))
  (setq lang-ring
        (make-ring (length langs)))
  (dolist (elem langs)
    (ring-insert lang-ring
                 elem)))

(defun cycle-ispell-languages ()
  (interactive)
  (let ((lang (ring-ref lang-ring -1)))
    (ring-insert lang-ring lang)
    (ispell-change-dictionary lang)))

(global-set-key (kbd "<f6>")
                'cycle-ispell-languages)

(add-hook 'text-mode-hook 'flyspell-mode)

;; --- development -------------------------------------------------------------
(global-set-key (kbd "<f7>") 'compile)

;; (setq whitespace-display-mappings
;;       '((space-mark   ?\    [?\xB7]     [?.])	        ; space
;;         (space-mark   ?\xA0 [?\xA4]     [?_])	        ; hard space
;;         (newline-mark ?\n   [?\xB6 ?\n] [?$ ?\n])	; end-of-line
;;         (tab-mark     ?\t   [?\xBB ?\t] [?\\ ?\t])	; tab
;;         ))
;; ;; TODO: ⏎
;; (if (not (eq window-system nil))
;;     (add-hook 'c-mode-common-hook 'whitespace-mode))

(setq c-default-style "bsd")

(setq-default indent-tabs-mode nil)
(setq tab-width 4)
(setq c-basic-offset 4)
(setq tab-always-indent nil)
(setq c-tab-always-indent nil)
(setq require-final-newline 't)
(show-paren-mode 1)
(setq blink-matching-paren-distance nil)

;; === extensions ==============================================================
(dolist (i (list ; --- color-theme ---------------------------------------------
            ; http://download.savannah.gnu.org/releases/color-theme/
            "~/.emacs.d/color-theme-6.6.0/"
            ; --- color-theme-solarized ----------------------------------------
            ; git://github.com/sellout/emacs-color-theme-solarized.git
            "~/.emacs.d/emacs-color-theme-solarized/"
            ; --- color-theme-zenburn ------------------------------------------
            ; https://github.com/bbatsov/zenburn-emacs.git
            "~/.emacs.d/zenburn-emacs/"
            ; --- cedet --------------------------------------------------------
            ; http://cedet.sourceforge.net/setup.shtml
            ; http://alexott.net/ru/writings/emacs-devenv/EmacsCedet.html
            "~/.emacs.d/cedet-bzr/contrib/"
            ; --- popup --------------------------------------------------------
            ; git://github.com/auto-complete/popup-el.git
            "~/.emacs.d/popup-el/"
            ;; --- auto-complete -----------------------------------------------
            ;; git://github.com/auto-complete/auto-complete.git
            "~/.emacs.d/auto-complete/"
            ;; --- markdown-mode -----------------------------------------------
            ;; git://jblevins.org/git/markdown-mode.git
            "~/.emacs.d/markdown-mode/"
            ;; --- c-sharp-mode ------------------------------------------------
            ;; http://code.google.com/p/csharpmode/
            "~/.emacs.d/csharp/"
            ))
  (add-to-list 'load-path i))

;; --- color-theme -------------------------------------------------------------
(require 'color-theme)
(color-theme-initialize)
(if (eq window-system nil)
    ((lambda ()
       (color-theme-clarity)))
  ((lambda ()
     ;; (require 'color-theme-solarized)
     ;; (color-theme-solarized-dark)
     
     (add-to-list 'custom-theme-load-path "~/.emacs.d/zenburn-emacs/")
     (load-theme 'zenburn)
     )))

;; --- markdown-mode
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist
      (cons '("\\.md" . markdown-mode)
            auto-mode-alist))

;; --- popup -------------------------------------------------------------------
(require 'popup)

;; --- auto-complete -----------------------------------------------------------
(require 'auto-complete-config)
(ac-config-default)

;; --- cedet configuration -----------------------------------------------------
(load-file "~/.emacs.d/cedet-bzr/cedet-devel-load.el")
(add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode t)
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode t)
(add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode t)
(add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
(add-to-list 'semantic-default-submodes 'global-semantic-show-parser-state-mode)
(semantic-mode 1)
(global-ede-mode 1)
(require 'semantic/ia)
(require 'semantic/bovine/gcc)
(require 'semantic/db-javap)
(require 'eassist)

; kdb config
(defun my-cedet-kbd-hook ()
  (my-set-local-key (kbd "C-.")
                    (cons 'semantic-ia-complete-symbol-menu
                          'semantic-ia-complete-symbol))
  (my-set-local-key (kbd "C-c s l")
                    (my-dbl 'eassist-list-methods))
  (my-set-local-key (kbd "C-c s j")
                    (my-dbl 'semantic-ia-fast-jump))
  (my-set-local-key (kbd "C-c s d")
                    (my-dbl 'semantic-analyze-proto-impl-toggle))
  (my-set-local-key (kbd "C-c s D")
                    (my-dbl 'semantic-ia-show-doc)))

(add-hook 'c-mode-common-hook
          'my-cedet-kbd-hook)

;; --- c-sharp -----------------------------------------------------------------
(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))
(setq auto-mode-alist
      (append '(("\\.csproj$" . xml-mode)) auto-mode-alist))

;; --- coffeescript ------------------------------------------------------------
(setq coffee-tab-width 4)
