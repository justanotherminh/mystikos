ifndef SUBDIR
$(error "please define SUBDIR variable")
endif

__OBJECTS1 = $(SOURCES:.c=.o)
OBJECTS = $(__OBJECTS1:.s=.o)
__OBJECTS = $(addprefix $(SUBOBJDIR)/,$(OBJECTS))

define NL


endef

ifdef PROGRAM
__PROGRAM = $(SUBBINDIR)/$(PROGRAM)
program: $(__PROGRAM) dirs
$(__PROGRAM): $(LIBS) $(__OBJECTS)
	mkdir -p $(SUBBINDIR)
	gcc -o $(__PROGRAM) $(CFLAGS) $(__OBJECTS) $(LIBS) $(LDFLAGS)
endif

ifdef ARCHIVE
__ARCHIVE = $(SUBLIBDIR)/$(ARCHIVE)
archive: $(__ARCHIVE) dirs
$(__ARCHIVE): $(__OBJECTS)
	mkdir -p $(SUBLIBDIR)
	ar rv $(__ARCHIVE) $(__OBJECTS)
endif

$(SUBOBJDIR)/%.o: %.c $(DEPENDS)
	mkdir -p $(SUBOBJDIR)
	$(shell mkdir -p $(shell dirname $@))
	$(CC) -c $(CFLAGS) $(DEFINES) $(INCLUDES) -o $@ $<

$(SUBOBJDIR)/%.o: %.s $(DEPENDS)
	mkdir -p $(SUBOBJDIR)
	$(shell mkdir -p $(shell dirname $@))
	$(CC) -c $(CFLAGS) $(DEFINES) $(INCLUDES) -o $@ $<

dirs:
ifdef DIRS
	$(foreach i, $(DIRS), $(MAKE) -C $(i) $(NL) )
endif

clean:
	rm -f $(__OBJECTS) $(__PROGRAM) $(__ARCHIVE) $(CLEAN)
ifdef DIRS
	$(foreach i, $(DIRS), $(MAKE) -C $(i) clean $(NL) )
endif

tests:
ifndef REDEFINE_TESTS
ifdef DIRS
	$(foreach i, $(DIRS), $(MAKE) -C $(i) tests $(NL) )
endif
endif
