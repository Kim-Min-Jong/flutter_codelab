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

  // 좋아요 클릭 리스트
  var favorites = <WordPair>[];
  
  // 토글이벤트
  void toggleFavorites() {
    // 리스트의 포함 여부에 따라 동작
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    // 리스트 동작 후 이벤트 알리기기
    notifyListeners();
  }
}

// 탐색 레일을 가진 상위 화면
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// 많은 상태를 담기 위한 상태 클래스
// Widget에서 상태를 담으면 너무 무거워짐짐
class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {

    // 페이지 전환을 위한 변수
    Widget page;
    switch(selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError("no widget for $selectedIndex");
    }

          // 사사용할 수 있는 공간의 양에 따라 위젯 트리를 변경할 수
    return LayoutBuilder(
      builder: (context, constraint) {
        return Scaffold(
          body: Row(
            children: [
              // 하위 요소가 하드웨어 노치나 상태 표시줄로 가려지지 않도록 하는 위젯
              SafeArea(
                // NavigationRail를 래핑하여 탐색 버튼이 휴대기기 상태 표시줄로 가려지지 않도록함함
                child: NavigationRail(
                  extended: constraint.maxWidth >= 600,
                  // 네비게이션의 도착지 정의의
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  // 선택된 레일
                  selectedIndex: selectedIndex,
                  // 네비게이션 레일을 선택할 때 발생하는 이벤트트
                  onDestinationSelected: (value) {
                    setState(() {
                      // 선택된 레일의 인덱스를 저장장
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  // 네비게이션 하위 상세 페이지
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

// 상태를 가진 보여줄 화면면
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // watch 메서드를 사용하여 앱의 현재 상태에 관한 변경사항을 추적
    var appState = context.watch<MyAppState>();
    // 전역 상태 방지
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Scaffold(
      body: Center(
        child: Column(
          // 중앙 정렬
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('A random idea:'),
            // WordPair는 asPascalCase 또는 asSnakeCase 등 여러 유용한 getter를 제공
            BigCard(pair: pair),
            // 카드와 버튼 사이의 간격 제공공
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // 버튼 추가
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorites();
                  },
                  icon: Icon(icon),
                  label: Text('Like'),
                ),

                ElevatedButton(
                  onPressed: () {
                    // 버튼 눌렀을 때마다다 새로운 WordPair를 생성
                    appState.getNext();
                  }, 
                  child: Text("Next")
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
          ),
      ],
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
