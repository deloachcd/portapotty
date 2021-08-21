;; I put this stuff in early-init.el just to prevent the default
;; white screen from flashing for a split second during startup

;; Disable GUI toolbars
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)

;; Slight padding for content in frame
(set-fringe-mode 10)

;; Load theme from ~/.emacs.d/themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
(load-theme 'zenburn t)
