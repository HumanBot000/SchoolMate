List<int> getIndexesInAlphabet(List<String> characters) {
  return characters
      .map((char) => char.codeUnitAt(0) - 'A'.codeUnitAt(0))
      .toList();
}

List<String> getCharactersInAlphabet(List<int> indexes) {
  return indexes
      .map((index) => String.fromCharCode(index + 'A'.codeUnitAt(0)))
      .toList();
}
