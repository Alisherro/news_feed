import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_feed/features/news/presentation/feed/bloc/news_bloc.dart';

import 'dependencies_injection.dart';
import 'features/news/presentation/feed/news_feed_screen.dart';

class NewsFeedApp extends StatelessWidget {
  const NewsFeedApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return BlocProvider(
      create: (context) => sl.get<NewsBloc>()..add(NewsFetched()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Feed App",
        home: NewsFeedScreen(),
      ),
    );
  }
}
