class UserPreferencesModel {
  String _language = "";
  bool _darkTheme = true;
  final String languageKey = 'language_key';
  final String darThemeKey = 'darkTheme_key';

  UserPreferencesModel.vazio() {
    _language = "";
    _darkTheme = true;
  }
  UserPreferencesModel(this._language, this._darkTheme);

  String get language => _language;

  bool get darkTheme => _darkTheme;

  set languague(String language) {
    _language = language;
  }

  set darTheme(bool darTheme) {
    _darkTheme = darTheme;
  }
}
