import 'package:flutter_test/flutter_test.dart';
import 'package:noya2/util/string_util.dart';

void main() {
  test('keeps decimal separators while removing other characters', () {
    expect(StringUtil.removeNonDigits('1.234,56'), '1234.56');
    expect(StringUtil.removeNonDigits('1,50'), '1.50');
    expect(StringUtil.removeNonDigits('1.50'), '1.50');
    expect(StringUtil.removeNonDigits('43'), '43');
    expect(StringUtil.removeNonDigits('249.2'), '249.2');
    expect(StringUtil.removeNonDigits('249,2'), '249.2');
  });
}