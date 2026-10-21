const List<String> _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec', //
];

String _two(int n) => n.toString().padLeft(2, '0');

String formatClock(int hour, int minute) => '${_two(hour)}:${_two(minute)}';

String formatDay(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

String formatDate(DateTime d) =>
    '${d.day} ${_months[d.month - 1]}, ${formatClock(d.hour, d.minute)}';

String formatDuration(Duration d) {
  if (d.inDays > 0) return '${d.inDays}d ${d.inHours % 24}h';
  if (d.inHours > 0) return '${d.inHours}h ${_two(d.inMinutes % 60)}m';
  return '${d.inMinutes}m';
}
