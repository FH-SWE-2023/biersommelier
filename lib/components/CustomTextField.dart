import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// CustomTextField is a stateless widget that provides a text input field with custom styling.
class CustomTextField extends TextField {
  CustomTextField({
    required BuildContext context,
    super.key,
    super.controller,
    super.focusNode,
    InputDecoration? decoration,
    super.keyboardType,
    super.textInputAction,
    super.textCapitalization,
    super.strutStyle,
    super.textAlign,
    super.textDirection,
    super.readOnly,
    super.toolbarOptions,
    super.showCursor,
    super.autofocus,
    super.obscuringCharacter,
    super.obscureText,
    super.autocorrect,
    super.smartDashesType,
    super.smartQuotesType,
    super.enableSuggestions,
    super.maxLengthEnforcement,
    super.maxLength,
    super.style,
    super.onEditingComplete,
    super.onChanged,
    super.onTap,
    super.inputFormatters,
    super.enabled,
    super.scrollPadding,
    bool super.enableInteractiveSelection = true,
    super.selectionControls,
    super.onSubmitted,
    super.autofillHints = null,
    MouseCursor? cursor,
    super.enableIMEPersonalizedLearning = false,
    String labelText = "",
  }) : super(
          decoration: getCustomInputDecoration(context, labelText),
          mouseCursor: cursor,
        );
}

/// Returns a custom input decoration for a text field.
InputDecoration getCustomInputDecoration(
    BuildContext context, String labelText) {
  return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.never,
      labelText: labelText,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(16),
      ),
      labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
          fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize),
      fillColor: Theme.of(context).colorScheme.onPrimary);
}

/// TextFieldWithLabel is a stateless widget that provides a text input field with a label.
class TextFieldWithLabel extends StatelessWidget {
  final String label;
  final CustomTextField textField;

  const TextFieldWithLabel({
    super.key,
    required this.label,
    required this.textField,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
          ),
          textField,
        ]));
  }
}
