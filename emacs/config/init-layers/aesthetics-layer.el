(provide 'aesthetics-layer)

;; Load our theme properly now that we have a full GUI
(load-theme 'zenburn t)

;; Splash screen displayed on startup
(use-package dashboard
  :init
  (setq dashboard-startup-banner "~/.emacs.d/res/img/zenmacs.png")
  (setq dashboard-center-content t)
  (setq dashboard-set-footer nil)
  (setq dashboard-items '((recents . 5)
                          (projects . 5)))
  :config
  (dashboard-setup-startup-hook))

(use-package doom-modeline
  :init (setq doom-modeline-icon nil)
  :config (doom-modeline-mode 1))
