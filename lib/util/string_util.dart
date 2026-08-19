class StringUtil {

  static final _replacements = {
    'á': 'a', 'à': 'a', 'ã': 'a', 'â': 'a', 'ä': 'a',
    'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e',
    'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i',
    'ó': 'o', 'ò': 'o', 'õ': 'o', 'ô': 'o', 'ö': 'o',
    'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u',
    'ç': 'c', 'ý': 'y', 'ÿ': 'y',
  };

  static String removeAccentsFromValue(String value) {
    var normalized = value.toLowerCase();
    for (final entry in _replacements.entries) {
      normalized = normalized.replaceAll(entry.key, entry.value);
    }
    return normalized;
  }

  static String removeAccentsFromClause(String expression) {

    var normalized = 'LOWER($expression)';
    for (final entry in _replacements.entries) {
      normalized = "REPLACE($normalized, '${entry.key}', '${entry.value}')";
    }
    return normalized;
  }

  static String removeNonDigits(String value) {
    final normalized = value.replaceAll(RegExp(r'[^0-9,.]'), '');
    final decimalSeparatorIndex = normalized.lastIndexOf(RegExp(r'[,.]'));

    if (decimalSeparatorIndex == -1) {
      return normalized;
    }

    final integerPart = normalized
        .substring(0, decimalSeparatorIndex)
        .replaceAll(RegExp(r'[,.]'), '');
    final decimalPart = normalized.substring(decimalSeparatorIndex + 1);

    return '$integerPart.$decimalPart';
  }

}