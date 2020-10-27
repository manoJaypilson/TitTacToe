import 'package:flutter/material.dart';
import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/core/theme_app.dart';
import 'package:tictactoe/pages/game_page.dart';
import 'package:custom_splash/custom_splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: GAME_TITLE,
        theme: themeApp,
        home: CustomSplash(
          imagePath: 'lib/assets/images/Tic_Tac_Toe.png',
          backGroundColor: Colors.redAccent,
          animationEffect: 'zoom-in',
          home: GamePage(),
          duration: 2500,
          type: CustomSplashType.StaticDuration,
        ));
  }
}
