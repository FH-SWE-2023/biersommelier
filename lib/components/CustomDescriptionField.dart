import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DescriptionFieldWithLabel extends StatelessWidget {

  final String label;
  final CustomDescriptionField textField;
  

  const DescriptionFieldWithLabel({
    super.key, 
    required this.label, 
    required this.textField,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 4, bottom: 4),
          child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
               padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge
              ),
            ),
            textField,
          ]
        )
        );
  }
}

class CustomDescriptionField extends TextField {

  CustomDescriptionField({
    required BuildContext context,
    super.key,
    maxLines = 5,
    minLines = 5,
    super.controller,
    super.focusNode,
    //InputDecoration? decoration,
    //TextInputType? keyboardType,
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
    String labelText="",
  }) : super(
          maxLines: maxLines,
          minLines: minLines,
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.never ,
            labelText: labelText,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.circular(10),
            ),
            labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.secondary, 
                fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize
                ),
              fillColor: Color.fromARGB(255, 240, 236, 225)
          ),
          keyboardType: TextInputType.multiline,
          mouseCursor: cursor,
        );
}
