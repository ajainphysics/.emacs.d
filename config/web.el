;;; config/web.el --- Configuration for web designing
;;
;; Copyright (C) Akash Jain
;;
;; Author: Akash Jain <ajainphysx@gmail.com>
;; Keywords: .emacs, init.el
;; Homepage: https://ajainphysics.com
;;
;; This file is part of an emacs configuration.
;;

;;; Commentary:
;;
;; This file contains configuration for PHP, MySQL, HTML, CSS, JS etc.
;;

;;; Code:

;; ========== web-mode ============================================================

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.twig\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(setq web-mode-engines-alist
      '(("php"    . "\\.phtml\\'")
        ("blade"  . "\\.blade\\."))
)

(defun my-web-mode-hook ()
  "Hooks for Web mode."
  (setq web-mode-markup-indent-offset 2)
)
(add-hook 'web-mode-hook
	  (lambda()
	    (progn
	      (setq web-mode-markup-indent-offset 2)
	      (setq web-mode-css-indent-offset 2)
	      (setq web-mode-code-indent-offset 2)
	      (setq web-mode-extra-auto-pairs
		    '(("erb"  . (("beg" "end")))
		      ("php"  . (("beg" "end")
				 ("beg" "end")))
		      ))
	      (setq web-mode-enable-auto-pairing t))))

;; ========== sass-mode ===========================================================

(require 'sass-mode)
(add-to-list 'auto-mode-alist '("\\.scss\\'" . sass-mode))

(provide 'config/web)


;;; web.el ends here
