import 'package:biersommelier/components/CustomTextField.dart';
import 'package:biersommelier/theme/theme.dart';
import 'package:flutter/material.dart';

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

  const DropdownInputField(
      {super.key,
      required this.labelText,
      required this.optionsList,
      required this.onOptionSelected});

  @override
  Widget build(BuildContext context) {
    // The Autocomplete widget that provides the functionality of the dropdown input field.
    return Autocomplete<Option>(
      // Determines how the selected option is displayed in the input field.
      displayStringForOption: (Option option) => option.name,
      // Used to filter the options based on the user's input.
      optionsBuilder: (TextEditingValue textEditingValue) {
        return optionsList.where((Option option) {
          return (option.name + (option.address ?? ""))
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase());
        });
      },
      // Used to build the input field and its decorations.
      fieldViewBuilder: (BuildContext context,
          TextEditingController textEditingController,
          FocusNode focusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
            controller: textEditingController,
            focusNode: focusNode,
            onFieldSubmitted: (String value) {
              onFieldSubmitted();
            },
            decoration: getCustomInputDecoration(context, labelText));
      },
      // Used to build the dropdown list of options.
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<Option> onSelected, Iterable<Option> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: const EdgeInsets.only(top: 3),
            child: Material(
              elevation: 4.0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.lightBorder,
                    style: BorderStyle.solid,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: options
                      .map((Option option) => GestureDetector(
                            onTap: () {
                              onSelected(option);
                              onOptionSelected(option);
                            },
                            child: ListTile(
                              dense: true,
                              title: Row(
                                children: [
                                  Image.asset('assets/icons/${option.icon}',
                                      width: 21,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                                  const SizedBox(width: 16),
                                  Flexible(
                                      child: Text("${option.name} ",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                              overflow:
                                                  TextOverflow.ellipsis))),
                                  Flexible(
                                      child: Text(option.address ?? "",
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                              fontSize: 16,
                                              overflow: TextOverflow.ellipsis)))
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
