import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:provider_structure/core/base/base_provider.dart';

import 'config/routes/app_routes.dart';
import 'config/routes/route_generator.dart';
import 'core/base/locale_provider.dart';
import 'core/base/theme_provider.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/app_localizations_delegate.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/utils/toast_util.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeApp();

  runApp(const MyApp());
}

Future<void> initializeApp() async {
  await StorageService().init();
  await NotificationService().initialize();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => BaseProvider(),
        ),
      ],
      child: Consumer2<ThemeProvider, LocaleProvider>(
        builder: (context, themeProvider, localeProvider, _) {
          return ScreenUtilInit(
            designSize: const Size(360, 690),
            minTextAdapt: true,
            splitScreenMode: true,
            builder: (context, child) => MaterialApp(
              title: '',
              builder: (context, child) {
                return Title(
                  title: AppLocalizations.of(context).translate('app_name'),
                  color: Colors.white, // You can customize this color
                  child: child!,
                );
              },
              theme: themeProvider.lightTheme,
              debugShowCheckedModeBanner: false,
              darkTheme: themeProvider.darkTheme,
              themeMode: themeProvider.themeMode,
              scaffoldMessengerKey: ToastUtils.key,
              onGenerateRoute: RouteGenerator.generateRoute,
              initialRoute: AppRoutes.initialRoute,
              locale: localeProvider.locale,
              localizationsDelegates: const [
                AppLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en'),
                Locale('es'),
              ],
            ),
          );
        },
      ),
    );
  }
}
