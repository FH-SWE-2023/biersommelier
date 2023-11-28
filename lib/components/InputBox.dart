import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
          padding: EdgeInsets.all(16.0),
          child: Column(
          
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              this.label,
              style: Theme.of(context).textTheme.bodyLarge
              ),
            this.textField,
          ]
        )
        );
  }
}

class CustomTextField extends TextField {

  CustomTextField({
    required BuildContext context,
    Key? key,
    TextEditingController? controller,
    FocusNode? focusNode,
    InputDecoration? decoration,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    TextCapitalization textCapitalization = TextCapitalization.none,
    StrutStyle? strutStyle,
    TextAlign textAlign = TextAlign.start,
    TextDirection? textDirection,
    bool readOnly = false,
    ToolbarOptions? toolbarOptions,
    bool? showCursor,
    bool autofocus = false,
    String obscuringCharacter = '•',
    bool obscureText = false,
    bool autocorrect = true,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    bool enableSuggestions = true,
    MaxLengthEnforcement? maxLengthEnforcement,
    int? maxLength,
    TextStyle? style,
    void Function()? onEditingComplete,
    ValueChanged<String>? onChanged,
    GestureTapCallback? onTap,
    List<TextInputFormatter>? inputFormatters,
    bool? enabled,
    EdgeInsets scrollPadding = const EdgeInsets.all(20.0),
    bool enableInteractiveSelection = true,
    TextSelectionControls? selectionControls,
    void Function(String)? onSubmitted,
    Iterable<String>? autofillHints,
    MouseCursor? cursor,
    bool enableIMEPersonalizedLearning = false,
    String labelText="",
  }) : super(
          key: key,
          controller: controller,
          focusNode: focusNode,
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
                color: const Color.fromRGBO(69, 50, 0, 1), 
                fontSize: Theme.of(context).textTheme.bodyLarge?.fontSize
                ),
              fillColor:Theme.of(context).colorScheme.onPrimary,  //HIER FEHLER!!!!!
          ),
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          style: style,
          strutStyle: strutStyle,
          textAlign: textAlign,
          textDirection: textDirection,
          readOnly: readOnly,
          toolbarOptions: toolbarOptions,
          showCursor: showCursor,
          autofocus: autofocus,
          obscuringCharacter: obscuringCharacter,
          obscureText: obscureText,
          autocorrect: autocorrect,
          smartDashesType: smartDashesType,
          smartQuotesType: smartQuotesType,
          enableSuggestions: enableSuggestions,
          maxLengthEnforcement: maxLengthEnforcement,
          maxLength: maxLength,
          onEditingComplete: onEditingComplete,
          onChanged: onChanged,
          onTap: onTap,
          inputFormatters: inputFormatters,
          enabled: enabled,
          scrollPadding: scrollPadding,
          enableInteractiveSelection: enableInteractiveSelection,
          selectionControls: selectionControls,
          onSubmitted: onSubmitted,
          autofillHints: autofillHints,
          mouseCursor: cursor,
          enableIMEPersonalizedLearning: enableIMEPersonalizedLearning,
        );
}
