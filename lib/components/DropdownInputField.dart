import 'package:biersommelier/components/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

abstract class DropdownOption {
  final String name;
  final String icon;
  final String? address;

  DropdownOption({required this.name, required this.icon, this.address});
}

/// DropdownInputField is a stateless widget that provides an input field with a dropdown list of options.
/// It uses the Autocomplete widget of Flutter to provide suggestions as the user types in the input field.
class DropdownInputField<Option extends DropdownOption> extends StatelessWidget {

  /// Label of the input field
  final String labelText;

  /// List of options to choose from
  final List<Option> optionsList;

  /// Function to call when a bar is selected
  final Function(Option) onOptionSelected;

  /// Default value of the input field
  final String? defaultValue;

  DropdownInputField({
    super.key,
    required this.labelText,
    required this.optionsList,
    required this.onOptionSelected,
    this.defaultValue,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadField(
      builder: (context, TextEditingController controller, FocusNode focusNode) {
        if (defaultValue != null) {
          controller.text = defaultValue!;
          focusNode.unfocus();
        }
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: false,
          decoration: getCustomInputDecoration(context, labelText),
        );
      },
      suggestionsCallback: (pattern) async {
        return optionsList.where((Option option) {
          return (option.name + (option.address ?? ""))
              .toLowerCase()
              .contains(pattern.toLowerCase());
        }).toList();
      },
      itemBuilder: (context, Option option) {
        return ListTile(
          dense: true,
          title: Row(
            children: [
              Image.asset('assets/icons/${option.icon}', width: 21, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(width: 16),
              Flexible(
                child: Text("${option.name} ", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16, overflow: TextOverflow.ellipsis)),
              ),
              Flexible(
                  child: Text(option.address ?? "", style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontSize: 16, overflow: TextOverflow.ellipsis))
              ),
            ],
          ),
        );
      },
      onSelected: (Option option) {
        onOptionSelected(option);
      },
    );
  }
}
