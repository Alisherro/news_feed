import '../repository/news_repository.dart';

class GetLikedNewsUseCase {
  final NewsRepository repository;

  GetLikedNewsUseCase(this.repository);

  Map<String, bool> execute() {
    return repository.getLikedNews();
  }
}