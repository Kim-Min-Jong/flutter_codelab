import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_words/english_words.dart';

// main() 함수 
// 현재 형식으로는 MyApp에서 정의된 앱을 실행하라고 Flutter에 지시
void main() {
  runApp(const MyApp());
}

// StatelessWidget을 가진 메인클래스
// 위젯은 모든 Flutter 앱을 빌드하는 데 사용되는 요소
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

// 앱이 작동하는 데 필요한 데이터를 정의
// 상태가 만들어지고 ChangeNotifierProvider를 사용하여 전체 앱에 제공
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
}

// 상태를 가진 보여줄 화면면
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // watch 메서드를 사용하여 앱의 현재 상태에 관한 변경사항을 추적
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Column(
        children: [
          Text('A random idea:'),
          // WordPair는 asPascalCase 또는 asSnakeCase 등 여러 유용한 getter를 제공
          Text(appState.current.asLowerCase),

          ElevatedButton(
            onPressed: () {
              print("button pressed");
            }, 
            child: Text("Next")
          )
        ],
      ),
    );
  }
}
