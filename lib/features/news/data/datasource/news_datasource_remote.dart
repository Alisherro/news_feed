import 'package:dartz/dartz.dart';
import 'package:news_feed/core/api/api.dart';
import 'package:news_feed/features/news/data/model/news_model.dart';

abstract interface class NewsDatasourceRemote {
  Future<Either<Exception, List<NewsModel>>> getNewsList(int page);
}

class NewsDatasourceRemoteImpl implements NewsDatasourceRemote {
  NewsDatasourceRemoteImpl(this.dioClient);

  final DioClient dioClient;

  @override
  Future<Either<Exception, List<NewsModel>>> getNewsList(int page) async {
    return await dioClient.getRequest<List<NewsModel>>(ListAPI.news,
        queryParameters: {"apiKey": ListAPI.apiKey, "q":"tesla"}, converter: (json) {
      List<NewsModel> list = <NewsModel>[];
      json['articles'].forEach((v) {
        list.add(NewsModel.fromJson(v));
      });
      return list;
    });
  }
}
