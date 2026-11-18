// package:web 의존 때문에 VM 에서는 컴파일되지 않는다.
//   flutter test --platform chrome test/login_page_test.dart
@TestOn('browser')
library login_page_test;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gnuch_mobile_webpage/login.dart';

void main() {
  testWidgets('AuthPage 가 예외 없이 렌더링된다', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AuthPage()));
    expect(tester.takeException(), isNull);

    expect(find.text("사번"), findsOneWidget);
    expect(find.text("비밀번호"), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "로그인"), findsOneWidget);
  });

  testWidgets('빈 값으로 로그인을 누르면 검증 메시지가 나온다', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AuthPage()));
    await tester.tap(find.widgetWithText(ElevatedButton, "로그인"));
    await tester.pump();

    expect(find.text("사번을 입력해 주세요"), findsOneWidget);
    expect(find.text("가온 비밀번호를 입력해주세요"), findsOneWidget);
  });
}
