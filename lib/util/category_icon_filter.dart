import 'package:flutter/material.dart';

class CategoryIconFilter {
  static List<IconData> filter({
    required List<IconData> icons,
    required List<String> iconIds,
    required Map<String, List<String>> keywords,
    required String query,
  }) {
    final normalizedQuery = normalize(query.trim());
    if (normalizedQuery.isEmpty) {
      return icons;
    }

    return [
      for (var index = 0; index < icons.length; index++)
        if ((keywords[iconIds[index]] ?? const <String>[])
            .any((keyword) => normalize(keyword).contains(normalizedQuery)))
          icons[index],
    ];
  }

  static String normalize(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[áàãâä]'), 'a')
        .replaceAll(RegExp(r'[éèêë]'), 'e')
        .replaceAll(RegExp(r'[íìîï]'), 'i')
        .replaceAll(RegExp(r'[óòõôö]'), 'o')
        .replaceAll(RegExp(r'[úùûü]'), 'u')
        .replaceAll('ç', 'c');
  }
}