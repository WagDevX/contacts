import 'package:contacts/main.dart';
import 'package:contacts/model/preferences/user_preferences_model.dart';
import 'package:contacts/repositories/user_preferences/user_preferences_repository.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ConfigurationPage extends StatefulWidget {
  const ConfigurationPage({super.key});

  @override
  State<ConfigurationPage> createState() => _ConfigurationPageState();
}

class _ConfigurationPageState extends State<ConfigurationPage> {
  var userPreferencesRepository = UserPreferencesRepository();
  bool darkTheme = true;
  String language = "";
  late UserPreferencesModel userPreferencesModel;

  @override
  void initState() {
    super.initState();
    loadPreferences();
  }

  loadPreferences() async {
    userPreferencesModel = await userPreferencesRepository.getUserPreferences();
    darkTheme = userPreferencesModel.darkTheme;
    language = userPreferencesModel.language;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('app_language').tr(),
            trailing: PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == "english") {
                    context.setLocale(const Locale('en', 'US'));
                  }
                  if (value == "portuguese") {
                    context.setLocale(const Locale('pt', 'BR'));
                  }
                },
                itemBuilder: (BuildContext bc) => <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                          value: "english", child: const Text('english').tr()),
                      PopupMenuItem<String>(
                        value: "portuguese",
                        child: const Text('portuguese').tr(),
                      ),
                    ]),
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('dark_theme').tr(),
            trailing: Switch(
                value: darkTheme,
                onChanged: (value) async {
                  setState(() {
                    darkTheme = value;
                  });
                  userPreferencesModel.darTheme = value;
                  if (value) {
                    MyApp.of(context)!.changeTheme(ThemeMode.dark);
                  } else {
                    MyApp.of(context)!.changeTheme(ThemeMode.light);
                  }
                  await userPreferencesRepository
                      .setPreferences(userPreferencesModel);
                }),
          )
        ],
      ),
    );
  }
}
