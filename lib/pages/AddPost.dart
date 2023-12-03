import 'package:biersommelier/components/Header.dart';
import 'package:biersommelier/router/Rut.dart';
import 'package:flutter/material.dart';

import '../components/CustomDateField.dart';
import '../components/CustomDescriptionField.dart';
import '../components/CustomTextField.dart';
import '../components/CustomTimeField.dart';
import '../components/CustomRatingField.dart';
import '../components/CTAButton.dart';
import '../components/Toast.dart';
import '../router/rut/RutPath.dart';


class PostData {
  String bar;
  String beer;
  DateTime date;
  int rating;
  String description;

  PostData({
    required this.bar,
    required this.beer,
    required this.date,
    required this.rating,
    required this.description,
  });
}

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final TextEditingController _barController = TextEditingController();
  final TextEditingController _beerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _rating = 0;

  bool _isLoading = false;

  void _submitPost() async {
    if (!context.mounted) return;

    // Set loading state to true
    setState(() {
      _isLoading = true;
    });

    if (_barController.text.isEmpty ||
        _beerController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _rating == 0) {
      // Display toast message
      showToast(context, "Bitte füllen Sie alle Felder aus", ToastLevel.danger);
      setState(() {
        _isLoading = false;
      });
      return; // Stop further execution if validation fails
    }

    await Future.delayed(const Duration(seconds: 2));

    // Here we'll create the PostData object with values from the form fields
    final postData = PostData(
      bar: _barController.text,
      beer: _beerController.text,
      date: _selectedDate,
      rating: _rating,
      description: _descriptionController.text,
    );

    // Now you can use postData to do whatever you need, like sending to an API
    // For demonstration, we'll just print the values
    print('Lokal: ${postData.bar}');
    print('Bier: ${postData.beer}');
    print('Datum: ${postData.date}');
    print('Rating: ${postData.rating}');
    print('Beschreibung: ${postData.description}');

    // TODO: Save Post to Database

    if (!context.mounted) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // route to "Logbuch" and display toast message
    showToast(context, "Post erfolgreich hinzugefügt", ToastLevel.success);
    context.jump(RutPage.log);

    setState(() {
      _isLoading = false;
    });
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
    // ... your existing build method
    // Make sure to attach controllers to your CustomTextField and CustomDescriptionField
    // Pass _selectedDate and _selectedTime to your CustomDateField and CustomTimeField
    // Pass _rating to your CustomRatingField and set it up to update _rating on change
    return Center(
      child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16),
                  child: Header(
                    title: "Hinzufügen",
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
                                  initialDate: DateTime.now(),
                                  initialValue: DateTime.now(),
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
                                  initialValue: DateTime.now(),
                                  initialDate: DateTime.now(),
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
                            onPressed: _submitPost,
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
