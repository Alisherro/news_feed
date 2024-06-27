import 'package:dartz/dartz.dart';
import 'package:news_feed/features/news/data/datasource/news_datasource_local.dart';
import 'package:news_feed/features/news/data/datasource/news_datasource_remote.dart';
import 'package:news_feed/features/news/domain/entity/news.dart';
import 'package:news_feed/features/news/domain/repository/news_repository.dart';

import '../model/news_model.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl(this.local, this.remote);

  final NewsDatasourceLocal local;
  final NewsDatasourceRemote remote;

  @override
  Future<Either<Exception, List<News>>> getNews(int page) async {
    final res = await remote.getNewsList(page);
    return res.fold(
      (l) => Left(l),
      (r) {
        final likes = local.getLikedDescriptions();
        List<News> newsList = [];
        for (NewsModel m in r) {
          try {
            newsList.add(m.toEntity(likes));
          } on Exception catch (e, stack) {
            // debugPrint(e.toString());
            // debugPrint(stack.toString());
          }
        }
        return Right(newsList);
      },
    );
  }

  @override
  Map<String, bool> getLikedNews() {
    return local.getLikedDescriptions();
  }

  @override
  void likeNews(News news, bool isLike) {
    String key = news.description;
    local.setLike(key, isLike);
  }
}
