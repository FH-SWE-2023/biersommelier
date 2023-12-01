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
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
    FocusNode? focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    ButtonStyle? style,
    MaterialStatesController? statesController,
    ValueChanged<bool>? onFocusChange,
    ValueChanged<bool>? onHover,
    VoidCallback? onLongPress,
    this.isLoading = false,
  }) : super(
          key: key,
          onPressed: onPressed,
          child: isLoading
              ? CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                )
              : child,
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.secondary,
            backgroundColor: Theme.of(context).colorScheme.primary,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          onFocusChange: onFocusChange,
          onHover: onHover,
          onLongPress: onLongPress,
        );
}
