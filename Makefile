.PHONY: all clean

PDF_NAME ?= category-theory-lean4-for-engineers

all:
	latexmk -lualatex -shell-escape -interaction=nonstopmode main.tex
	cp main.pdf $(PDF_NAME).pdf

.PHONY: quality
quality:
	python3 tools/check_tex_lean_sync.py
	python3 tools/check_listing_explanations.py
	python3 tools/check_lean_assumptions.py
	python3 tools/check_lean_snippets.py
	$(MAKE) all
	python3 tools/check_pdf_quality.py

clean:
	latexmk -C
	rm -f $(PDF_NAME).pdf
