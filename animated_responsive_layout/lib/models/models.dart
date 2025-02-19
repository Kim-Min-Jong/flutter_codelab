class Attachment {
  
  // 필수 생성자 생성
  const Attachment( {
    required this.url,
  } );

  final String url;
}

class Email{
  // 생성자 조건 설정
  const Email ( {
    required this.sender,
    required this.recipients,
    required this.subject,
    required this.content,
    this.replies = 0,
    this.attachments = const []
  });

  // 클래스 컴포넌트
  final User sender;
  final List<User> recipients;
  final String subject;
  final String content;
  final List<Attachment> attachments;
  final double replies; 
}

class Name {
  const Name({
    required this.first,
    required this.last,
  });

  final String first;
  final String last;
  // getter 생성성
  String get fullName => '$first $last';
}

class User {
  const User({
    required this.name,
    required this.avatarUrl,
    required this.lastActive,
  });

  final Name name;
  final String avatarUrl;
  final DateTime lastActive;
}