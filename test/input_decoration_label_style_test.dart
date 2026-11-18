import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// InputDecoration.labelStyle 에 inherit: false 스타일을 주면
// TextStyle.merge 가 "if (!other.inherit) return other;" 로 테마 스타일을 통째로
// 버리기 때문에 fontSize/textBaseline 이 null 인 채로 InputDecorator 에 전달되고,
// InputDecorator 는 labelStyle.textBaseline! 을 단언한다.
Widget _wrap(InputDecoration decoration) => MaterialApp(
      home: Scaffold(
        body: TextFormField(decoration: decoration),
      ),
    );

void main() {
  testWidgets('inherit:false labelStyle 는 InputDecorator 에서 터진다',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(
      const InputDecoration(
        labelText: "사번",
        labelStyle: TextStyle(inherit: false, color: Colors.black54),
      ),
    ));
    expect(tester.takeException(), isA<TypeError>());
  });

  testWidgets('inherit 기본값(true) labelStyle 은 정상 렌더링된다',
      (WidgetTester tester) async {
    await tester.pumpWidget(_wrap(
      const InputDecoration(
        labelText: "사번",
        labelStyle: TextStyle(color: Colors.black54),
      ),
    ));
    expect(tester.takeException(), isNull);
  });
}
