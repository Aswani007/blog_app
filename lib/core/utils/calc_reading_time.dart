int calcReadingTime(String content) {
  final wordCount = content.split(RegExp(r'\s+')).length;

  final readingTime = wordCount / 225;

  //ceil highest number from point
  return readingTime.ceil();
}
