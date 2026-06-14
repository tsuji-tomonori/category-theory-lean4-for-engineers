.PHONY: all clean

PDF_NAME ?= category-theory-lean4-for-engineers

all:
	latexmk -lualatex -shell-escape -interaction=nonstopmode main.tex
	cp main.pdf $(PDF_NAME).pdf

clean:
	latexmk -C
	rm -f $(PDF_NAME).pdf
