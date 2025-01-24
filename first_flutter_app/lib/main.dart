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

  void getNext() {
    // 임의의 새 WordPair를 current에 재할당
    current = WordPair.random();
    // MyAppState를 보고 있는 사람에게 알림을 보내는 notifyListeners()(ChangeNotifier)의 메서드)를 호출
    notifyListeners();
  }
}

// 상태를 가진 보여줄 화면면
class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // watch 메서드를 사용하여 앱의 현재 상태에 관한 변경사항을 추적
    var appState = context.watch<MyAppState>();
    // 전역 상태 방지
    var pair = appState.current;

    return Scaffold(
      body: Column(
        children: [
          Text('A random idea:'),
          // WordPair는 asPascalCase 또는 asSnakeCase 등 여러 유용한 getter를 제공
          BigCard(pair: pair),

          ElevatedButton(
            onPressed: () {
              // 버튼 눌렀을 때마다다 새로운 WordPair를 생성
              appState.getNext();
            }, 
            child: Text("Next")
          )
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    // style 생성
    final theme = Theme.of(context);
     final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    // Padding 생성
    return Card(
      // 색상 설정 (앱의 기본 테마 색)
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(pair.asLowerCase, style: style,),
      ),
    );
  }
}
