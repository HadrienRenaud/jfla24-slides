default: build
all: build
build: slides.pdf

HERD=herd7
HERD_OLD_PREFIX=$(HOME)/.local/herd7.56.3
HERD_OLD=$(HERD_OLD_PREFIX)/bin/herd7

graphs/old/%.pdf: graphs/old/%.dot
	dot -Tpdf -o $@ $<

graphs/old/%.litmus: graphs/%.litmus
	@mkdir -p $(@D)
	cp $< $@

graphs/old/cas-ok.dot: graphs/old/cas-ok.litmus graphs/one-instr.conf $(HERD_OLD)
	$(HERD_OLD) -o graphs/old -conf graphs/one-instr.conf $<

graphs/old/cas-ok-bolden.dot: graphs/old/cas-ok.dot graphs/bold.gvpr
	gvpr -c -f graphs/bold.gvpr -o $@ $<

graphs/asl/cas-ok-rewritten.dot: graphs/asl/cas-ok.dot graphs/old.gvpr
	gvpr -i 'N[match(label, "NZCV") == -1]' $< \
	| gvpr -c -f graphs/old.gvpr -o $@

graphs/asl/cas-ok-rewritten-bolden.dot: graphs/asl/cas-ok-rewritten.dot graphs/bold.gvpr
	gvpr -c -f graphs/bold.gvpr -o $@ $<

graphs/asl/cas-ok.pdf: graphs/asl/cas-ok-rewritten.dot
	dot -Tpdf -o $@ $<

graphs/asl/cas-ok-bolden.pdf: graphs/asl/cas-ok-rewritten-bolden.dot
	dot -Tpdf -o $@ $<

graphs/asl/cas-ok.litmus: graphs/cas-ok.litmus graphs/asl
	@mkdir -p $(@D)
	cp $< $@

graphs/asl/cas-ok.dot: graphs/asl/cas-ok.litmus graphs/asl graphs/one-instr.conf
	$(HERD) -o graphs/asl -conf graphs/one-instr.conf -variant ASL -unshow iico_order $<

graphs/MP+dmb+addr-all.dot: graphs/MP+dmb+addr.litmus graphs/multi-instr.conf
	$(HERD) -o graphs -conf graphs/multi-instr.conf -through invalid $<
	mv graphs/MP+dmb+addr.dot $@

graphs/MP+dmb+addr-basic.dot: graphs/MP+dmb+addr.litmus graphs/multi-instr.conf
	$(HERD) -o graphs -conf graphs/multi-instr.conf -showevents noregs -through invalid $<
	mv graphs/MP+dmb+addr.dot $@

graphs/%.dot: graphs/%.litmus
	$(HERD) -o graphs -conf graphs/one-instr.conf $<

graphs/%.pdf: graphs/%.dot
	dot -Tpdf -o $@ $<

AUX_DIR=.aux
$(AUX_DIR):
	mkdir $@

LATEXMK=latexmk -recorder -use-make -deps \
	-e 'warn qq(In Makefile, turn off custom dependencies\n);' \
	-e '@cus_dep_list = ();' \
	-e 'show_cus_dep();' \
	-outdir=. \
	-deps-out=$(AUX_DIR)/deps

$(eval -include $(AUX_DIR)/deps)

slides.pdf: slides.tex $(AUX_DIR)
	$(LATEXMK) -pdf $<

.PHONY: open
open: slides.pdf
	open $<

.PHONY: clean
clean:
	latexmk -c

