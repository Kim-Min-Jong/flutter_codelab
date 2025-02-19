import 'package:flutter/material.dart'; // 플러터 내장 패키지를 가졍옴

// 프로젝트 내 파일 가져옴
import '../../models/data.dart' as data;
import '../../models/models.dart';
import '../email_widget.dart';
import '../search_bar.dart' as search_bar;

class EmailListView extends StatelessWidget {
  const EmailListView({
    super.key,
    this.selectedIndex,
    this.onSelected,
    required this.currentUser,
  });

  final int? selectedIndex;
  // ValueChanged -> value 값이 바뀌면 함수가 실행됨 --> 콜백 트리거 느낌
  // 이 변수의 변화를 주시
  final ValueChanged<int>? onSelected;
  final User currentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListView(
        // 리스트 뷰의 하위요소소
        children: [
          // 공뱍
          const SizedBox(
            height: 8,
          ),
          // 검색 바
          search_bar.SearchBar(currentUser: currentUser),
          // 공백
          const SizedBox(
            height: 8,
          ),
          // 리스트를 통한 새로운 UI
          ...List.generate(data.emails.length, (index) {
            return Padding (padding: const EdgeInsets.only(bottom: 8.0),
            child: EmailWidget( // 커스텀 위젯젯
              email: data.emails[index],
              onSelected: onSelected != null
                      ? () {
                          onSelected!(index);
                        }
                      : null,
              isSelected: selectedIndex == index,
            ),)
          })
        ],
      ),
    );
  }
}
