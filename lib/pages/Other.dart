import 'package:flutter/cupertino.dart';

/// Ein anderes Fenster. Dieses wird nicht bestehen bleiben
/// und ist nur für die Routerdemo da
class Other extends StatelessWidget {
  const Other({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Other'),
    );
  }
}
