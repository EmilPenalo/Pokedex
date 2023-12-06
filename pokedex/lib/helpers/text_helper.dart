String formatNumber(int number) {
  return '#${number.toString().padLeft(4, '0')}';
}

String capitalizeFirstLetter(String text) {
  return text[0].toUpperCase() + text.substring(1);
}

String formatNumberStat(int number) {
  return number.toString().padLeft(3, '0');
}