import 'package:dartz/dartz.dart';

import '../entity/news.dart';
import '../repository/news_repository.dart';


class GetNewsListUseCase {
  final NewsRepository repository;

  GetNewsListUseCase(this.repository);
  Future<Either<Exception, List<News>>> execute(int page) {
    return repository.getNews(page);
  }
}
