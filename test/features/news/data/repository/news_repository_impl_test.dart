import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:news_feed/features/news/data/datasource/news_datasource_local.dart';
import 'package:news_feed/features/news/data/datasource/news_datasource_remote.dart';
import 'package:news_feed/features/news/data/model/news_model.dart';
import 'package:news_feed/features/news/data/model/source_model.dart';
import 'package:news_feed/features/news/data/repository/news_repository_impl.dart';
import 'package:news_feed/features/news/domain/entity/news.dart';

class MockNewsDatasourceLocal extends Mock implements NewsDatasourceLocal {}

class MockNewsDatasourceRemote extends Mock implements NewsDatasourceRemote {}

void main() {
  group('NewsRepositoryImpl', () {
    late MockNewsDatasourceLocal mockLocalDatasource;
    late MockNewsDatasourceRemote mockRemoteDatasource;
    late NewsRepositoryImpl repository;

    setUp(() {
      mockLocalDatasource = MockNewsDatasourceLocal();
      mockRemoteDatasource = MockNewsDatasourceRemote();
      repository = NewsRepositoryImpl(mockLocalDatasource, mockRemoteDatasource);
    });

    test('should return list of news on successful remote data fetch', () async {
      final newsModelFirst = NewsModel(
        title: 'Test Title First',
        description: 'Test Description First',
        urlToImage: 'http://example.com/image.jpg',
        publishedAt: DateTime.fromMicrosecondsSinceEpoch(1).toIso8601String(),
        content: 'Test Content First',
        author: 'Test Author First',
        source: SourceModel(name: 'Test Publisher First'),
      );
      final newsModelSecond = NewsModel(
        title: 'Test Title Second',
        description: 'Test Description Second',
        urlToImage: 'http://example.com/image.jpg',
        publishedAt: DateTime.fromMicrosecondsSinceEpoch(1).toIso8601String(),
        content: 'Test Content Second',
        author: 'Test Author Second',
        source: SourceModel(name: 'Test Publisher Second'),
      );

      final newsList = [newsModelFirst, newsModelSecond];
      when(() => mockRemoteDatasource.getNewsList(0))
          .thenAnswer((_) async => Right(newsList));
      when(() => mockLocalDatasource.getLikedDescriptions())
          .thenReturn({'Test Description First': true});

      final result = await repository.getNews(0);

      expect(result, isA<Right>());
      final news = result.getOrElse(() => []);
      expect(news, isA<List<News>>());
      expect(news[0].isLiked, true);
      expect(news[1].isLiked, false);
      verify(() => mockRemoteDatasource.getNewsList(0)).called(1);
      verify(() => mockLocalDatasource.getLikedDescriptions()).called(1);
    });

    test('should return exception on remote data fetch failure', () async {
      when(() => mockRemoteDatasource.getNewsList(0))
          .thenAnswer((_) async => Left(Exception('Failed to fetch data')));

      final result = await repository.getNews(0);

      expect(result, isA<Left>());
      expect(result.fold((l) => l, (_) => null), isA<Exception>());
      verify(() => mockRemoteDatasource.getNewsList(0)).called(1);
      verifyNever(() => mockLocalDatasource.getLikedDescriptions());
    });

  });
}
