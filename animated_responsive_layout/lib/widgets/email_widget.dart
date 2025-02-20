import 'package:flutter/material.dart';
import '../models/models.dart';
import 'star_button.dart';

// 이메일 타입을 지정할 enum 클래스
enum EmailType {
  preview,
  threaded,
  primaryThreaded,
}

class EmailWidget extends StatefulWidget {
  // 생성자 정의
  const EmailWidget({
    super.key,
    required this.email,
    this.isSelected = false,
    this.isPreview = true,
    this.isThreaded = false,
    this.showHeadline = false,
    this.onSelected,
  });

  // 클래스 변수수
  final bool isSelected;
  final bool isPreview;
  final bool showHeadline;
  final bool isThreaded;
  final void Function()? onSelected;
  final Email email;

  // 클래스의 상태, 상태에 따라 UI가 변화
  @override
  State<EmailWidget> createState() => _EmailWidgetState();
}

class _EmailWidgetState extends State<EmailWidget> {
  // 기본 변수수
  late final ColorScheme _colorScheme = Theme.of(context).colorScheme;
  late Color unselectedColor = Color.alphaBlend(
      _colorScheme.primary.withOpacity(0.08), _colorScheme.surface);
  
  // widget의 상태에 따라 색을 변경하는 변수 getter
  Color get _surfaceColor => switch (widget) {
        EmailWidget(isPreview: false) => _colorScheme.surface,
        EmailWidget(isSelected: true) => _colorScheme.primaryContainer,
        _ => unselectedColor,
      };
  
  @override
  Widget build(BuildContext context) {
      // 사용자 동작을 감지하는 위젯
      return GestureDetector(
        onTap: widget.onSelected,
        child: Card(elevation: 0,
        color: _surfaceColor,
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showHeadline) ...[
              EmailHeadline(
                email: widget.email,
                isSelected: widget.isSelected,
              ),
            ],
            EmailContent(
              email: widget.email,
              isPreview: widget.isPreview,
              isThreaded: widget.isThreaded,
              isSelected: widget.isSelected,
            ),
          ],),),
      );
  }
}

class EmailContent extends StatefulWidget {
  const EmailContent({
    super.key,
    required this.email,
    required this.isPreview,
    required this.isThreaded,
    required this.isSelected,
  });

  final Email email;
  final bool isPreview;
  final bool isThreaded;
  final bool isSelected;

  @override
  State<EmailContent> createState() => _EmailContentState();
}