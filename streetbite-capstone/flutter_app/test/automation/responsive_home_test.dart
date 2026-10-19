import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:street_bite_test/presentation/widgets/home/meal_grid_widget.dart';

import 'base_automation.dart';

class ResponsiveHomeAutomation extends BaseTest {
  void register() {
    for (final size in [const Size(390, 844), const Size(800, 1280)]) {
      testWidgets('meal grid stays two columns at ${size.width} px', (
        tester,
      ) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(body: MealGridWidget(meals: [])),
          ),
        );

        final grid = tester.widget<GridView>(find.byType(GridView));
        final delegate =
            grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
        expect(delegate.crossAxisCount, 2);
        expect(delegate.childAspectRatio, size.width >= 600 ? 0.9 : 0.65);
        expect(tester.takeException(), isNull);
      });
    }
  }
}

void main() => ResponsiveHomeAutomation().register();
