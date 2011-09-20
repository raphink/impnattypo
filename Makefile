CTANUPLOAD=ctanupload

CONTRIBUTION  = impnattypo
VERSION       = v1.0
SUMMARY       = Typographic utilities inspired by the French Imprimerie Nationale
NAME          = Raphaël Pinson
EMAIL         = raphink@gmail.com
DIRECTORY     = /macros/latex/contrib/$(CONTRIBUTION)
DONOTANNOUNCE = 0
LICENSE       = free
FREEVERSION   = lppl
FILE          = $(CONTRIBUTION).tar.gz

SOURCEFILES   = $(CONTRIBUTION).dtx $(CONTRIBUTION).ins $(CONTRIBUTION)-fr.tex
PKGFILES      = $(CONTRIBUTION).sty
DOCFILES      = $(CONTRIBUTION).pdf $(CONTRIBUTION)-fr.pdf

TEXINSTALLDIR = /usr/local/texlive/texmf-local

export CONTRIBUTION VERSION NAME EMAIL SUMMARY DIRECTORY DONOTANNOUNCE ANNOUNCE NOTES LICENSE FREEVERSION FILE

# default rule
ctanify: $(FILE)

$(FILE): README $(SOURCEFILES) $(DOCFILES) $(PKGFILES)
	ctanify --pkgname $(CONTRIBUTION) $^

%.sty: %.dtx %.ins
	latex $*.ins

%.pdf: %.tex
	lualatex -interaction=batchmode $<
	lualatex -interaction=batchmode $<

$(CONTRIBUTION).pdf: $(CONTRIBUTION).sty
	lualatex -interaction=batchmode $(CONTRIBUTION).dtx
	makeindex -s gind.ist $(CONTRIBUTION).idx
	makeindex -s gglo.ist -o $(CONTRIBUTION).gls $(CONTRIBUTION).glo
	lualatex -interaction=batchmode $(CONTRIBUTION).dtx

$(CONTRIBUTION)-fr.pdf: $(CONTRIBUTION).sty $(CONTRIBUTION)-fr.tex
	lualatex -interaction=batchmode $(CONTRIBUTION)-fr.tex
	makeindex -s gind.ist $(CONTRIBUTION)-fr.idx
	makeindex -s gglo.ist -o $(CONTRIBUTION)-fr.gls $(CONTRIBUTION)-fr.glo
	lualatex -interaction=batchmode $(CONTRIBUTION)-fr.tex

upload: ctanify
	$(CTANUPLOAD) -p

%.tds.zip: %.tar.gz
	tar xzf $< $@

install: $(CONTRIBUTION).tds.zip
	unzip $< -d $(TEXINSTALLDIR)
	mktexlsr

test: $(CONTRIBUTION)-test.pdf

clean:
	rm -f *.aux *.glo *.idx *.log
	rm -f $(DOCFILES) $(PKGFILES)
	rm -f $(FILE)

