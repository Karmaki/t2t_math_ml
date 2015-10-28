#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#            This file is part of the t2t_math_ml tools.
#  Copyright (C) 2013-2015 Anne Pacalet (Anne.Pacalet@free.fr)
#                ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#      This file is distributed under the terms of the
#       GNU Lesser General Public License Version 2.1
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

TOOL_NAME=t2t_math_ml
VERSION=0.2

TOOL=./$(TOOL_NAME)

T2T=txt2tags

top:
	@echo "make tests : compile the tests"
	@echo "make doc : compile the documentation"
	@echo "make distrib : prepare a distribution archive"
	@echo "make all : make every targets"

all: doc tests distrib

#===============================================================================
TEST_DIR=.
.PHONY: tests
tests: $(TEST_DIR)/test.pdf $(TEST_DIR)/test.xhtml

doc: README.md

#===============================================================================
%.tex : %.t2t
	$(T2T) -t tex -o $@ $<

%.pdf : %.tex
	rubber --inplace --pdf $<
	mv $@ $@.tmp
	rubber --inplace --pdf --clean $<
	mv $@.tmp $@

%.xhtml0 : %.t2t
	$(T2T) -t xhtml -o $@ $<

%.html : %.t2t
	$(T2T) -t html -o $@ $<

%.xhtml : %.xhtml0 $(TOOL)
	$(TOOL) $<

%.md: %.t2t
	pandoc $< -w markdown_github -o $@

#===============================================================================
DISTRIB_NAME=$(TOOL_NAME)-$(VERSION)
DISTRIB_FILE=$(DISTRIB_NAME).tgz

DISTRIBUTED=LICENSE Makefile README.t2t
DISTRIBUTED+=$(TOOL)
DISTRIBUTED+=$(TEST_DIR)/test.t2t

PUB_FILES=$(DISTRIB_NAME).tgz README.html txt2tags.css
PUB_FILES+=$(TEST_DIR)/test.t2t $(TEST_DIR)/test.pdf $(TEST_DIR)/test.xhtml

distrib: $(DISTRIB_NAME).tgz $(PUB_FILES)
	@ echo "Don't forget to copy $(PUB_FILES) into public_html/dev/t2t_math_ml/ if needed"

%.tgz: $(DISTRIBUTED)
	mkdir -p $*
	cp --parents $(DISTRIBUTED) $*
	tar zcf $@ $*
	rm -rf $*

#===============================================================================
clean :
	if [ -f test.tex ] ; then rubber --clean -inplace --pdf test.tex ; fi
	rm -f  test.tex  test.pdf
	rm -f test.xhtml test.xhtml0
	rm -f README.md README.html

#===============================================================================
