import 'package:biersommelier/components/CustomRatingField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Custom Rating tests', () {
      testWidgets('Test Default Values', (WidgetTester tester) async{
        await tester.pumpWidget(
          MaterialApp(
            home: CustomRatingField(
              onRatingSelected: (rating) {},
            ),
          ),
        );

        expect(find.byType(CustomRatingField), findsOneWidget);
        expect(find.byWidgetPredicate(
            (widget) => 
              widget is Image &&
              (widget.image as AssetImage).assetName == 'assets/icons/review_empty.png',
          ),
          findsNWidgets(5),
        );
      });

      testWidgets('Test with initial Rating of 3', (WidgetTester tester) async{
        await tester.pumpWidget(
          MaterialApp(
            home: CustomRatingField(
              initialRating: 3,
              onRatingSelected: (rating) {},
            ),
          ),
        );

        expect(find.byType(CustomRatingField), findsOneWidget);
        expect(find.byWidgetPredicate(
          (widget) => 
            widget is Image &&
            (widget.image as AssetImage).assetName == 'assets/icons/review_empty.png',
        ),
        findsNWidgets(2),
        );
        expect(find.byWidgetPredicate(
          (widget) => 
            widget is Image &&
            (widget.image as AssetImage).assetName == 'assets/icons/review_full.png',
        ),
        findsNWidgets(3),
        );
      });

      testWidgets('Test if the User makes an input', (WidgetTester tester) async{
        int selectedRating = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: CustomRatingField(
              onRatingSelected: (rating) {
                selectedRating = rating;
              },
            ),
          ),
        );

        expect(selectedRating, 0);
        
        await tester.tap(find.byType(GestureDetector).at(1));

        await tester.pumpAndSettle();

        expect(selectedRating, 2);

        expect(find.byWidgetPredicate(
          (widget) => 
            widget is Image &&
            (widget.image as AssetImage).assetName == 'assets/icons/review_empty.png',
        ),
        findsNWidgets(3),
        );
        expect(find.byWidgetPredicate(
          (widget) => 
            widget is Image &&
            (widget.image as AssetImage).assetName == 'assets/icons/review_full.png',
        ),
        findsNWidgets(2),
        );
      });
  });
}