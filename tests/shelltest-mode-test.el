(require 'shelltest-mode)

;; FIXME: allow interactive execution by properly cleaning up
;;        stray buffers, etc...
(unless noninteractive
  (error "Run only in batch mode for now"))

(ert-deftest shelltest-find-works ()
  (save-window-excursion
    (with-temp-buffer
      (set-visited-file-name "foobar")
      (let ((d (file-name-directory buffer-file-name)))
        (shelltest-find)
        (should (string= buffer-file-name (concat d "tests/foobar.test")))))))

(ert-deftest shelltest-find-other-window ()
  (save-window-excursion
    (delete-other-windows)
    (let ((shelltest-other-window nil))
      (with-temp-buffer
        (set-visited-file-name "foobar")
        (shelltest-find)
        (should (= (count-windows nil) 1))))
    (let ((shelltest-other-window t))
      (with-temp-buffer
        (set-visited-file-name "foobar")
        (shelltest-find)
        (should (= (count-windows nil) 2))))))

(provide 'shelltest-mode-test)
