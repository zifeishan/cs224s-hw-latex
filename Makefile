all : hw3 hw1

hw3 : src/hw3.md list.yml
	pandoc src/hw3.md -o temp.tex
	pdflatex -jobname="hw3" "\def\inputAuthors{Tianxin Zhao, Zifei Shan, Haowen Cao} \def\myid{\{tianxin, zifei, caohw\}@stanford.edu} \def\headerX{CS224S Course Assignment} \def\headerY{} \def\Title{Homework 3} \def\bottomspace{13mm} \def\inputParSkip{0.3em} \def\inputLineStretch{1} \def\geometryline{\geometry{margin=1in,columnsep=0.25in,includeheadfoot}} \def\topspace{10mm} \def\pkulogo{} \def\coverpage{} \input{src/template.tex}"
	pdflatex -jobname="hw3" "\def\inputAuthors{Tianxin Zhao, Zifei Shan, Haowen Cao} \def\myid{\{tianxin, zifei, caohw\}@stanford.edu} \def\headerX{CS224S Course Assignment} \def\headerY{} \def\Title{Homework 3} \def\bottomspace{13mm} \def\inputParSkip{0.3em} \def\inputLineStretch{1} \def\geometryline{\geometry{margin=1in,columnsep=0.25in,includeheadfoot}} \def\topspace{10mm} \def\pkulogo{} \def\coverpage{} \input{src/template.tex}"
	pdftk  hw3.pdf output tmp+cover.pdf
	mv -f tmp+cover.pdf hw3.pdf
	mv hw3.pdf build/hw3.pdf
	rm *.log *.aux *.out

hw1 : src/hw1.md list.yml
	pandoc src/hw1.md -o temp.tex
	pdflatex -jobname="hw1" "\def\Title{Homework 1} \def\inputAuthors{Zifei Shan} \def\bottomspace{13mm} \def\inputParSkip{0.3em} \def\inputLineStretch{1} \def\geometryline{\geometry{margin=1in,columnsep=0.25in,includeheadfoot}} \def\topspace{10mm} \def\pkulogo{} \def\coverpage{} \def\myid{zifei@stanford.edu} \def\headerX{} \def\headerY{CS224S Course Assignment} \input{src/template.tex}"
	pdflatex -jobname="hw1" "\def\Title{Homework 1} \def\inputAuthors{Zifei Shan} \def\bottomspace{13mm} \def\inputParSkip{0.3em} \def\inputLineStretch{1} \def\geometryline{\geometry{margin=1in,columnsep=0.25in,includeheadfoot}} \def\topspace{10mm} \def\pkulogo{} \def\coverpage{} \def\myid{zifei@stanford.edu} \def\headerX{} \def\headerY{CS224S Course Assignment} \input{src/template.tex}"
	pdftk  hw1.pdf output tmp+cover.pdf
	mv -f tmp+cover.pdf hw1.pdf
	mv hw1.pdf build/hw1.pdf
	rm *.log *.aux *.out

.PHONY: clean
clean:
	rm *.log *.out *.aux ./build/*.pdf