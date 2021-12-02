;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "John Doe" user-mail-address "john@doe.com")

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented


;; ---------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------
;; ---------------------------------------------------------------------------------

;;(require 'treemacs-all-the-icons)
;;(treemacs-load-theme "all-the-icons")

;; (setq doom-theme 'doom-solarized-dark)
(setq doom-theme 'doom-gruvbox)
(setq doom-font (font-spec :family "Fira Code"
                           :size 9.0))
(setq doom-variable-pitch-font (font-spec :family "Fira Sans"
                                          :size 13))
(setq doom-themes-treemacs-theme "doom-colors")
;; (setq doom-themes-treemacs-enable-variable-pitch nil)

(set-face-bold-p 'bold nil)

(setq display-line-numbers-type t)
(setq projectile-auto-discover nil)
(setq projectile-track-known-projects-automatically nil)
(setq confirm-kill-emacs nil)

;; Single click to expand folders in treemacs
(with-eval-after-load 'treemacs (define-key treemacs-mode-map [mouse-1]
                                  #'treemacs-single-click-expand-action))

(map! "C-s" #'save-buffer)

(map! :nvieomrg "C-L" #'evil-force-normal-state)
(map! "C-:" #'evil-insert)
(map! "ESC" #'evil-escape)
(map! :nvieomrg "C-RET" #'recenter-top-bottom)
(map! :nvieomrg "<C-return>" #'recenter-top-bottom)

(map! :n ":" #'execute-extended-command)


(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))

(map! "C-<backspace>" #'evil-delete-backward-word)
(map! "C-/" #'comment-or-uncomment-region-or-line)

(map! :nvieomrg "C-w" #'kill-this-buffer)
(map! :nvi "C-z" #'evil-undo)
(map! :nvi "C-y" #'evil-redo)

(map! :nvi "C-v" #'evil-paste-before)

(map! :v "C-c" #'evil-yank)
(map! :ni "C-c" #'evil-collection-magit-yank-whole-line)

(map! :ni "C-x" #'kill-whole-line)
(map! :v "C-x" #'kill-region)


(defun move-text-internal (arg)
  (cond ((and
          mark-active
          transient-mark-mode)
         (if (> (point)
                (mark))
             (exchange-point-and-mark))
         (let ((column (current-column))
               (text (delete-and-extract-region (point)
                                                (mark))))
           (forward-line arg)
           (move-to-column column t)
           (set-mark (point))
           (insert text)
           (exchange-point-and-mark)
           (setq deactivate-mark nil)))
        (t (beginning-of-line)
           (when (or (> arg 0)
                     (not (bobp)))
             (forward-line)
             (when (or (< arg 0)
                       (not (eobp)))
               (transpose-lines arg))
             (forward-line -1)))))

(defun move-text-down (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines down."
  (interactive "*p")
  (move-text-internal arg))

(defun move-text-up (arg)
  "Move region (transient-mark-mode active) or current line
  arg lines up."
  (interactive "*p")
  (move-text-internal (- arg)))

(map! [(control shift up)] #'move-text-up)
(map! [(control shift down)] #'move-text-down)

(defun duplicate-line()
  (interactive)
  (move-beginning-of-line 1)
  (kill-line)
  (yank)
  (open-line 1)
  (next-line 1)
  (yank))


(map! :nvi "C-K" #'kill-whole-line)
(map! :nvi "C-D" #'duplicate-line)
(map! :nvi "C-p" #'projectile-find-file)
(map! :nvi [(control shift i)] #'treemacs-find-file)

(map! :nvi [(control meta left)]  #'centaur-tabs-backward)
(map! :nvi [(control meta right)] #'centaur-tabs-forward)

(map! :ni [(shift meta right)] #'lsp-find-definition)

(map!
 :leader
 :desc "Create project in given folder"
 :n "p n" #'projectile-add-known-project)

(map!
 :leader
 :desc "Open vterm"
 :n "o t" #'+vterm/here
 )

(map! :nvi "C-O" #'+vterm/here)

(map!
 :leader
 :desc "Open vterm popup"
 :n "o T" #'+vterm/toggle
 )


;; Smooth scrolling
;; (setq mouse-wheel-scroll-amount '(1 ((shift) . 1))) ;; one line at a time
;; (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
;; (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
;; (setq scroll-step 1) ;; keyboard scroll one line at a time

(use-package lsp-pyright
  :ensure t
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))       ; or lsp-deferred


(setq treemacs-show-hidden-files t treemacs-collapse-dirs 3 treemacs-position 'right
      treemacs-width-is-initially-locked nil)

(setq-default tab-width 4) ; emacs 23.1 to 26 default to 8
(setq tab-width 4)

;; make tab key call indent command or insert tab character, depending on cursor position
;; (setq-default tab-always-indent nil)
(defun region-line-beg ()
  (if (region-active-p)
      (save-excursion (goto-char (region-beginning)) (line-beginning-position))
    (line-beginning-position)))
(defun region-line-end ()
  (if (region-active-p)
      (save-excursion (goto-char (region-end)) (line-end-position))
    (line-end-position)))
(defun keyboard-indent (&optional arg)
  (interactive)
  (let ((deactivate-mark nil))  ; keep region
    (indent-rigidly (region-line-beg) (region-line-end) (* (or arg 1) tab-width))))
(defun keyboard-unindent (&optional arg)
  (interactive)
  (keyboard-indent (* -1 (or arg 1))))

;; (map! :nvi "TAB" #'keyboard-indent)

(map! :nvi "TAB" #'my/indent)
(map! :nvi "<tab>" #'my/indent)


(setq centaur-tabs-style "bar")
(setq centaur-tabs-height 18)
(setq centaur-tabs-set-bar 'left)
(after!
   centaur-tabs
   (centaur-tabs-change-fonts "Fira Sans Medium" 100)
   (defun centaur-tabs-buffer-groups () "" (list (cond
                ((derived-mode-p
                  'prog-mode
                  'dired-mode
                  'vterm-mode
                  'gitignore-mode
                  'gitconfig-mode
                  'gfm-mode
                  ) "Project")
        (t "Other")
    )))

   (setq centaur-tabs-buffer-groups-function #'centaur-tabs-buffer-groups)
  )

(defvar killed-file-list nil
  "List of recently killed files.")

(defun add-file-to-killed-file-list ()
  "If buffer is associated with a file name, add that file to the
`killed-file-list' when killing the buffer."
  (when buffer-file-name
    (push buffer-file-name killed-file-list)))

(add-hook 'kill-buffer-hook #'add-file-to-killed-file-list)

(defun reopen-killed-file ()
  "Reopen the most recently killed file, if one exists."
  (interactive)
  (when killed-file-list
    (find-file (pop killed-file-list))))


(map! :nvieomrg [(control shift t)] #'reopen-killed-file)

(good-scroll-mode 50)
(highlight-indent-guides-mode)

(setq lsp-semantic-tokens-enable t)
(setq lsp-clangd-binary-path "/usr/bin/clangd")


(setq good-scroll-algorithm #'good-scroll-linear)
