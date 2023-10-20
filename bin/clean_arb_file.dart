import 'dart:convert';
import 'dart:io';

const _templateFileName = 'strings_en.arb';
const _descriptionSymbol = '@';

const _jsonConverter = JsonEncoder.withIndent('  ');

void main(List<String> args) {
  final templateFile = File('strings/$_templateFileName');
  final Map<String, dynamic> templateJson =
      jsonDecode(templateFile.readAsStringSync());

  for (final file in Directory('strings').listSync()) {
    if (file.path.endsWith(_templateFileName)) continue;

    final arbFile = File(file.path);
    final Map<String, dynamic> arbJson = jsonDecode(arbFile.readAsStringSync());

    final cleanedArb = <String, dynamic>{};
    templateJson.forEach((key, value) {
      if (arbJson.containsKey(key) && !key.startsWith(_descriptionSymbol)) {
        cleanedArb[key] = arbJson[key];
      }
    });

    arbFile.writeAsStringSync(_jsonConverter.convert(cleanedArb));
  }
}
