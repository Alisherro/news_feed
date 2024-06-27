import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:news_feed/features/news/data/datasource/news_datasource_local.dart';
import 'package:news_feed/features/news/data/datasource/news_datasource_remote.dart';
import 'package:news_feed/features/news/data/repository/news_repository_impl.dart';
import 'package:news_feed/features/news/domain/repository/news_repository.dart';
import 'package:news_feed/features/news/presentation/feed/bloc/news_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/api/dio_client.dart';
import 'features/news/domain/usecase/get_liked_news_use_case.dart';
import 'features/news/domain/usecase/get_news_list_use_case.dart';
import 'features/news/domain/usecase/like_news_use_case.dart';

GetIt sl = GetIt.I;

FutureOr<void> setupLocator() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  sl.registerSingleton<DioClient>(DioClient());

  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  //datasources
  sl.registerSingleton<NewsDatasourceRemote>(NewsDatasourceRemoteImpl(sl()));
  sl.registerSingleton<NewsDatasourceLocal>(NewsDatasourceLocalImpl(sl()));

  //repositories
  sl.registerSingleton<NewsRepository>(NewsRepositoryImpl(sl(), sl()));

  //usecases

  sl.registerSingleton<GetNewsListUseCase>(GetNewsListUseCase(sl()));
  sl.registerSingleton<GetLikedNewsUseCase>(GetLikedNewsUseCase(sl()));
  sl.registerSingleton<LikeNewsUseCase>(LikeNewsUseCase(sl()));

  //bloc
  sl.registerSingleton<NewsBloc>(NewsBloc(sl(), sl()));
}
