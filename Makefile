.PHONY: all clean quality lean-output-sync lean-output-check

PDF_NAME ?= category-theory-lean4-for-engineers

all:
	latexmk -lualatex -shell-escape -interaction=nonstopmode main.tex
	cp main.pdf $(PDF_NAME).pdf

lean-output-sync:
	python3 tools/sync_lean_command_outputs.py

lean-output-check:
	python3 tools/sync_lean_command_outputs.py --check

quality:
	python3 -m unittest discover -s tools/tests -p 'test_*.py'
	python3 tools/check_lean_keyword_highlighting.py
	python3 tools/check_book_structure.py
	python3 tools/check_tex_lean_sync.py
	python3 tools/check_listing_explanations.py
	python3 tools/check_lean_assumptions.py
	python3 tools/check_lean_snippets.py
	$(MAKE) lean-output-check
	$(MAKE) all
	python3 tools/check_pdf_quality.py

clean:
	latexmk -C
	rm -f $(PDF_NAME).pdf
