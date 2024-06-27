part of 'news_bloc.dart';

@immutable
sealed class NewsEvent extends Equatable {
  const NewsEvent();
  @override
  List<Object> get props => [];
}

final class NewsFetched extends NewsEvent {}
final class NewsLiked extends NewsEvent {
  const NewsLiked({required this.news, required this.isLike});
  final News news;
  final bool isLike;
}