;; autoload is mainly for use-package
(add-to-list 'load-path "~/.emacs.d/autoload")
;; init-layers are for my init logic
(add-to-list 'load-path "~/.emacs.d/init-layers")
;; this is exactly what you'd expect
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; Ensure our package archives are up-to-date and load the
;; package manager
(require 'package)
(setq package-archives
  '(("gnu" . "https://elpa.gnu.org/packages/")
    ("melpa" . "https://melpa.org/packages/")
    ("melpa-stable" . "https://stable.melpa.org/packages/")))
(unless package-archive-contents
  (package-refresh-contents))
(package-initialize)

;; Load use-package and make sure each entry is downloaded
(require 'use-package)
(setq use-package-always-ensure t)

;; Aesthetics layer - configuration related to theming
(require 'aesthetics-layer)

;; Editing layer - configuration related to text editing
(require 'editing-layer)

;; Completion layer - configuration related to autocompletion
(require 'completion-layer)

;; General keybinds layer - general use keybindings for accessing
;; built-in emacs functionality, much of which is mapped by
;; default to C-x <keys>
(require 'general-keybinds-layer)

;; Project layer - configuration related to project management
;; through projectile
(require 'projectile-layer)

;; No manual edits below this line!
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("e8df30cd7fb42e56a4efc585540a2e63b0c6eeb9f4dc053373e05d774332fc13" "8d7b028e7b7843ae00498f68fad28f3c6258eda0650fe7e17bfb017d51d0e2a2" "b186688fbec5e00ee8683b9f2588523abdf2db40562839b2c5458fcfb322c8a4" "97db542a8a1731ef44b60bc97406c1eb7ed4528b0d7296997cbb53969df852d6" "3d54650e34fa27561eb81fc3ceed504970cc553cfd37f46e8a80ec32254a3ec3" "4b6b6b0a44a40f3586f0f641c25340718c7c626cbf163a78b5a399fbe0226659" "1704976a1797342a1b4ea7a75bdbb3be1569f4619134341bd5a4c1cfb16abad4" "d268b67e0935b9ebc427cad88ded41e875abfcc27abd409726a92e55459e0d01" "0466adb5554ea3055d0353d363832446cd8be7b799c39839f387abb631ea0995" "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "a0be7a38e2de974d1598cf247f607d5c1841dbcef1ccd97cded8bea95a7c7639" "5859f61b502aa335b502b231c86a051210cb5974f74966e620c31be3a966659f" "aba75724c5d4d0ec0de949694bce5ce6416c132bb031d4e7ac1c4f2dbdd3d580" default))
 '(package-selected-packages
   '(projectile general minimap ivy dashboard doom-modeline use-package evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
