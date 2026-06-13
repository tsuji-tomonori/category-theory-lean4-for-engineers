.PHONY: all clean

all:
	latexmk -lualatex -interaction=nonstopmode main.tex

clean:
	latexmk -C
