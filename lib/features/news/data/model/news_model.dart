import 'package:news_feed/features/news/data/model/source_model.dart';
import 'package:news_feed/features/news/domain/entity/news.dart';

class NewsModel {
  SourceModel? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;

  NewsModel(
      {this.source,
      this.author,
      this.title,
      this.description,
      this.url,
      this.urlToImage,
      this.publishedAt,
      this.content});

  NewsModel.fromJson(Map<String, dynamic> json) {
    source = json['source'] != null
        ? new SourceModel.fromJson(json['source'])
        : null;
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.source != null) {
      data['source'] = this.source!.toJson();
    }
    data['author'] = this.author;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['urlToImage'] = this.urlToImage;
    data['publishedAt'] = this.publishedAt;
    data['content'] = this.content;
    return data;
  }

  //Деструктуризация потому что данных не так много, можно json_serializable юзать
  //Правила думаю понятны, по этой апишке сбривает некоторых где нет автора
  //По хорошему сразу же с модели тянуть данные как лайкнут ли пост, но пока обойдемся локальным хэш мапом,
  //Плюс тут нет айдишек у постов, временно для маленького проетка дескрипшн сойдет за уникальный идентификатор
  News toEntity(Map<String, bool> likes) {
    if (this
        case NewsModel(
          title: String title,
          description: String description,
          urlToImage: String imageUrl,
          publishedAt: String publishedAt,
          content: String content,
          author: String author,
          source: SourceModel(name: String publisher),
        )) {
      return News(
          title: title,
          description: description,
          imageUrl: imageUrl,
          publishedAt: DateTime.tryParse(publishedAt)!,
          content: content,
          author: author,
          publisher: publisher,
          isLiked: likes[description] ?? false);
    } else {
      throw const FormatException();
    }
  }
}
