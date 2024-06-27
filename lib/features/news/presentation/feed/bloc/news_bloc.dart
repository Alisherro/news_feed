import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:news_feed/features/news/domain/usecase/like_news_use_case.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../domain/entity/news.dart';
import '../../../domain/usecase/get_news_list_use_case.dart';

part 'news_event.dart';

part 'news_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc( this.getNewsListUseCase, this.likeNewsUseCase) : super(NewsInitial()) {
    on<NewsEvent>((event, emit) async {
      switch (event) {
        case NewsFetched():
          await _onNewsFetched(event, emit);
          case NewsLiked():
          await _newsLiked(event, emit);
      }
    }, transformer: throttleDroppable(throttleDuration));
  }

  final GetNewsListUseCase getNewsListUseCase;
  final LikeNewsUseCase likeNewsUseCase;

  Future<void> _onNewsFetched(
      NewsFetched event, Emitter<NewsState> emit) async {
    if (state is NewsLoaded && (state as NewsLoaded).reachedMax) return;
    if (state is NewsInitial || state is NewsFailed) {
      final res = await getNewsListUseCase.execute(0);
      res.fold((l) {
        emit(const NewsFailed());
      }, (r) {
        emit(NewsLoaded(
          newsList: r,
          currentPage: 0,
          reachedMax: false,
        ));
      });
    } else if (state is NewsLoaded) {
      final curState = (state as NewsLoaded);
      int page = 1 + curState.currentPage;
      final res = await getNewsListUseCase.execute(page);
      res.fold(
        (l) {
          emit(const NewsFailed());
        },
        (r) {
          emit(
            r.isEmpty
                ? curState.copyWith(reachedMax: true)
                : curState.copyWith(
                    newsList: List.of(curState.newsList)..addAll(r),
                    currentPage: page),
          );
        },
      );
    }
  }

  Future<void> _newsLiked(NewsLiked event, Emitter<NewsState> emit) async{
    likeNewsUseCase.execute(event.news, event.isLike);
  }
}
