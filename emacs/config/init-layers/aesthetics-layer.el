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

(use-package doom-modeline
  :init (setq doom-modeline-icon nil)
  :config (doom-modeline-mode 1))

;; Font configuration happens here - size is dynamic based on display resolution
(setq emacs-monospace-font-family "FiraCode")

(defun mono-font-size-from-display-resolution ()
  (progn
    (defun get-display-resolution-windows ()
      "TODO: actually implement this"
      "1920x1080")
    (defun get-display-resolution-linux ()
      (shell-command-to-string "xrandr | grep '*' | awk '{ printf $1 }'"))

    (let ((resolution (cond ((string-equal system-type "gnu/linux")
							 (get-display-resolution-linux))
							((string-equal system-type "windows-nt")
							 (get-display-resolution-windows)))))

      (cond ((string-equal resolution "3840x2160") 14)
	    ((string-equal resolution "1920x1080") 11)
	    (t 12)))))

;; Font gets set as default and applied to current frame here
(let ((emacs-default-font
	   (concat (concat emacs-monospace-font-family "-")
			   (number-to-string (mono-font-size-from-display-resolution)))))
  (add-to-list 'default-frame-alist (cons 'font emacs-default-font))
  (set-frame-font emacs-default-font nil t))

;; Set default frame size for GUI
(if (display-graphic-p)
	(let ((frame-size-params '((width . 108) (height . 42))))
	  (setq initial-frame-alist frame-size-params)
	  (setq default-frame-alist frame-size-params)))
