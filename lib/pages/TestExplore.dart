import 'package:flutter/material.dart';

import '../components/ExploreTabList.dart';

/// Ein anderes Fenster. Dieses wird nicht bestehen bleiben
/// und ist nur für die Routerdemo da
class TestExplore extends StatelessWidget {
  const TestExplore({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExploreBar(), // This should be the main content of the scaffold.
    );
  }
}
