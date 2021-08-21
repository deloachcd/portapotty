;; Ensure emacs sees locally-installed binaries in the user's
;; home directory, by adding the local bin to exec-path
(setq user-local-bin (concat (getenv "HOME") "/.local/bin"))
(setq exec-path (cons user-local-bin exec-path))

;; The bulk of our configuration happens in these files
(add-to-list 'load-path "~/.emacs.d/init-layers")

;; Font configuration and default frame sizing happens here
(require 'font-frame-scaling-layer)

;; Some pastebin code that's supposed to speed up startup
;; through roiding up the garbage collector or something
(setq startup/gc-cons-threshold gc-cons-threshold)
(setq gc-cons-threshold most-positive-fixnum)
(defun startup/reset-gc () (setq gc-cons-threshold startup/gc-cons-threshold))
(add-hook 'emacs-startup-hook 'startup/reset-gc)

;; Ensure our package archives are up-to-date and load the
;; package manager
(require 'package)
(setq package-archives
      '(("gnu" . "https://elpa.gnu.org/packages/")
        ("melpa" . "https://melpa.org/packages/")
        ("melpa-stable" . "https://stable.melpa.org/packages/")
        ("elpa" . "https://elpa.gnu.org/packages/")))
(unless package-archive-contents
  (package-refresh-contents))
(package-initialize)

;; Load use-package and make sure each entry is downloaded
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Aesthetics layer - configuration related to theming & fonts
(require 'aesthetics-layer)

;; Editing layer - configuration related to text editing
(require 'editing-layer)

;; Minibuffer completion layer - autocompletion in minibuffer
(require 'minibuffer-completion-layer)

;; IDE layer - configuration for emacs to act as an IDE, with
;;             lsp-mode and language-specific configuration
;;             done here
(require 'ide-layer)

;; General keybinds layer - general use keybindings for accessing
;; built-in emacs functionality, much of which is mapped by
;; default to C-x <keys>
(require 'general-keybinds-layer)

;; Project layer - configuration related to project management
;; through projectile
(require 'projectile-layer)

;; Org layer - configuration related to org-mode
(require 'org-layer)

;; Magit layer - configuration related to git integration
(require 'magit-layer)

;; I lifted some code from DOOM emacs to disable customize, because they're
;; right on the money about `customize' being "a clumsy interface that
;; sets variables at a time where it can be easily and unpredictably
;; overwritten."
;;
;; All configuration should be done from this file or one of its layers.
(dolist (sym '(customize-option customize-browse customize-group customize-face
                                customize-rogue customize-saved customize-apropos
                                customize-changed customize-unsaved customize-variable
                                customize-set-value customize-customized customize-set-variable
                                customize-apropos-faces customize-save-variable
                                customize-apropos-groups customize-apropos-options
                                customize-changed-options customize-save-customized))
  (put sym 'disabled "This emacs doesn't support `customize', configure Emacs from ~/.emacs.d/ instead"))
(put 'customize-themes 'disabled "Not supported, use `load-theme' instead")
