import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_feed/features/news/domain/entity/news.dart';
import 'package:news_feed/features/news/domain/repository/news_repository.dart';
import 'package:news_feed/features/news/domain/usecase/get_news_list_use_case.dart';
import 'package:news_feed/features/news/domain/usecase/like_news_use_case.dart';
import 'package:news_feed/features/news/presentation/feed/bloc/news_bloc.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  group(
    'NewsBloc',
    () {
      final mockNewsRepository = MockNewsRepository();
      final news = News(
        description: 'Test news',
        title: 'test',
        imageUrl: 'test',
        publishedAt: DateTime.fromMicrosecondsSinceEpoch(1),
        content: 'test',
        author: 'test',
        publisher: 'test',
      );
      when(() => mockNewsRepository.getNews(0)).thenAnswer(
        (_) async => Right(
          [news],
        ),
      );
      final GetNewsListUseCase getNewsListUseCase =
          GetNewsListUseCase(mockNewsRepository);
      final LikeNewsUseCase likeNewsUseCase =
          LikeNewsUseCase(mockNewsRepository);
      blocTest<NewsBloc, NewsState>(
        'emits [NewsLoaded] when NewsFetched is added',
        build: () => NewsBloc(getNewsListUseCase, likeNewsUseCase),
        act: (bloc) => bloc.add(NewsFetched()),
        expect: () => [
          NewsLoaded(newsList: [news], currentPage: 0, reachedMax: false)
        ],
      );
    },
  );
}
