;; Ensure emacs sees locally-installed binaries in the user's
;; home directory, by adding the local bin to exec-path
(setq user-local-bin (concat (getenv "HOME") "/.local/bin"))
(setq exec-path (cons user-local-bin exec-path))

;; The bulk of our configuration happens in these files
(add-to-list 'load-path "~/.emacs.d/init-layers")
;;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; All configuration related to fonts and theming that we
;; want to happen before package refresh should go here
(require 'early-init-aesthetics-layer)

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

;; No manual edits below this line!
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("cf922a7a5c514fad79c483048257c5d8f242b21987af0db813d3f0b138dfaf53" "333958c446e920f5c350c4b4016908c130c3b46d590af91e1e7e2a0611f1e8c5" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" "801a567c87755fe65d0484cb2bded31a4c5bb24fd1fe0ed11e6c02254017acb2" "dbade2e946597b9cda3e61978b5fcc14fa3afa2d3c4391d477bdaeff8f5638c5" "1df2d767cc1b5ed78626f93f06c24ac15144a28b7420364769bf63cd23e420d3" "f7fed1aadf1967523c120c4c82ea48442a51ac65074ba544a5aefc5af490893b" "0d01e1e300fcafa34ba35d5cf0a21b3b23bc4053d388e352ae6a901994597ab1" "835868dcd17131ba8b9619d14c67c127aa18b90a82438c8613586331129dda63" "745d03d647c4b118f671c49214420639cb3af7152e81f132478ed1c649d4597d" "e8df30cd7fb42e56a4efc585540a2e63b0c6eeb9f4dc053373e05d774332fc13" "8d7b028e7b7843ae00498f68fad28f3c6258eda0650fe7e17bfb017d51d0e2a2" "b186688fbec5e00ee8683b9f2588523abdf2db40562839b2c5458fcfb322c8a4" "97db542a8a1731ef44b60bc97406c1eb7ed4528b0d7296997cbb53969df852d6" "3d54650e34fa27561eb81fc3ceed504970cc553cfd37f46e8a80ec32254a3ec3" "4b6b6b0a44a40f3586f0f641c25340718c7c626cbf163a78b5a399fbe0226659" "1704976a1797342a1b4ea7a75bdbb3be1569f4619134341bd5a4c1cfb16abad4" "d268b67e0935b9ebc427cad88ded41e875abfcc27abd409726a92e55459e0d01" "0466adb5554ea3055d0353d363832446cd8be7b799c39839f387abb631ea0995" "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "a0be7a38e2de974d1598cf247f607d5c1841dbcef1ccd97cded8bea95a7c7639" "5859f61b502aa335b502b231c86a051210cb5974f74966e620c31be3a966659f" "aba75724c5d4d0ec0de949694bce5ce6416c132bb031d4e7ac1c4f2dbdd3d580" default))
 '(package-selected-packages
   '(gruvbox-theme zenburn-theme leuven-theme eglot ccls lsp-ui smooth-scrolling company-lsp evil-surround lsp-mode command-log-mode tao-theme counsel evil-collection magit company org-bullets org-roam projectile general minimap ivy dashboard doom-modeline use-package evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
