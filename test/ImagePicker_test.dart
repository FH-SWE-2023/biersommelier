import 'dart:io';

import 'package:biersommelier/components/ImagePicker.dart';
import 'package:biersommelier/imagemanager/ImageManager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

class MockImageManager extends Mock implements ImageManager {}

@GenerateMocks([MockImageManager])
void main() {
  testWidgets('Select and display image', (WidgetTester tester) async {
    final mockImageManager = MockImageManager();

    // Ensure the path is valid for your testing environment
    String testImagePath = 'assets/test/testimage.png';

    Future<String?>? futurePath = Future.value(testImagePath);

    // Mock the pickImage method to return a Future<File>
    when(mockImageManager.pickImage()).thenAnswer((_) => futurePath.then((path) => File(path!)));

    await tester.pumpWidget(MaterialApp(
      home: ImagePickerWidget(
        onImageSelected: (File? file) {
          expect(file?.path, equals('assets/test/testimage.png'));
        },
        imageManager: mockImageManager,
      ),
    ));

    await tester.tap(find.byType(ImagePickerWidget));
    await tester.pumpAndSettle();
  });

  testWidgets('Display placeholder image', (WidgetTester tester) async {
    final mockImageManager = MockImageManager();

    // Mock the pickImage method to return null
    when(mockImageManager.pickImage()).thenAnswer((_) => Future.value(null));

    await tester.pumpWidget(MaterialApp(
      home: ImagePickerWidget(
        onImageSelected: (File? file) {
          expect(file, isNull);
        },
        imageManager: mockImageManager,
      ),
    ));

    await tester.tap(find.byType(ImagePickerWidget));
    await tester.pumpAndSettle();
  });

  testWidgets('Display options popup menu', (WidgetTester tester) async {
    final mockImageManager = MockImageManager();

    // Ensure the path is valid for your testing environment
    String testImagePath = 'assets/test/testimage.png';

    Future<String?>? futurePath = Future.value(testImagePath);

    // Mock the pickImage method to return a Future<File>
    when(mockImageManager.pickImage()).thenAnswer((_) => futurePath.then((path) => File(path!)));

    await tester.pumpWidget(MaterialApp(
      home: ImagePickerWidget(
        onImageSelected: (File? file) {
          expect(file?.path, equals('assets/test/testimage.png'));
        },
        imageManager: mockImageManager,
      ),
    ));

    await tester.tap(find.byType(ImagePickerWidget));
    await tester.pumpAndSettle();

    await tester.longPress(find.byType(ImagePickerWidget));
    await tester.pumpAndSettle();

    expect(find.text('Bild ersetzen'), findsOneWidget);
    expect(find.text('Bild löschen'), findsOneWidget);
  });

  testWidgets('Replace image', (WidgetTester tester) async {
    final mockImageManager = MockImageManager();

    // Ensure the path is valid for your testing environment
    String testImagePath = 'assets/test/testimage.png';

    Future<String?>? futurePath = Future.value(testImagePath);

    // Mock the pickImage method to return a Future<File>
    when(mockImageManager.pickImage()).thenAnswer((_) => futurePath.then((path) => File(path!)));

    await tester.pumpWidget(MaterialApp(
      home: ImagePickerWidget(
        onImageSelected: (File? file) {
          expect(file?.path, equals('assets/test/testimage.png'));
        },
        imageManager: mockImageManager,
      ),
    ));

    await tester.tap(find.byType(ImagePickerWidget));
    await tester.pumpAndSettle();

    await tester.longPress(find.byType(ImagePickerWidget));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bild ersetzen'));
    await tester.pumpAndSettle();
  });

  testWidgets('Delete image', (WidgetTester tester) async {
    final mockImageManager = MockImageManager();

    // Ensure the path is valid for your testing environment
    String testImagePath = 'assets/test/testimage.png';

    Future<String?>? futurePath = Future.value(testImagePath);

    // Mock the pickImage method to return a Future<File>
    when(mockImageManager.pickImage()).thenAnswer((_) => futurePath.then((path) => File(path!)));

    await tester.pumpWidget(MaterialApp(
      home: ImagePickerWidget(
        onImageSelected: (File? file) {
          expect(file, isNull);
        },
        imageManager: mockImageManager,
      ),
    ));

    await tester.tap(find.byType(ImagePickerWidget));
    await tester.pumpAndSettle();

    await tester.longPress(find.byType(ImagePickerWidget));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bild löschen'));
    await tester.pumpAndSettle();
  });
}