######################################################

COURSE=cs131e
ASGN=01
COMPILER=adder
EXT=adder

######################################################

UNAME := $(shell uname)
ifeq ($(UNAME), Linux)
  FORMAT=aout
else
ifeq ($(UNAME), Darwin)
  FORMAT=macho
endif
endif

test: clean
	stack test

bin:
	stack install

tests/output/%.result: tests/output/%.run
	$< > $@

tests/output/%.run: tests/output/%.o c-bits/main.c
	clang -g -m32 -o $@ c-bits/main.c $<

tests/output/%.o: tests/output/%.s
	nasm -f $(FORMAT) -o $@ $<

tests/output/%.s: tests/input/%.$(EXT)
	$(COMPILER) $< > $@

clean:
	rm -rf tests/output/*.o tests/output/*.s tests/output/*.dSYM tests/output/*.run tests/output/*.log tests/output/*.result

distclean: clean
	stack clean
	rm -rf .stack-work

tags:
	hasktags -x -c lib/

turnin: distclean
	tar -zcvf ../$(ASGN)-$(COMPILER).tgz ../$(ASGN)-$(COMPILER)
	mv ../$(ASGN)-$(COMPILER).tgz .
	turnin -c $(COURSE) -p $(ASGN) ./$(ASGN)-$(COMPILER).tgz
