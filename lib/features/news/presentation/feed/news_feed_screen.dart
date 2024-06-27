import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_feed/features/news/presentation/feed/bloc/news_bloc.dart';
import 'package:news_feed/features/news/presentation/feed/widgets/news_post_widget.dart';
import 'package:news_feed/features/news/presentation/post_detail/post_detail_screen.dart';

import '../../domain/entity/news.dart';

class NewsFeedScreen extends StatefulWidget {
  const NewsFeedScreen({super.key});

  @override
  State<NewsFeedScreen> createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsFailed) {
            return const Center(child: Text('Failed to fetch news'));
          } else if (state is NewsLoaded) {
            if (state.newsList.isEmpty) {
              return const Center(child: Text('Empty'));
            }
            return ListView.separated(
              separatorBuilder: (context, index) {
                return const Column(
                  children: [
                    SizedBox(height: 7),
                    Divider(),
                    SizedBox(height: 7),
                  ],
                );
              },
              itemBuilder: (BuildContext context, int index) {
                News news = state.newsList[index];
                return index >= state.newsList.length
                    ? const Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(strokeWidth: 1.5),
                        ),
                      )
                    : NewsPost(
                        news: news,
                        index: index,
                        onTap: () {
                          Navigator.of(context)
                              .push(
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation) {
                                return PostDetailScreen(
                                  news: news,
                                  index: index,
                                  onLike: () {
                                    context.read<NewsBloc>().add(NewsLiked(
                                        news: news, isLike: !news.isLiked));
                                    setState(() {
                                      news.isLiked = !news.isLiked;
                                    });
                                  },
                                );
                              },
                              transitionsBuilder: (BuildContext context,
                                  Animation<double> animation,
                                  Animation<double> secondaryAnimation,
                                  Widget child) {
                                return Align(
                                  child: FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  ),
                                );
                              },
                            ),
                          )
                              .then((_) {
                            setState(() {});
                          });
                        },
                        onLike: () {
                          context.read<NewsBloc>().add(
                              NewsLiked(news: news, isLike: !news.isLiked));
                          setState(() {
                            news.isLiked = !news.isLiked;
                          });
                        },
                      );
              },
              itemCount: state.newsList.length,
              controller: _scrollController,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<NewsBloc>().add(NewsFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
