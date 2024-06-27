import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_feed/features/news/domain/repository/news_repository.dart';
import 'package:news_feed/features/news/domain/usecase/get_liked_news_use_case.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  group('GetLikedNewsUseCase', () {
    late MockNewsRepository mockRepository;
    late GetLikedNewsUseCase useCase;

    setUp(() {
      mockRepository = MockNewsRepository();
      useCase = GetLikedNewsUseCase(mockRepository);
    });

    test('execute should return liked news map', () async {
      final Map<String, bool> expectedLikedNews = {
        'news1': true,
        'news2': false
      };
      when(() => mockRepository.getLikedNews()).thenReturn(expectedLikedNews);

      final result = useCase.execute();

      expect(result, expectedLikedNews);
      verify(() => mockRepository.getLikedNews()).called(1);
    });
  });
}
