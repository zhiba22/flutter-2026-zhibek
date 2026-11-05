# Notes

## Level 1: what lifting costs
Adding `total` touched 2 constructors (BooksScreen, CartBadge) in 3 files
(main.dart, books_screen.dart, cart_badge.dart).
One tap on Add printed N lines (1 BooksScreen build + 6 rows), because setState in Shell marks everything under it dirty.