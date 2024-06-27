import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_feed/features/news/presentation/feed/bloc/news_bloc.dart';
import 'package:news_feed/features/news/presentation/feed/news_feed_screen.dart';
import 'package:bloc_test/bloc_test.dart';

class MockNewsBloc extends MockBloc<NewsEvent, NewsState> implements NewsBloc {}

void main() {
  group('NewsFeedScreen', () {
    late MockNewsBloc newsBloc;

    setUp(() {
      newsBloc = MockNewsBloc();
    });

    tearDown(() {
      newsBloc.close();
    });

    Widget createWidgetUnderTest() {
      return MaterialApp(
        home: BlocProvider<NewsBloc>.value(
          value: newsBloc,
          child: const NewsFeedScreen(),
        ),
      );
    }

    testWidgets('displays loading indicator when state is NewsInitial',
            (tester) async {
          when(() => newsBloc.state).thenReturn(NewsInitial());

          await tester.pumpWidget(createWidgetUnderTest());

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });

      // testWidgets('triggers NewsFetched event when scrolled to the bottom', (tester) async {
      //   when(() => newsBloc.state).thenReturn(NewsLoaded(newsList: [], currentPage: 0, reachedMax: false));
      //   await tester.pumpWidget(createWidgetUnderTest());
      //   await tester.pumpAndSettle();
      //   final listViewFinder = find.byType(ListView);
      //   expect(listViewFinder, findsOneWidget);
      //   await tester.drag(listViewFinder, const Offset(0, -5000));
      //   await tester.pumpAndSettle();
      //   verify(() => newsBloc.add(NewsFetched())).called(1);
      // });



  });
}
