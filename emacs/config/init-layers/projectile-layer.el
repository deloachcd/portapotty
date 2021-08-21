(provide 'projectile-layer)

(use-package projectile
  :init (setq projectile-project-search-path '("~"
                                               "~/Projects"
                                               "~/Sync/Documents/org")
              projectile-completion-system 'ivy)
  :config (projectile-mode 1))

;; Use projectile for packages to find project root,
;; rather than project.el
(defun projectile-project-find-function (dir)
  (let* ((root (projectile-project-root dir)))
    (and root (cons 'transient root))))

(with-eval-after-load 'project
  (add-to-list 'project-find-functions 'projectile-project-find-function))

(general-create-definer projectile-bindings
  :prefix "SPC p"
  :states '(normal emacs)
  :keymaps 'override)
(projectile-bindings
  "f" 'projectile-find-file
  "s" 'projectile-switch-project)
