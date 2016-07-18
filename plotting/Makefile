all: plot01.out plot01_detail.out plot02.out
%.out: %.R force
	R --no-save < $< > $@

force:

