import 'package:vfcs/app_manager.dart';
import 'package:vfcs/data/data_settings.dart';
import 'package:vfcs/pages/orientation_page.dart';
import 'package:vfcs/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'generated/l10n.dart';

class VFCSApp extends StatelessWidget {

  final AppManager appManager;

  VFCSApp(this.appManager);

  @override
  Widget build(BuildContext context) =>
    ChangeNotifierProvider.value(
      value: this.appManager,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "VFCS",

        themeMode: this.appManager.settingProvider.getSettingData(SettingType.ENFORCE_DARK_THEME).value
            ? ThemeMode.dark
            : ThemeMode.system,

        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,

        initialRoute: Routes.PAGE_MAIN_PANEL,
        routes: Routes.routes,
        navigatorObservers: [routeObserver],
      ),
    );

}