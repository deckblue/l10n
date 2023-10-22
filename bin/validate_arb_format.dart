import 'dart:convert';
import 'dart:io';

const _basePath = './strings';
const _templateFileName = 'strings_en.arb';

void main(List<String> args) {
  final templateFile = File('$_basePath/$_templateFileName');

  if (!templateFile.existsSync()) {
    throw FormatException('Do not remove "${templateFile.path}".');
  }

  final Map<String, dynamic> templateJson = jsonDecode(
    templateFile.readAsStringSync(),
  );

  for (final file in Directory(_basePath).listSync()) {
    if (!file.path.endsWith('.arb')) continue;

    final arb = File(file.path);

    try {
      jsonDecode(arb.readAsStringSync());
    } on FormatException catch (e) {
      throw FormatException(
        '"${arb.path}" has not valid JSON.',
        e.source,
        e.offset,
      );
    }

    if (file.path == templateFile.path) continue;

    final Map<String, dynamic> arbJson = jsonDecode(arb.readAsStringSync());

    arbJson.forEach((key, _) {
      if (!templateJson.containsKey(key)) {
        throw FormatException(
            'The "$key" in "${arb.path}" does not exist in the template.');
      }
    });
  }
}
