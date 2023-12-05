import 'package:flutter/material.dart';

/// Ein Knopf mit dem Stil aus dem Lastenheft.
///
/// Beispielaufruf:
/// ```dart
/// ActionButton(child: Text('Hello World!'))
/// ```
class ActionButton extends StatelessWidget {
  final Function()? onPressed;
  final Widget child;
  final bool loading;

  const ActionButton({
    super.key,
    this.onPressed,
    required this.child,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.secondary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: loading
          ? CircularProgressIndicator(
              color: Theme.of(context).colorScheme.secondary,
            )
          : child,
    );
  }
}
