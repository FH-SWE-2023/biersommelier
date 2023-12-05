import 'package:flutter/material.dart';
import 'package:biersommelier/router/Rut.dart';

import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/components/CustomDateField.dart';
import 'package:biersommelier/components/CustomDescriptionField.dart';
import 'package:biersommelier/components/CustomTextField.dart';
import 'package:biersommelier/components/CustomTimeField.dart';
import 'package:biersommelier/components/CustomRatingField.dart';
import 'package:biersommelier/components/CTAButton.dart';
import 'package:biersommelier/components/Toast.dart';
import 'package:uuid/uuid.dart';

import 'package:biersommelier/database/entities/Post.dart';
import 'package:biersommelier/database/entities/Bar.dart';
import 'package:biersommelier/database/entities/Beer.dart';

class PostForm extends StatefulWidget {
  final Post? initialPost;
  final Function(Post) onSubmit;

  const PostForm({super.key, this.initialPost, required this.onSubmit});

  @override
  _PostFormState createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  late TextEditingController _barController;
  late TextEditingController _beerController;
  late TextEditingController _descriptionController;
  late DateTime _selectedDate;
  late int _rating;

  Bar? _bar;
  Beer? _beer;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // check if bar and beer exist and save them to _bar and _beer
    if (widget.initialPost != null) {
      Bar.get(widget.initialPost!.barId).then((bar) {
        setState(() {
          _bar = bar!;
        });
      });
      Beer.get(widget.initialPost!.beerId).then((beer) {
        setState(() {
          _beer = beer!;
        });
      });
    }

    if (widget.initialPost != null) {
      // if bar and beer exist dont exist, error
      if (_bar == null || _beer == null) {
        showToast(context, "Lokal oder Bier nicht gefunden!", ToastLevel.danger);
        return;
      }

      // Bar name
      _barController = TextEditingController(text: _bar?.name);
      _beerController = TextEditingController(text: _beer?.name);
      _descriptionController = TextEditingController(text: widget.initialPost!.description);
      _selectedDate = widget.initialPost!.date;
      _rating = widget.initialPost!.rating;
    } else {
      _barController = TextEditingController();
      _beerController = TextEditingController();
      _descriptionController = TextEditingController();
      _selectedDate = DateTime.now();
      _rating = 0;
    }
  }

  Future<void> _submitForm() async {
    if (_barController.text.isEmpty ||
        _beerController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _rating == 0) {
      showToast(context, "Bitte fülle alle Felder aus!", ToastLevel.danger);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Get bar and beer and save them to _bar and _beer
    await Bar.getByName(_barController.text).then((bar) {
      setState(() {
        _bar = bar;
      });
    });

    await Beer.getByName(_beerController.text).then((beer) {
      setState(() {
        _beer = beer;
      });
    });

    // context check
    if (!context.mounted) {
      return;
    }

    // Check if bar and beer exist, give error if not
    if (_bar == null || _beer == null) {
      showToast(context, "Lokal oder Bier nicht gefunden!", ToastLevel.danger);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Create or update a Post object
    final post = Post(
      id: widget.initialPost?.id ?? const Uuid().v4(),
      imageId: '', // Update as needed
      rating: _rating,
      barId: _bar!.id,
      beerId: _beer!.id,
      date: _selectedDate,
      description: _descriptionController.text,
    );

    // save to database with insert or update
    if (widget.initialPost == null) {
      await Post.insert(post);
    } else {
      await Post.update(post);
    }

    widget.onSubmit(post);
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is removed from the widget tree
    _barController.dispose();
    _beerController.dispose();
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
                  title: widget.initialPost == null ? "Hinzufügen" : "Bearbeiten",
                  backgroundColor: Colors.white,
                  icon: HeaderIcon.back,
                ),
              ),
              Expanded(
                child: SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextFieldWithLabel(
                          label: "Lokal",
                          textField: CustomTextField(
                            context: context,
                            controller: _barController,
                            labelText: "Name",
                          ),
                        ),
                        TextFieldWithLabel(
                          label: "Bier",
                          textField: CustomTextField(
                            context: context,
                            controller: _beerController,
                            labelText: "Name",
                          ),
                        ),
                        CustomRatingField(
                          initialRating: _rating,
                          onRatingSelected: (rating) {
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
                          child: OutlinedButton.icon(
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Foto hinzufügen'),
                            onPressed: () {
                              showToast(context, "Not yet implemented!", ToastLevel.warning);
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: CTAButton(
                            context: context,
                            onPressed: _submitForm,
                            isLoading: _isLoading,
                            child: const Text('Hinzufügen'), // Set to true to show loading indicator
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