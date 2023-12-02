import 'package:flutter/material.dart';

///Einfacher Button im App-Scheme
///
///Beispielhafter Aufruf:
///CTAButton(
/// context: context,
///         child: Text('Hinzufügen'),
///      onPressed: () {
///     print("Hello");
///},
///isLoading: false,
///),
///
class CTAButton extends TextButton {
  final bool isLoading;

  CTAButton({
    required BuildContext context,
    super.key,
    required super.onPressed,
    required Widget child,
    super.focusNode,
    super.autofocus,
    super.clipBehavior,
    ButtonStyle? style,
    MaterialStatesController? statesController,
    super.onFocusChange,
    super.onHover,
    super.onLongPress,
    this.isLoading = false,
  }) : super(
          child: isLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                )
              : child,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
}
