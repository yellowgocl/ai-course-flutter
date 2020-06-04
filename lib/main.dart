import 'package:course/api/http.dart';
import 'package:course/config/config.dart';
import 'package:course/core/app.dart';
import 'package:course/core/gameController.dart';
import 'package:course/models/core/video_player_state.dart';
import 'package:course/utils/themeUtil.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

void main () async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.light,
  ));
  // Screen.keepOn(true);
  Environment.env = Env.dev;
  debugPaintSizeEnabled = Environment.env != Env.dev;
  http.initialize(null);
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIOverlays([]);
  await Future.delayed(Duration(milliseconds: 100));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => gameController,
        ),
        ChangeNotifierProvider(
          create: (_) => VideoPlayerState(),
        )
      ],
      child: MaterialApp(        
        title: 'Flutter Demo',
        theme: ThemeUtil.theme,
        home: App()
    ));
  }
}

