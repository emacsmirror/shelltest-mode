;;; shelltest-mode.el --- Major mode for shelltestrunner.

;; Copyright (C) 2014 Dustin Fechner

;; Author: Dustin Fechner <fechnedu@gmail.com>
;; URL: https://github.com/rtrn/shelltest-mode
;; Version: 1.0
;; Created: 21 Dec 2014
;; Keywords: languages

;;; License:

;; Permission to use, copy, modify, and distribute this software for any
;; purpose with or without fee is hereby granted, provided that the above
;; copyright notice and this permission notice appear in all copies.
;;
;; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
;; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
;; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
;; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
;; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
;; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
;; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

;;; Commentary:

;; Major mode for shelltestrunner (http://joyful.com/shelltestrunner).
;;
;; Besides syntax highlighting, a few useful functions for dealing with
;; test files are provided:
;;
;; To quickly open test files use `shelltest-find'.  To execute tests use
;; `shelltest-run' and `shelltest-run-all'.  These functions work from
;; all modes and can be bound to keys for convenience.
;;
;; To find out how to customize (among other things) the location of the
;; test files, refer to the documentation of the relevant functions.

;;; Code:

;; customizable variables
(defgroup shelltest-mode nil
  "Major mode for shelltestrunner."
  :group 'languages
  :link '(emacs-library-link :tag "Lisp File" "shelltest-mode.el"))

(defcustom shelltest-other-window t
  "If given a non-nil value, `shelltest-find' uses another window."
  :type 'boolean
  :group 'shelltest-mode)

(defcustom shelltest-command "shelltest --execdir"
  "The command that `shelltest-run' and `shelltest-run-all' execute."
  :type 'string
  :group 'shelltest-mode)

(defcustom shelltest-directory "./tests"
  "The directory in which the test files are located."
  :type 'string
  :group 'shelltest-mode)

;; interactive functions
(defun shelltest-find ()
  "Edit the test file that corresponds to the currently edited file.

The opened file is `shelltest-directory'/file.test, where \"file\" is the
name of the currently edited file with its extension removed.
If `shelltest-other-window' is non-nil, open the file in another window."
  (interactive)
  (let ((test (format "%s/%s.test"
                      shelltest-directory
                      (file-name-base (buffer-file-name)))))
    (if shelltest-other-window
        (find-file-other-window test)
      (find-file test))))

(defun shelltest-run ()
  "Run the test file associated with the currently edited file.

The command to be run is determined by `shelltest-command'.  Its argument
is `shelltest-directory'/file.test, where \`file\' is the name of the
currently edited file with its extension removed."
  (interactive)
  (let ((cmd (format "%s %s/%s.test"
                     shelltest-command
                     shelltest-directory
                     (file-name-base (buffer-file-name)))))
    (compile cmd)))

(defun shelltest-run-all ()
  "Run all test files.

The command to be run is determined by `shelltest-command'.  Its argument
is `shelltest-directory'."
  (interactive)
  (let ((cmd (format "%s %s"
                     shelltest-command
                     shelltest-directory)))
    (compile cmd)))

;; helper variables and functions
(defconst shelltest-keywords
  '(("^>>>=" . font-lock-keyword-face)
    ("^\\(>>>2\\|>>>\\|<<<\\)$" (1 font-lock-keyword-face)
     ("." (shelltest-end-of-string) nil (0 font-lock-string-face)))
    ("^\\(>>>2\\|>>>\\)[^=].*" (1 font-lock-keyword-face)
     ("." (shelltest-end-of-string) nil (0 font-lock-string-face)))
    ("^#.*" . font-lock-comment-face)))

(defun shelltest-end-of-string ()
  (save-excursion
    (while (not (or (eobp)
                    (looking-at-p ">>>=\\|>>>2\\|>>>\\|<<<")))
      (forward-line))
    (point)))

;; mode definition
(define-derived-mode shelltest-mode prog-mode "Shelltest"
  "Major mode for shelltestrunner.

See URL `http://joyful.com/shelltestrunner'."
  (setq font-lock-multiline t)
  (font-lock-add-keywords nil shelltest-keywords)
  (setq-local compile-command (format "%s %s" shelltest-command (buffer-file-name)))
  (setq-local shelltest-directory (file-name-directory (buffer-file-name))))

(add-to-list 'auto-mode-alist '("\\.test\\'" . shelltest-mode))

(provide 'shelltest-mode)

;;; shelltest-mode.el ends here