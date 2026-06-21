;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el

;; To install a package with Doom you must declare them here and run 'doom sync'
;; on the command line, then restart Emacs for the changes to take effect -- or
;; use 'M-x doom/reload'.


;; To install SOME-PACKAGE from MELPA, ELPA or emacsmirror:
;; (package! some-package)

;; To install a package directly from a remote git repo, you must specify a
;; `:recipe'. You'll find documentation on what `:recipe' accepts here:
;; https://github.com/radian-software/straight.el#the-recipe-format
;; (package! another-package
;;   :recipe (:host github :repo "username/repo"))

;; If the package you are trying to install does not contain a PACKAGENAME.el
;; file, or is located in a subdirectory of the repo, you'll need to specify
;; `:files' in the `:recipe':
;; (package! this-package
;;   :recipe (:host github :repo "username/repo"
;;            :files ("some-file.el" "src/lisp/*.el")))

;; If you'd like to disable a package included with Doom, you can do so here
;; with the `:disable' property:
;; (package! builtin-package :disable t)

;; You can override the recipe of a built in package without having to specify
;; all the properties for `:recipe'. These will inherit the rest of its recipe
;; from Doom or MELPA/ELPA/Emacsmirror:
;; (package! builtin-package :recipe (:nonrecursive t))
;; (package! builtin-package-2 :recipe (:repo "myfork/package"))

;; Specify a `:branch' to install a package from a particular branch or tag.
;; This is required for some packages whose default branch isn't 'master' (which
;; our package manager can't deal with; see radian-software/straight.el#279)
;; (package! builtin-package :recipe (:branch "develop"))

;; Use `:pin' to specify a particular commit to install.
;; (package! builtin-package :pin "1a2b3c4d5e")


;; Doom's packages are pinned to a specific commit and updated from release to
;; release. The `unpin!' macro allows you to unpin single packages...
;; (unpin! pinned-package)
;; ...or multiple packages
;; (unpin! pinned-package another-pinned-package)
;; ...Or *all* packages (NOT RECOMMENDED; will likely break things)
;; (unpin! t)

;; Pacotes instalados
(package! pkgbuild-mode)                ; sintaxe de PKGBUILDS
(package! evil-commentary)              ; comentarios estilo vim
(package! systemd)                      ; sintaxe de arquivos do systemd + major mode
(package! evil-snipe)                   ; busca rápida de caracteres
(package! evil-indent-plus)             ; atalhos para recuo
(package! org-fancy-priorities)         ; itens de prioridades melhorados
; (package! org-super-agenda)             ; melhorias agenda
(package! engine-mode)                  ; busca no navegador
;; (package! lsp-pyright)                  ; language server pro python
(package! lsp-ui)                       ; visual helper
(package! dap-mode)                     ; integração com debug server
(package! gptel)                        ; AI Assistant (DeepSeek/OpenAI)
;; (package! python-pylint)                ; python
;; (package! python-pytest)                ; python
(package! org-tree-slide)               ; apresentações no org-mode
(package! lsp-julia)                   ; julia
(package! nix-mode)                    ; nix syntax highlighting
(package! nix-ts-mode)                 ; nix tree-sitter highlighting
;; (package! yasnippets)                   ; snippets melhores que os do DOOM
;; (package! straight :pin "3eca39d")
;; (package! chatgpt
  ;; :recipe (:host github :repo "joshcho/ChatGPT.el" :files ("dist" "*.el")))
;; Remover $HOME dos projetos
;; (package! gitconfig-mode
   ;; :recipe (:host github :repo "magit/git-modes" :files ("gitconfig-mode.el")))
;; (package! codeium :recipe (:host github :repo "Exafunction/codeium.el"))
