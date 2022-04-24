##
# dotfiles install
#
# @file
# @version 0.1

all:
	stow --verbose --target=$$HOME --restow */

delete:
	stow --verbose --target=$$HOME --delete */

# end
