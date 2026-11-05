# Notes

## Level 1: what lifting costs
Adding `total` touched 2 constructors (BooksScreen, CartBadge) in 3 files
(main.dart, books_screen.dart, cart_badge.dart).
One tap on Add printed N lines (1 BooksScreen build + 6 rows), because setState in Shell marks everything under it dirty.


## Level 3: provider errors
Loud (context.watch inside onPressed):
Tried to listen to a value exposed with provider, from outside of the widget tree.

Silent (context.read inside build): no error, it compiles and runs, but the
badge is frozen at 0 forever, because nobody said "I depend on the cart".