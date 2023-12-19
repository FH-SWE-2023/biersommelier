import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biersommelier/components/Post.dart';

void main() {
  testWidgets('Testing of Post Constructor', (WidgetTester tester) async {
    // Initialization for all the required values of Post
    final tImage = Image.asset('assets/demo/Beitrag.jpg');
    const tDescription = 'Test Description';
    const tBar = 'Test Bar';
    final tCreated = DateTime.now();
    const tBeer = 'Test Beer';
    const tRating = 3;

    // Creating a Post Object
    final post = Post(
      image: tImage,
      description: tDescription,
      bar: tBar,
      created: tCreated,
      beer: tBeer,
      rating: tRating,
    );

    // Asserting if all values are correctly set
    expect(post.image, equals(tImage));
    expect(post.description, equals(tDescription));
    expect(post.bar, equals(tBar));
    expect(post.created, equals(tCreated));
    expect(post.beer, equals(tBeer));
    expect(post.rating, equals(tRating));
  });

  testWidgets('Testing if Post is displayed correctly', (WidgetTester tester) async {
    // Initialization for all the required values of Post
    final tImage = Image.asset('assets/demo/Beitrag.jpg');
    const tDescription = 'Test Description';
    const tBar = 'Test Bar';
    final tCreated = DateTime.now();
    const tBeer = 'Test Beer';
    const tRating = 3;

    // Build a test scenario
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Post(
            image: tImage,
            description: tDescription,
            bar: tBar,
            created: tCreated,
            beer: tBeer,
            rating: tRating,
          ),
        ),
      ),
    );

    // Assert if the Post is displayed correctly
    expect(find.text('"$tDescription"'), findsOneWidget);
    expect(find.text(tBar), findsOneWidget);
    expect(find.text(tBeer), findsOneWidget);
    expect(find.byIcon(Icons.more_horiz), findsOneWidget);
    await tester.tap(find.byIcon(Icons.more_horiz));
    await tester.pump();
  });
}