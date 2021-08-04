(provide 'aesthetics-layer)

;; GUI toolbars should already be disabled by the time we load
;; this layer, so we don't need to do it here

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
