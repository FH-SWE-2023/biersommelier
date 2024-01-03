import 'dart:io';

import 'package:biersommelier/components/ImagePicker.dart';
import 'package:biersommelier/imagemanager/ImageManager.dart';
import 'package:biersommelier/router/rut/toast/Toast.dart';
import 'package:biersommelier/providers/PostChanged.dart';
import 'package:flutter/material.dart';

import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/CustomDateField.dart';
import 'package:biersommelier/components/CustomDescriptionField.dart';
import 'package:biersommelier/components/DropdownInputField.dart';
import 'package:biersommelier/components/CustomTimeField.dart';
import 'package:biersommelier/components/CustomRatingField.dart';
import 'package:biersommelier/components/ActionButton.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'package:biersommelier/database/entities/Post.dart';
import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/database/entities/Beer.dart';

import 'package:biersommelier/router/Rut.dart';
import 'package:biersommelier/router/rut/RutPath.dart';

class PostForm extends StatefulWidget {
  final Post? initialPost;
  final Function(Post) onSubmit;

  const PostForm({super.key, this.initialPost, required this.onSubmit});

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late int _rating;

  bool _isEditing = false;

  Bar? _bar;
  Beer? _beer;
  File? _image;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.initialPost != null) {
      _isEditing = true;
    }

    if (_isEditing) {
      // fill _bar and _beer using Bar.get(id) and Beer.get(id) which return Future<Bar> and Future<Beer> respectively
      Bar.get(widget.initialPost!.barId).then((bar) {
        setState(() {
          _bar = bar;
        });
      });

      Beer.get(widget.initialPost!.beerId).then((beer) {
        setState(() {
          _beer = beer;
        });
      });

      // fill image
      ImageManager.getImageFileByKey(widget.initialPost!.imageId).then((image) {
        if (widget.initialPost!.imageId != "") {
          setState(() {
            _image = image;
          });
        }
      });

      // Bar name
      _descriptionController =
          TextEditingController(text: widget.initialPost!.description);
      _selectedDate = widget.initialPost!.date;
      _rating = widget.initialPost!.rating;
    } else {
      _descriptionController = TextEditingController();
      _selectedDate = DateTime.now();
      _rating = 0;
    }

    _descriptionController.addListener(() {
      // block routing
      context.blockRouting();
    });
  }

  Future<void> _submitForm() async {
    if (_rating == 0) {
      context.showToast(
        Toast.levelToast(
          message: "Bitte fülle alle Felder aus!",
          level: ToastLevel.danger,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // context check
    if (!context.mounted) {
      return;
    }

    // Check if bar and beer exist, give error if not
    if (_bar == null || _beer == null) {
      context.showToast(
        Toast.levelToast(
          message: "Lokal oder Bier nicht gefunden!",
          level: ToastLevel.danger,
        ),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    String imageTag = '';

    if (_image != null) {
      imageTag = await ImageManager.saveImage(_image!);
    }

    // Create or update a Post object
    final post = Post(
      id: widget.initialPost?.id ?? const Uuid().v4(),
      imageId: imageTag,
      // Update as needed
      rating: _rating,
      barId: _bar!.id,
      beerId: _beer!.id,
      date: _selectedDate,
      description: _descriptionController.text,
    );

    // save to database with insert or update
    if (_isEditing) {
      await Post.update(post);
    } else {
      await Post.insert(post);
    }
    Provider.of<PostChanged>(context, listen: false).notify();

    // show toast
    if (context.mounted) {
      context.showToast(
        Toast.levelToast(
          message: "Beitrag hinzugefügt",
          level: ToastLevel.success,
        ),
      );
    }

    widget.onSubmit(post);
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Header(
              title: _isEditing ? "Bearbeiten" : "Hinzufügen",
              backgroundColor: Colors.white,
              icon: HeaderIcon.back,
              onBack: () {
                // route to logbuch
                context.jump(RutPage.log);
              },
            ),
          ),
          Expanded(
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildPaddedDropdownInputField(
                        context, "Lokal", Bar.getAll(), (selectedBar) {
                      // block routing
                      context.blockRouting();

                      setState(() {
                        _bar = selectedBar;
                      });
                    },
                        _isEditing
                            ? _bar?.name
                            : null), // set default value to the bar of the initial post if editing
                    buildPaddedDropdownInputField(
                        context, "Bier", Beer.getAll(), (selectedBeer) {
                      // block routing
                      context.blockRouting();

                      setState(() {
                        _beer = selectedBeer;
                      });
                    },
                        _isEditing
                            ? _beer?.name
                            : null), // set default value to the beer of the initial post if editing
                    CustomRatingField(
                      initialRating: _rating,
                      onRatingSelected: (rating) {
                        // block routing
                        context.blockRouting();

                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DateFieldWithLabel(
                            label: "Datum",
                            dateTimeFormField: CustomDateField(
                              context: context,
                              initialDate: _selectedDate,
                              initialValue: _selectedDate,
                              onDateSelected: (date) {
                                // block routing
                                context.blockRouting();

                                setState(() {
                                  // set DATE part of _selectedDate to the selected date
                                  _selectedDate = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    _selectedDate.hour,
                                    _selectedDate.minute,
                                  );
                                });
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          child: TimeFieldWithLabel(
                            label: "Uhrzeit",
                            dateTimeFormField: CustomTimeField(
                              context: context,
                              initialValue: _selectedDate,
                              initialDate: _selectedDate,
                              onDateSelected: (time) {
                                // block routing
                                context.blockRouting();

                                setState(() {
                                  // set TIME part of _selectedDate to the selected time
                                  _selectedDate = DateTime(
                                    _selectedDate.year,
                                    _selectedDate.month,
                                    _selectedDate.day,
                                    time.hour,
                                    time.minute,
                                  );
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    DescriptionFieldWithLabel(
                      label: "Beschreibung",
                      textField: CustomDescriptionField(
                        context: context,
                        controller: _descriptionController,
                        labelText: "Füge eine Beschreibung hinzu...",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
                            child: Text("Bild hinzufügen",
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                          Row(children: [
                            SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                height: MediaQuery.of(context).size.width / 2.5,
                                child: ImagePicker(
                                  onImageSelected: (file) {
                                    // block routing
                                    context.blockRouting();
                                    _image = file;
                                  },
                                  image: _image,
                                ))
                          ]),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ActionButton(
                        onPressed: () {
                          _submitForm();
                        },
                        loading: _isLoading,
                        child: Text(_isEditing ? "Speichern" : "Hinzufügen"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}

/// Helper functions to build the dropdown lists
Widget buildPaddedDropdownInputField<T extends DropdownOption>(
    BuildContext context,
    String label,
    Future<List<T>> future,
    Function setStateFunction,
    String? defaultValue) {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ),
        FutureBuilder<List<T>>(
          future: future,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Text("No data available");
            }
            return DropdownInputField<T>(
              optionsList: snapshot.data!,
              labelText: label,
              onOptionSelected: (selectedItem) {
                setStateFunction(selectedItem);
              },
              defaultValue: defaultValue,
            );
          },
        )
      ],
    ),
  );
}
