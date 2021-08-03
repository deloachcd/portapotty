(provide 'projectile-layer)

(use-package projectile
  :init (setq projectile-project-search-path '("~")
	      projectile-completion-system 'ivy)
  :config (projectile-mode 1))

(general-create-definer projectile-bindings
  :prefix "SPC p"
  :states '(normal emacs)
  :keymaps 'override)
(projectile-bindings
 "f" 'projectile-find-file
 "p" 'projectile-switch-project)
