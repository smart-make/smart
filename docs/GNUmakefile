smart-make.pdf: main.pdf
	mv -vf $< $@

main.pdf: main.tex
	pdflatex $(<F)
	pdflatex $(<F)

view: smart-make.pdf
	evince $<
