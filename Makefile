DOTFILES_DIR      := ./home
FROM_DIR          := $(abspath $(DOTFILES_DIR))
DEST_DIR          := $(HOME)

DOTFILES_EXCLUDES := . .. .DS_Store .git .gitmodules .travis.yml .gitignore .config
DOTFILES          := $(filter-out $(DOTFILES_EXCLUDES),$(subst $(DOTFILES_DIR)/,,$(wildcard $(DOTFILES_DIR)/.*)))

LN                := ln -snfv
RM                := rm -fv

define install
	$(LN) $(FROM_DIR)/$(1) $(DEST_DIR)/$(1)


endef

define uninstall
	$(RM) $(DEST_DIR)/$(1)


endef

all: install

init:

clean: uninstall

install:
	@$(foreach elem,$(DOTFILES),$(call install,$(elem)))

uninstall:
	@$(foreach elem,$(DOTFILES),$(call uninstall,$(elem)))

.PHONY: all init clean run install uninstall

