# Reading Club

A Flutter reading-club app for book meetings, books' info, borrowing copies, favourites, and reader profiles.


## Decisions
The shell owns the item list, profile, selected tab, and theme mode so every tab sees the same state. The detail screen receives an immutable item and callbacks, while the form returns an updated item through its route result so cancelling cannot mutate the list. The list switches between a phone list and a tablet grid using `LayoutBuilder`, keeping cards at or below 360 logical pixels. The form compares current values with the original values to decide whether leaving requires confirmation. Runtime item construction copies the borrowers list and exposes it as unmodifiable; the const constructor is intended only for compile-time immutable inputs. With more time, I would add persistent storage and automated widget tests using the tools introduced in week 9.
