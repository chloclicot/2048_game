
import 'package:app_test/game.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



void main() {

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Scorer())
      ],
      child: Game(),
    ),
  );
}