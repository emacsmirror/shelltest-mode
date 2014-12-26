test:
	emacs -batch -l shelltest-mode.el -l tests/shelltest-mode-test.el -f ert-run-tests-batch-and-exit
