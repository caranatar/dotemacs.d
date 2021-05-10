;;; init.el --- Initialization file for Emacs

;;; Commentary:
;; Emacs Startup File --- initialization for Emacs

;;; Code:

(set-face-font 'default "MesloLGS NF 10")
;;;(set-face-font 'default "Compagnon 12")
(tool-bar-mode -1)
(menu-bar-mode -1)
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves/"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups
(setq create-lockfiles nil)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq-default indent-tabs-mode nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)

(use-package gruvbox-theme
  :straight t
  :load-path "themes"
  :config
  (load-theme 'gruvbox-dark-soft t)
  )

(use-package go-mode
  :straight t)

(use-package dart-mode
  :straight t)

(use-package lsp-dart
  :straight t)

(use-package hover
  :straight t)

(use-package lsp-mode
  :straight t
  :commands (lsp lsp-deferred)
  :hook ((go-mode . lsp-deferred)
         (rust-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (dart-mode . lsp-deferred)
         (elixir-mode . lsp-deferred)
         )
  :init (add-to-list 'exec-path "/home/caranatar/.elixir_ls")
  :config (setq lsp-idle-delay 0.500)
  :bind ("M-/" . lsp-goto-type-definition))

(use-package lsp-ui
  :straight t
  :commands lsp-ui-mode)

(use-package magit
  :straight t
  :bind ("C-x g" . magit-status))

(use-package ivy
  :straight t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

(use-package counsel
  :straight t
  :config
  (counsel-mode 1))

(use-package projectile
  :straight t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
	      ("s-p" . projectile-command-map)
	      ("C-c p" . projectile-command-map))
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'ivy))

(use-package smart-mode-line
  :straight t
  :config (sml/setup))

(use-package rich-minority
  :straight t
  :after smart-mode-line
  :config
  (setq rm-blacklist
      (format "^ \\(%s\\)$"
              (mapconcat #'identity
                         '("Fly.*" "Projectile.*" "PgLn" "company" "ElDoc" "counsel" "ivy")
                         "\\|"))))

(use-package ag
  :straight t
  :config
  (setq ag-highlight-search t)
  (setq ag-reuse-buffers t))

(use-package ansi-color
  :straight t
  :config
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (toggle-read-only)
      (ansi-color-apply-on-region compilation-filter-start (point-max))
      (toggle-read-only)
      ))
  :hook (compilation-filter . my-colorize-compilation-buffer))

(use-package company
  :straight t
  :config
  (global-company-mode t)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix 2)
  (setq company-tooltip-align-annotations t)
  :bind
  ("TAB" . company-indent-or-complete-common))

(use-package flycheck
  :straight t
  :init (global-flycheck-mode))

(use-package rustic
  :straight t)

(use-package org
  :init (setq org-link-frame-setup '((file . find-file)))
  :bind (:map org-mode-map
              ("M-." . org-open-at-point)))

(use-package elixir-mode
  :straight t)

(provide 'init)

;;; init.el ends here
