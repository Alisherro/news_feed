import 'package:dartz/dartz.dart';
import 'package:news_feed/features/news/domain/entity/news.dart';

abstract interface class NewsRepository {
  Future<Either<Exception, List<News>>> getNews(int page);

  Map<String, bool> getLikedNews();

  void likeNews(News news, bool isLike);
}
