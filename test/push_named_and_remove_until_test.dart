import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular_test/flutter_modular_test.dart';
import 'package:mockito/mockito.dart';

const String _routePage1 = '/page1';
const String _routePage2 = '/page2';
const String _routePage3 = '/page3';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  testWidgets(
    'eve fechar todas as rotas e criar uma nova.',
    (WidgetTester tester) async {
      setUp(() {
        initModule(WidgetModule(), initialModule: true);
      });

      final mockObserver = MockNavigatorObserver();
      await tester.pumpWidget(
        ModularApp(
          module: WidgetModule(),
          child: MaterialApp(
            initialRoute: Modular.initialRoute,
            navigatorObservers: [mockObserver],
          ).modular(),
        ),
      );

      expect(find.byType(PageWidget), findsOneWidget);
      /* await tester.tap(find.byType(RaisedButton));
      await tester.pumpAndSettle();

      /// Verify that a push event happened
      verify(mockObserver.didPush(any, any));

      /// You'd also want to be sure that your page is now
      /// present in the screen.
      expect(find.byType(DetailsPage), findsOneWidget); */
    },
  );
}

class WidgetModule extends Module {
  @override
  //Lista de rotas.
  List<ModularRoute> get routes => [
        ChildRoute(Modular.initialRoute,
            child: (_, __) => PageWidget('Página 1')),
        ChildRoute(_routePage1, child: (_, __) => PageWidget('Página 1')),
        ChildRoute(_routePage2, child: (_, __) => PageWidget('Página 2')),
        ChildRoute(_routePage3, child: (_, __) => PageWidget('Página 3')),
      ];
}

class PageWidget extends StatelessWidget {
  PageWidget(this.title, {Key? key}) : super(key: key) {
    print("testando...");
  }
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
    );
  }
}
