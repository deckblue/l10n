import 'dart:convert';
import 'dart:io';

const _basePath = './strings';
const _templateFileName = 'strings_en.arb';
const _untranslatedFileName = 'untranslated.json';
const _descriptionSymbol = '@';

const _jsonConverter = JsonEncoder.withIndent('  ');

void main() {
  final templateFile = File('$_basePath/$_templateFileName');

  final untranslated = <String, dynamic>{};
  for (final file in Directory(_basePath).listSync()) {
    if (file.path.endsWith(_templateFileName)) continue;

    final targetFile = File(file.path);

    final Map<String, dynamic> templateStrings =
        jsonDecode(templateFile.readAsStringSync());
    final Map<String, dynamic> targetStrings =
        jsonDecode(targetFile.readAsStringSync());

    final keys = <String>[];
    templateStrings.forEach((key, _) {
      if (!targetStrings.containsKey(key) &&
          !key.startsWith(_descriptionSymbol)) {
        keys.add(key);
      }
    });

    untranslated[_getLangCode(targetFile)] = keys;
  }

  File(_untranslatedFileName).writeAsStringSync(
    _jsonConverter.convert(untranslated),
  );
}

/// Extracts the language code from the filename of a given [file].
///
/// This function performs the following steps to derive the language code:
///   1. Extracts the filename from the file's path.
///   2. Splits the filename using the dot ('.') as a delimiter and takes the first part.
///   3. Splits the result using the underscore ('_') as a delimiter and takes the second part.
///
/// ## Parameters:
/// - [file]: The file from which the language code is to be extracted.
///
/// ## Returns:
/// A `String` representing the extracted language code.
String _getLangCode(final File file) {
  final fileName = file.path.split('/').last.split('.').first;
  final tokens = fileName.split('_');

  return tokens.length > 2 ? tokens.sublist(1).join('_') : tokens[1];
}
