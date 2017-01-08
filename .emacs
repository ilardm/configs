(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (zenburn)))
 '(custom-safe-themes
   (quote
    ("f5512c02e0a6887e987a816918b7a684d558716262ac7ee2dd0437ab913eaec6" default)))
 '(ledger-post-amount-alignment-at :decimal)
 '(package-selected-packages
   (quote
    (flycheck-ledger ledger-mode lsp-python lsp-java lsp-mode zenburn-theme yasnippet virtualenvwrapper projectile markdown-mode grizzl genrnc color-theme auto-complete-nxml))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; =============================================================================

(set-frame-font "DeJaVu Sans Mono 10")

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
       (set-face-background 'hl-line "black"))))

(blink-cursor-mode 0)
(setq mouse-yank-at-point t)
(column-number-mode t)

(setq backup-directory-alist '(("." . "~/.emacs.d/saves")))

(setq display-time-day-and-date 1)
(setq display-time-mail-string "✉")
(setq display-time-default-load-average nil)
(setq display-time-format
      "%y%m%d %I:%M %p")
(display-time)

(defalias 'yes-or-no-p 'y-or-n-p)
(define-key global-map (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-j")
		'newline-and-indent)

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

(when (fboundp 'windmove-default-keybindings)
    (windmove-default-keybindings))
(global-set-key (kbd "C-c h") 'windmove-left)
(global-set-key (kbd "C-c l") 'windmove-right)
(global-set-key (kbd "C-c k") 'windmove-up)
(global-set-key (kbd "C-c j") 'windmove-down)

;; --- packages ----------------------------------------------------------------
;; http://stackoverflow.com/a/10093312

; list the packages you want
(setq package-list '(color-theme
                     ;; color-theme-solarized
                     zenburn-theme
                     popup
                     auto-complete
                     markdown-mode
                     ;; csharp-mode
                     ;; coffee-mode
                     ;; jade-mode
                     ;; less-css-mode
                     ;; concurrent         ; broken dependency of genrnc
                     ;; genrnc
                     ;; auto-complete-nxml
                     projectile
                     grizzl
                     yasnippet
                     virtualenvwrapper
                     ))

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
			 ("melpa" . "http://melpa.milkbox.net/packages/")))

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available
(when (not package-archive-contents)
  (package-refresh-contents))

; install the missing packages
(dolist (package package-list)
  (when (not (package-installed-p package))
    (package-install package)))

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

;; (add-hook 'text-mode-hook 'flyspell-mode)

;; --- development -------------------------------------------------------------
(global-set-key (kbd "<f7>") 'compile)

;; (setq whitespace-display-mappings
;;       '((space-mark   ?\    [?\xB7]     [?.])                ; space
;;         (space-mark   ?\xA0 [?\xA4]     [?_])                ; hard space
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
(projectile-global-mode)
(setq projectile-completion-system 'grizzl)

;; === extensions ==============================================================
(dolist (i (list
	    ;; ; --- cedet --------------------------------------------------------
	    ;; ; http://cedet.sourceforge.net/setup.shtml
	    ;; ; http://alexott.net/ru/writings/emacs-devenv/EmacsCedet.html
	    ;; "~/.emacs.d/cedet-bzr/contrib/"
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

     (load-theme 'zenburn)
     )))

;; --- markdown-mode -----------------------------------------------------------
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

;; ;; --- cedet configuration -----------------------------------------------------
;; ;; (load-file "~/.emacs.d/cedet-bzr/cedet-devel-load.el")
;; (add-to-list 'semantic-default-submodes 'global-semanticdb-minor-mode t)
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-scheduler-mode t)
;; ;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-completions-mode t)
;; (add-to-list 'semantic-default-submodes 'global-cedet-m3-minor-mode t)
;; (add-to-list 'semantic-default-submodes 'global-semantic-idle-local-symbol-highlight-mode)
;; (add-to-list 'semantic-default-submodes 'global-semantic-show-parser-state-mode)
;; ;; (semantic-mode 1)
;; (global-ede-mode 1)
;; (require 'semantic/ia)
;; (require 'semantic/bovine/gcc)
;; ;; (require 'semantic/db-javap)
;; ;; (require 'eassist)

;; ; kdb config
;; (defun my-cedet-kbd-hook ()
;;   (my-set-local-key (kbd "C-.")
;;                     (cons 'semantic-ia-complete-symbol-menu
;;                           'semantic-ia-complete-symbol))
;;   (my-set-local-key (kbd "C-c s l")
;;                     (my-dbl 'eassist-list-methods))
;;   (my-set-local-key (kbd "C-c s j")
;;                     (my-dbl 'semantic-ia-fast-jump))
;;   (my-set-local-key (kbd "C-c s d")
;;                     (my-dbl 'semantic-analyze-proto-impl-toggle))
;;   (my-set-local-key (kbd "C-c s D")
;;                     (my-dbl 'semantic-ia-show-doc)))

;; (add-hook 'c-mode-common-hook
;;           'my-cedet-kbd-hook)

;; ;; --- c-sharp -----------------------------------------------------------------
;; (autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
;; (setq auto-mode-alist
;;       (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))
;; (setq auto-mode-alist
;;       (append '(("\\.csproj$" . xml-mode)) auto-mode-alist))
;; (add-hook 'csharp-mode-hook 'omnisharp-mode)
;; (add-hook 'csharp-mode-hook
;;           (lambda ()
;;             (local-set-key (kbd "{") 'c-electric-brace)
;;             (local-set-key (kbd "M-.") 'omnisharp-auto-complete)
;;             ))

;; ;; --- coffeescript ------------------------------------------------------------
;; (setq coffee-tab-width 4)
;; ;; https://github.com/akfish/ac-coffee
;; (add-to-list 'load-path "~/.emacs.d/ac-coffee/")
;; (require 'ac-coffee)

;; --- xml ---------------------------------------------------------------------
(require 'genrnc)
(setq genrnc-user-schemas-directory "~/.emacs.d/schema")

(require 'auto-complete-nxml)

;; --- yasnippet ---------------------------------------------------------------
(require 'yasnippet)
;; FIXME: hardcoded path
(setq yas-snippet-dirs '( "~/.emacs.d/elpa/yasnippet-20160517.1628/snippets/" ))
(yas-global-mode 1)


;; --- python ------------------------------------------------------------------
(require 'virtualenvwrapper)
;; FIXME: hardcoded path
(setq venv-location "~/.virtualenvs/")

;; https://pylint.readthedocs.io/en/latest/user_guide/ide-integration.html
;; Configure flymake for Python
(when (load "flymake" t)
  (defun flymake-pylint-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
		       'flymake-create-temp-inplace))
	   (local-file (file-relative-name
			temp-file
			(file-name-directory buffer-file-name))))
      (list "epylint" (list
		       local-file
		       ;; epylint expects options *after* file
		       ;; FIXME: load plugins per project
		       "--load-plugins" "pylint_django"))))
  (add-to-list 'flymake-allowed-file-name-masks
	       '("\\.py\\'" flymake-pylint-init)))

;; Set as a minor mode for Python
(add-hook 'python-mode-hook '(lambda () (flymake-mode)))

;; Configure to wait a bit longer after edits before starting
(setq-default flymake-no-changes-timeout '3)

;; Keymaps to navigate to the errors
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-cln" 'flymake-goto-next-error)))
(add-hook 'python-mode-hook '(lambda () (define-key python-mode-map "\C-clp" 'flymake-goto-prev-error)))

;; To avoid having to mouse hover for the error message, these functions make flymake error messages
;; appear in the minibuffer
(defun show-fly-err-at-point ()
  "If the cursor is sitting on a flymake error, display the message in the minibuffer"
  (require 'cl)
  (interactive)
  (let ((line-no (line-number-at-pos)))
    (dolist (elem flymake-err-info)
      (if (eq (car elem) line-no)
      (let ((err (car (second elem))))
	(message "%s" (flymake-ler-text err)))))))

(add-hook 'post-command-hook 'show-fly-err-at-point)

(defadvice flymake-goto-next-error (after display-message activate compile)
  "Display the error in the mini-buffer rather than having to mouse over it"
  (show-fly-err-at-point))

(defadvice flymake-goto-prev-error (after display-message activate compile)
  "Display the error in the mini-buffer rather than having to mouse over it"
  (show-fly-err-at-point))

;; --- yasnippet ---------------------------------------------------------------
(require 'yasnippet)
(setq yas-snippet-dirs '( "~/.emacs.d/elpa/yasnippet-20160801.1142/snippets/" ))
(yas-global-mode 1)
