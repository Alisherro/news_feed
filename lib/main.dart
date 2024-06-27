import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:news_feed/news_feed_app.dart';

import 'dependencies_injection.dart';

void main() => runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        //внедрение зависимостей
        await setupLocator();
        return SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ],
        ).then((_) => runApp(const NewsFeedApp()));
      },
      (error, stackTrace) {
        //можно бабахнуть крашлитиксы
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
      },
    );
