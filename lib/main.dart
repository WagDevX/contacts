import 'package:contacts/model/preferences/user_preferences_model.dart';
import 'package:contacts/pages/splash_screen/splash_screen_delay_page.dart';
import 'package:contacts/repositories/user_preferences/user_preferences_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en', 'US'),
        child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  var userPreferencesRepository = UserPreferencesRepository();
  bool darkTheme = true;
  String language = "";
  late UserPreferencesModel userPreferencesModel;

  @override
  void initState() {
    loadPreferences();
    super.initState();
  }

  loadPreferences() async {
    userPreferencesModel = UserPreferencesModel.vazio();
    userPreferencesModel = await userPreferencesRepository.getUserPreferences();
    darkTheme = userPreferencesModel.darkTheme;
    language = userPreferencesModel.language;
    setState(() {
      if (darkTheme) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      darkTheme: ThemeData.dark(
        useMaterial3: true,
      ),
      theme: ThemeData.light(useMaterial3: true),
      home: const SplashScreenDelayPage(),
    );
  }

  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }
}
