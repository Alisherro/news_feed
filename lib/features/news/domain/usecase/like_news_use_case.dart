

import '../entity/news.dart';
import '../repository/news_repository.dart';

class LikeNewsUseCase {
  final NewsRepository repository;

  LikeNewsUseCase(this.repository);

  void execute(News news, bool isLike) {
    repository.likeNews(news, isLike);
  }
}
