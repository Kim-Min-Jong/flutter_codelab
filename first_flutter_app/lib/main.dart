import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(const MyApp());
}

// StatelessWidget을 가진 메인클래스스
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 필수 오버라이드 
  @override
  Widget build(BuildContext context) {
    // ChangeNotifier에를 통해 변경알림 제공
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: "Namer App",
        theme: ThemeData(
            useMaterial3: true,
            colorScheme:
                ColorScheme.fromSeed(seedColor: Colors.deepOrangeAccent)),
        home: MyHomePage(),
      ),
    );
  }
}
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('A random idea:'),
          Text(appState.current.asLowerCase),
        ],
      ),
    );
  }
}
