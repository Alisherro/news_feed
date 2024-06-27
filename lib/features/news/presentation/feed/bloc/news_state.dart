part of 'news_bloc.dart';

abstract class NewsState extends Equatable {
  const NewsState();
}

 class NewsInitial extends NewsState {
  @override
  List<Object?> get props => [];
}

class NewsLoaded extends NewsState {
  const NewsLoaded(
      {required this.newsList,
      required this.currentPage,
      required this.reachedMax});

  final List<News> newsList;
  final int currentPage;
  final bool reachedMax;

  @override
  List<Object> get props => [currentPage, newsList, reachedMax];

  NewsLoaded copyWith({
    List<News>? newsList,
    int? currentPage,
    bool? reachedMax,
  }) {
    return NewsLoaded(
      newsList: newsList ?? this.newsList,
      currentPage: currentPage ?? this.currentPage,
      reachedMax: reachedMax ?? this.reachedMax,
    );
  }
}

 class NewsFailed extends NewsState {
  const NewsFailed([this.message]);

  final String? message;

  @override
  List<Object?> get props => [];
}
