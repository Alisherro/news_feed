import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class NewsDatasourceLocal {
  Map<String, bool> getLikedDescriptions();

  void setLike(String key, bool value);
}

class NewsDatasourceLocalImpl implements NewsDatasourceLocal {
  NewsDatasourceLocalImpl(this.prefs);

  final SharedPreferences prefs;

  @override
  Map<String, bool> getLikedDescriptions() {
    String? encodedData = prefs.getString('likedNews');
    if (encodedData != null) {
      Map<String, dynamic> decodedData = json.decode(encodedData);
      Map<String, bool> likes = decodedData.map((key, value) => MapEntry(key, value as bool));
      print(likes.toString());
      return likes;
    }
    return const {};
  }

  @override
  void setLike(String key, bool value) {
    String? encodedData = prefs.getString('likedNews');
    if (encodedData != null) {
      //Если данные уже есть то декодируем, добавляем новый ключ или удаляем если убрали лайк
      Map<String, dynamic> decodedData = jsonDecode(encodedData);
      Map<String, bool> likes = decodedData.map((key, value) => MapEntry(key, value as bool));
      if (value) {
        likes[key] = value;
      } else {
        likes.remove(key);
      }
      prefs.setString('likedNews', jsonEncode(likes));
    } else {
      //Если данных по лайка еще не было то либо создаем либо оставляем в таком виде
      if (value) {
        Map<String, bool> likes = {key: value};
        prefs.setString('likedNews', jsonEncode(likes));
      }
    }
    print('endSettingLike');
  }
}
