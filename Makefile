ifeq (0, $(shell id -u))
$(warning "make was started with superuser privileges. it may cause issues with direnv")
endif

ifeq (, $(shell which direnv))
$(error "No direnv in $(PATH), consider installing. https://direnv.net")
endif

ifneq (1, $(VANITY_DIRENV_SET))
$(error "no envrc detected. might need to run \"direnv allow\"")
endif

# VANITY_ROOT may not be set if environment does not support/use direnv
# in this case define it manually as well as all required env variables
ifndef VANITY_ROOT
$(error "VANITY_ROOT is not set. might need to run \"direnv allow\"")
endif

MODGEN_VERSION   ?= latest
MODGEN           := $(DEVCACHE_BIN)/modgen
MODGEN_VERSION_FILE := $(DEVCACHE_VERSIONS)/modgen/$(VANGEN_VERSION)

VANGEN_VERSION   ?= latest
VANGEN           := $(DEVCACHE_BIN)/vangen
VANGEN_VERSION_FILE := $(DEVCACHE_VERSIONS)/vangen/$(VANGEN_VERSION)

$(MODGEN_VERSION_FILE): $(DEVCACHE)
	@echo "installing modgen $(MODGEN_VERSION) ..."
	rm -f $(MODGEN)
	GOBIN=$(DEVCACHE_BIN) go install essaim.dev/modgen/cmd/modgen@$(VANGEN_VERSION)
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
$(MODGEN): $(MODGEN_VERSION_FILE)

$(VANGEN_VERSION_FILE): $(DEVCACHE)
	@echo "installing vangen $(VANGEN_VERSION) ..."
	rm -f $(VANGEN)
	GOBIN=$(DEVCACHE_BIN) go install 4d63.com/vangen@$(VANGEN_VERSION)
	rm -rf "$(dir $@)"
	mkdir -p "$(dir $@)"
	touch $@
$(VANGEN): $(VANGEN_VERSION_FILE)


$(DEVCACHE):
	@echo "creating .cache dir structure..."
	mkdir -p $@
	mkdir -p $(DEVCACHE_BIN)
	mkdir -p $(DEVCACHE_VERSIONS)

cache: $(DEVCACHE)

vangen: $(MODGEN)
	$(MODGEN) -config modgen.yaml -target=./ 
#	$(VANGEN) -config vangen.json -out .
