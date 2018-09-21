DOTFILES_DIR      := ./home
FROM_DIR          := $(abspath $(DOTFILES_DIR))
DEST_DIR          := $(HOME)

DOTFILES_EXCLUDES := . .. .DS_Store .git .gitmodules .travis.yml .gitignore .config
DOTFILES          := $(filter-out $(DOTFILES_EXCLUDES),$(notdir $(wildcard $(DOTFILES_DIR)/.*)))

LN                := ln -snfv
RM                := rm -fv

# 空行2行は必要
define installFunc
	$(LN) $(FROM_DIR)/$(1) $(DEST_DIR)/$(1)


endef

# 空行2行は必要
define uninstallFunc
	$(RM) $(DEST_DIR)/$(1)


endef

all: install

init:

clean: uninstall

install:
	@$(foreach elem,$(DOTFILES),$(call installFunc,$(elem)))

uninstall:
	@$(foreach elem,$(DOTFILES),$(call uninstallFunc,$(elem)))

.PHONY: all init clean run install uninstall

