import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;

class StorageHelper {
  SharedPreferences? _prefs;

  Future<void> initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  void setValue(String key, dynamic value) {
    if (_prefs != null) {
      _prefs?.setString(key, value);
    } else {
      html.window.localStorage[key] = value;
    }
  }

  String? getValue(String key) {
    if (_prefs != null) {
      return _prefs?.getString(key);
    } else {
      return html.window.localStorage[key];
    }
  }

  bool containsKey(String key) {
    if (_prefs != null) {
      return _prefs!.containsKey(key);
    } else {
      return html.window.localStorage.containsKey(key);
    }
  }

  void clear() {
    if (_prefs != null) {
      _prefs?.clear();
    } else {
      html.window.localStorage.clear();
    }
  }
}
