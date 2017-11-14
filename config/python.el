;;; config/python.el --- Customiztions for Python
;;
;; Copyright (C) Akash Jain
;;
;; Author: Akash Jain <ajainphysx@gmail.com>
;; Keywords: definitions, user defined functions
;; Homepage: https://ajainphysics.com
;;
;; This file is part of an emacs configuration.
;;

;;; Commentary:
;;
;; This file contains customizations for Python using package Elpy and related
;; dependencies.
;;

;;; Code:

(require 'config/definitions (locate-user-emacs-file "config/definitions.el"))

;; ========== Frame Sizing =====================================================

(add-hook 'python-mode-hook
	  (lambda ()
	    (modify-frame-parameters nil '((fullscreen . maximized)))))

;; ========== Elpy =============================================================

(require 'elpy)

(elpy-enable)

(setq elpy-rpc-python-command "/usr/bin/python3.6")

(when *system-darwin*
  (setq elpy-rpc-python-command "/usr/local/bin/python3.6"))

(setq python-shell-completion-native-enable nil)

(*add-shell-paths* '("~/Library/Python/3.6/bin"))

;; ========== Virtual Environment ==============================================
;;
;; It is causing clash with other major modes
;;
;; (require 'pyvenv)
;;
;; (pyenv-mode t)
;; (pyvenv-activate "~/.python_virtual_env/emacs/")
;;
;; ========== iPython ==========================================================

(elpy-use-ipython "ipython3")

;; ========== flycheck =========================================================

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; ========== Autopep8 =========================================================

(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; ========== Provide Library ==================================================

(provide 'config/python)


;;; python.el ends here
