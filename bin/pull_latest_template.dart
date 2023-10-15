import 'dart:io';

import 'package:github/github.dart';

const _repoOwner = 'deckblue';
const _repoName = 'deckblue';
const _templateFileName = 'strings_en.arb';

final _repositorySlug = RepositorySlug(_repoOwner, _repoName);

Future<void> main(List<String> args) async {
  final github = GitHub(
    auth: Authentication.withToken(
      Platform.environment['GITHUB_TOKEN'],
    ),
  );

  final latestTemplate = await github.repositories.getContents(
    _repositorySlug,
    'lib/l10n/$_templateFileName',
  );

  await File('strings/$_templateFileName').writeAsString(
    latestTemplate.file!.text,
  );
}
