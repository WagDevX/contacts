import 'package:contacts/model/preferences/user_preferences_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesRepository {
  var userPreferences = UserPreferencesModel.vazio();

  Future<void> setPreferences(UserPreferencesModel userPreferencesModel) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
        userPreferencesModel.darThemeKey, userPreferencesModel.darkTheme);
    await prefs.setString(
        userPreferencesModel.languageKey, userPreferencesModel.language);
  }

  Future<UserPreferencesModel> getUserPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? darkTheme = prefs.getBool(userPreferences.darThemeKey);
    final String? language = prefs.getString(userPreferences.languageKey);
    var userPref = UserPreferencesModel(language ?? "", darkTheme ?? true);
    return userPref;
  }
}
