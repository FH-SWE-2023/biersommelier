import 'dart:math';

import 'package:biersommelier/components/Header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main(){
  testWidgets('Header Widget Test', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Header(
              title: 'Header Test!',
              backgroundColor: Colors.white,
              icon: HeaderIcon.none
            ),
          ),
        ),
      );

      expect(find.text('Header Test!'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);
    });

    testWidgets('Header Widget with add', (WidgetTester tester) async{
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
          body: Header(
              title: 'Header with add',
              backgroundColor: Colors.white,
              icon: HeaderIcon.add,
            ),
          ),
        ),
      );

      expect(find.text('Header with add'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);
   });

   testWidgets('Header Widget with back arrow', (WidgetTester tester) async{
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
          body: Header(
            title: 'Header with back Arrow',
            backgroundColor: Colors.white,
            icon: HeaderIcon.back,
          ),
        ),
        )
      );

      expect(find.text('Header with back Arrow'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
   });

   testWidgets('Header Widget with add calls correct Function', (WidgetTester tester) async{
      bool addispressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
          body: Header(
              title: 'Header with add and Callback',
              backgroundColor: Colors.white,
              icon: HeaderIcon.add,
              onAdd: () {
                addispressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Header with add and Callback'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left_rounded), findsNothing);
      expect(addispressed, isFalse);

      await tester.tap(find.byIcon(Icons.add));
      expect(addispressed, isTrue);
   });

   testWidgets('Header Widget with back arrow calls correct Function', (WidgetTester tester) async{
      bool backispressed = false;
    
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
          body: Header(
            title: 'Header with back Arrow',
            backgroundColor: Colors.white,
            icon: HeaderIcon.back,
            onBack: () {
              backispressed = true;
            },
          ),
        ),
        )
      );

      expect(find.text('Header with back Arrow'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);

      await tester.tap(find.byIcon(Icons.chevron_left_rounded));
      expect(backispressed, isTrue);
   });
}