.PHONY: all clean

all:
	latexmk -lualatex -shell-escape -interaction=nonstopmode main.tex

clean:
	latexmk -C
