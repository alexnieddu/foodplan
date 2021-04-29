import 'package:shared_preferences/shared_preferences.dart';

/// Stores favorite recipes persistent as `List<String>`.
class Favorites {
  static const String prefKey = "favorites";

  /// Gets a list of favorite recipe names.
  static Future<List<String>> getInstance() async {
    var prefs = await SharedPreferences.getInstance();
    final favs = prefs.getStringList(prefKey);

    if (favs == null) {
      return [];
    } else {
      return prefs.getStringList(prefKey);
    }
  }

  /// Sets `newFavorites` as favorite recipes.
  static Future<bool> update(List<String> newFavorites) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.setStringList(prefKey, newFavorites);
  }
}
