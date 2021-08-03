(provide 'aesthetics-layer)

;; Disable GUI toolbars
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)

;; Splash screen displayed on startup
(use-package dashboard
  :init
  (setq dashboard-startup-banner 'official)
  (setq dashboard-center-content t)
  (setq dashboard-set-footer nil)
  (setq dashboard-items '((recents . 5)
			  (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

;; I use a few DOOM emacs packages to simplify configuration
(use-package doom-themes
  :config
  (load-theme 'doom-homage-white t))

;;(use-package all-the-icons) <= use this if fancy icons are desired
(use-package doom-modeline
  :init (setq doom-modeline-icon nil)
  :config (doom-modeline-mode 1))
