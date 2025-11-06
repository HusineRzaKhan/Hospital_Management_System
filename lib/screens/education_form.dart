import 'package:flutter/material.dart';

class EducationForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSave;

  const EducationForm({super.key, required this.onSave});

  @override
  State<EducationForm> createState() => _EducationFormState();
}

class _EducationFormState extends State<EducationForm> {
  final _formKey = GlobalKey<FormState>();
  String degree = '';
  String year = '';
  String institute = '';
  String city = '';
  String country = '';

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName cannot be empty';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      widget.onSave({
        'degree': degree,
        'year': year,
        'institute': institute,
        'city': city,
        'country': country,
      });
      Navigator.of(context).pop(); // Close the form modal
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Degree/Diploma'),
                onChanged: (value) => degree = value,
                validator: (value) => _validateField(value, 'Degree/Diploma'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Year of Passing'),
                keyboardType: TextInputType.number,
                onChanged: (value) => year = value,
                validator: (value) => _validateField(value, 'Year of Passing'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Institute'),
                onChanged: (value) => institute = value,
                validator: (value) => _validateField(value, 'Institute'),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'City'),
                onChanged: (value) => city = value,
                validator: (value) => _validateField(value, 'City'),
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Country'),
                items: [
                  'United States',
                  'India',
                  'Pakistan',
                  'United Kingdom',
                  'Australia',
                ].map((country) {
                  return DropdownMenuItem<String>(
                    value: country,
                    child: Text(country),
                  );
                }).toList(),
                onChanged: (value) => country = value ?? '',
                validator: (value) => _validateField(value, 'Country'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
