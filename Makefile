DOTFILES_DIR      := home
FROM_DIR          := $(CURDIR)/$(DOTFILES_DIR)
DEST_DIR          := $(HOME)

DOTFILES_EXCLUDES := .DS_Store .git .gitmodules .travis.yml .gitignore .config
DOTFILES_TARGET   := $(patsubst $(DOTFILES_DIR)/%,%,$(wildcard $(addprefix $(DOTFILES_DIR)/,.??*)))
DOTFILES          := $(filter-out $(DOTFILES_EXCLUDES), $(DOTFILES_TARGET))

LN                := ln -snfv
RM                := rm -fv

deploy:
	@$(foreach elem,$(DOTFILES),$(LN) $(FROM_DIR)/$(elem) $(DEST_DIR)/$(elem);)

test:
	@$(foreach elem,$(DOTFILES),echo $(LN) $(FROM_DIR)/$(elem) $(DEST_DIR)/$(elem);)

init:

clean:
	@$(foreach elem,$(DOTFILES),$(RM) $(DEST_DIR)/$(elem);)

.PHONY: all deploy test init clean

