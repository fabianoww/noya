import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:noya2/util/category_icon_filter.dart';

void main() {
  const homeIcon = Icons.home;
  const coffeeIcon = Icons.local_cafe;
  const carIcon = Icons.directions_car;
  const icons = [homeIcon, coffeeIcon, carIcon];
  const ids = ['home', 'coffee', 'car'];
  const keywords = {
    'home': ['casa', 'lar'],
    'coffee': ['café', 'bebida quente'],
    'car': ['carro', 'veículo'],
  };

  test('returns all icons for an empty query', () {
    expect(
      CategoryIconFilter.filter(
        icons: icons,
        iconIds: ids,
        keywords: keywords,
        query: '  ',
      ),
      icons,
    );
  });

  test('matches localized synonyms case-insensitively', () {
    expect(
      CategoryIconFilter.filter(
        icons: icons,
        iconIds: ids,
        keywords: keywords,
        query: 'VEIC',
      ),
      [carIcon],
    );
  });

  test('matches keywords without requiring accents', () {
    expect(
      CategoryIconFilter.filter(
        icons: icons,
        iconIds: ids,
        keywords: keywords,
        query: 'cafe',
      ),
      [coffeeIcon],
    );
  });

  test('returns no icons when no keyword matches', () {
    expect(
      CategoryIconFilter.filter(
        icons: icons,
        iconIds: ids,
        keywords: keywords,
        query: 'avião',
      ),
      isEmpty,
    );
  });
}