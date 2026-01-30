import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_app/l10n/app_localization.dart';

AppLocalizations get l10n {
  final BuildContext globalContext = GetIt.instance();
  return AppLocalizations.of(globalContext);
}
