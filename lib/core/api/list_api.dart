class ListAPI {
  ListAPI._();

  static const String baseUrl = String.fromEnvironment('API_URL', defaultValue: "https://newsapi.org");
  static const String apiKey = String.fromEnvironment('API_KEY', defaultValue: "a7cf733e7f1144c5891e081525b8ca06");
  static const String news = '/v2/everything';

}
