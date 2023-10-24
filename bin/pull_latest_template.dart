import 'dart:io';

import 'package:github/github.dart';

const _repoOwner = 'deckblue';
const _repoName = 'deckblue';

const _templateFileNames = <String>[
  'strings_en.arb',
  'strings_ja.arb',
  'strings_pt.arb',
];

final _repositorySlug = RepositorySlug(_repoOwner, _repoName);

Future<void> main(List<String> args) async {
  final github = GitHub(
    auth: Authentication.withToken(
      Platform.environment['GITHUB_TOKEN'],
    ),
  );

  for (final templateFileName in _templateFileNames) {
    final latestTemplate = await github.repositories.getContents(
      _repositorySlug,
      'lib/l10n/$templateFileName',
    );

    await File('strings/$templateFileName').writeAsString(
      latestTemplate.file!.text,
    );
  }
}
