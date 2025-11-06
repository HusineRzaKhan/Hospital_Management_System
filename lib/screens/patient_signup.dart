import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '/form_validator.dart';

class PatientSignup extends StatefulWidget {
  const PatientSignup({super.key});

  @override
  _PatientSignupState createState() => _PatientSignupState();
}

class _PatientSignupState extends State<PatientSignup> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _age = '';
  String _fatherName = '';
  String _gender = 'Male';
  final String _phone = '';
  final String _email = ''; // Email variable
  String _heardFrom = ''; // Initialize as empty
  File? _imageFile; // To store the picked image
  bool _isLoading = false;
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US');

  // Pick Image
  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _imageFile = File(image.path); // Set the picked image file
      });
    }
  }

  // Handle sign-up
  void _signUp() {
    if (!_formKey.currentState!.validate()) {
      return; // Invalid form
    }
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate sign-up process (replace with actual logic)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup successful!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Signup'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                // Profile Picture Section
                GestureDetector(
                  onTap: _pickImage, // Trigger image picker on tap
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!) // Display picked image
                        : AssetImage('assets/other_icons/person_icon.svg')
                            as ImageProvider, // Default image if none selected
                    child: _imageFile == null
                        ? Icon(Icons.camera_alt,
                            size: 50) // Show camera icon if no image
                        : null,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    return FormValidator.checkName(
                        value); // Custom name validation
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => FormValidator.checkAge(value),
                  onSaved: (value) {
                    _age = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Father\'s Name'),
                  validator: (value) => FormValidator.checkName(value),
                  onSaved: (value) {
                    _fatherName = value!;
                  },
                ),
                // Gender Section
                ListTile(
                  title: const Text('Male'),
                  leading: Radio<String>(
                    value: 'Male',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Female'),
                  leading: Radio<String>(
                    value: 'Female',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Prefer not to say'),
                  leading: Radio<String>(
                    value: 'Prefer not to say',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value!;
                      });
                    },
                  ),
                ),
                // Email Section
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => FormValidator.checkValidEmail(value),
                ),
                // Phone Number Section
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    setState(() {
                      _phoneNumber = number;
                    });
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.DIALOG,
                  ),
                  hintText: "Enter phone number",
                  inputDecoration: InputDecoration(
                    labelText: "Phone Number",
                  ),
                  initialValue: _phoneNumber,
                  textFieldController: TextEditingController(),
                  validator: (value) {
                    return FormValidator.checkPhoneNumber(value);
                  },
                ),
                SizedBox(height: 20),
                // How Did You Hear About Us Section
                DropdownButtonFormField<String>(
                  value: _heardFrom.isEmpty
                      ? null
                      : _heardFrom, // Ensure valid initial value
                  decoration:
                      InputDecoration(labelText: 'How did you hear about us?'),
                  items: [
                    'Social Media',
                    'Newspaper',
                    'Family/Friends',
                    'Other'
                  ].map((source) {
                    return DropdownMenuItem<String>(
                      value: source,
                      child: Text(source),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _heardFrom = value!;
                    });
                  },
                  validator: (value) {
                    return value == null || value.isEmpty
                        ? 'Please select an option'
                        : null;
                  },
                ),
                if (_heardFrom == 'Other')
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Please specify'),
                  ),
                SizedBox(height: 20),
                // Signup Button
                ElevatedButton(
                  onPressed: _signUp,
                  child:
                      _isLoading ? CircularProgressIndicator() : Text('Signup'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
