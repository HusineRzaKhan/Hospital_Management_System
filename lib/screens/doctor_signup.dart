import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import '/form_validator.dart';
import '/screens/education_section.dart';

class DoctorSignupScreen extends StatefulWidget {
  const DoctorSignupScreen({super.key});

  @override
  _DoctorSignupScreenState createState() => _DoctorSignupScreenState();
}

class _DoctorSignupScreenState extends State<DoctorSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _degreeController = TextEditingController();
  final _yearController = TextEditingController();
  final _instituteController = TextEditingController();
  final _cityController = TextEditingController();
  final _countryController = TextEditingController();
  final _commentController = TextEditingController();
  File? _imageFile; // To store the picked image
  bool _isLoading = false;
  bool _isSaveEnabled = false;

  void _checkFields() {
    setState(() {
      _isSaveEnabled = _educationList.every((edu) =>
          edu['degree']!.isNotEmpty &&
          edu['year']!.isNotEmpty &&
          edu['institute']!.isNotEmpty &&
          edu['city']!.isNotEmpty &&
          edu['country']!.isNotEmpty);
    });
  }

  // For the education section
  final List<Map<String, String>> _educationList = [];

  // For the "How did you hear about us?" dropdown
  String? _heardFrom;

  // For the country dropdown
  final String _countryCode = '+1'; // Default country code (e.g., USA)
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'US');

  // Phone Number Section

  // Pick Image
  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      final fileSize = await image.length();
      if (fileSize > 500 * 1024) {
        // Check if the file is greater than 500KB
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image size should be less than 500KB')),
        );
        return;
      }

      setState(() {
        _imageFile = File(image.path); // Set the picked image file
      });
    }
  }

  // Add education section card
  void _addEducation() {
    setState(() {
      _educationList.add({
        'degree': '',
        'year': '',
        'institute': '',
        'city': '',
        'country': ''
      });
    });
  }

  // Handle sign-up
  void _signUp() {
    if (!_formKey.currentState!.validate()) {
      return; // Invalid form
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate sign-up process (replace with actual logic)
      _showConfirmationDialog();
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

  // Show confirmation dialog
  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        final confirmationCodeController = TextEditingController();
        return AlertDialog(
          title: Text('Enter Confirmation Code'),
          content: TextFormField(
            controller: confirmationCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Enter 6-digit code sent to email',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (confirmationCodeController.text == '123456') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Signup successful!')),
                  );
                  Navigator.of(ctx).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid code')),
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Doctor Signup')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Profile Picture Section (top-left corner)
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage, // Trigger image picker on tap
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!) // Display picked image
                          : AssetImage('assets/other_icons/person_icon.svg')
                              as ImageProvider, // Default image if none selected
                      child: _imageFile == null
                          ? Icon(Icons.add_a_photo,
                              size: 30) // Show an icon if no image is selected
                          : null,
                    ),
                  ),
                  SizedBox(width: 20),
                  // Information section on the right side
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'Name'),
                          validator: (value) {
                            return FormValidator.checkName(
                                value); // Call checkName from FormValidator
                          },
                        ),
                        TextFormField(
                          controller: _ageController,
                          decoration: InputDecoration(labelText: 'Age'),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) => FormValidator.checkAge(value),
                        ),
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
                          textFieldController: _phoneController,
                          validator: (value) => FormValidator.checkPhoneNumber(value),
                        ),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) =>
                              FormValidator.checkValidEmail(value),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password'),
                          validator: (value) =>
                              FormValidator.checkPasswordMatch(
                                  value, _passwordController.text),
                        ),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration:
                              InputDecoration(labelText: 'Confirm Password'),
                          validator: (value) =>
                              value != _passwordController.text
                                  ? 'Passwords do not match'
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Education Section
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      EducationSection(),
                    ]),
              ),

              SizedBox(height: 20),
              // How Did You Hear About Us (Dropdown)
              DropdownButtonFormField<String>(
                value: _heardFrom,
                decoration:
                    InputDecoration(labelText: 'How did you hear about us?'),
                items: ['Social Media', 'Newspaper', 'Family/Friends', 'Other']
                    .map((source) {
                  return DropdownMenuItem<String>(
                    value: source,
                    child: Text(source),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _heardFrom = value;
                  });
                },
              ),
              if (_heardFrom == 'Other')
                TextFormField(
                  controller: _commentController,
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
    );
  }
}

// class EducationSection extends StatefulWidget {
//   @override
//   _EducationSectionState createState() => _EducationSectionState();
// }

// class _EducationSectionState extends State<EducationSection> {
//   List<Map<String, dynamic>> _educationList = [];

//   final List<String> _countries = [

//   ];

//   Map<String, dynamic> _newEducation = {
//     'degree': '',
//     'year': '',
//     'institute': '',
//     'city': '',
//     'country': '',
//   };

//   bool _isSaveEnabled() {
//     return _newEducation['degree']!.isNotEmpty &&
//         _newEducation['year']!.isNotEmpty &&
//         _newEducation['institute']!.isNotEmpty &&
//         _newEducation['city']!.isNotEmpty &&
//         _newEducation['country']!.isNotEmpty &&
//         RegExp(r'^\d{4}$').hasMatch(_newEducation['year']!); // Valid year
//   }

//   void _addEducation() {
//     setState(() {
//       _educationList.add({..._newEducation});
//       _educationList
//           .sort((a, b) => int.parse(b['year']).compareTo(int.parse(a['year'])));
//       _newEducation = {
//         'degree': '',
//         'year': '',
//         'institute': '',
//         'city': '',
//         'country': '',
//       };
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.blue),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Education', style: TextStyle(fontWeight: FontWeight.bold)),
//           SizedBox(height: 10),
//           ..._educationList.map((edu) {
//             return Card(
//               elevation: 3,
//               margin: EdgeInsets.symmetric(vertical: 8),
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text("Degree/Diploma: ${edu['degree']}",
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     Text("Year of Passing: ${edu['year']}"),
//                     Text("Institute: ${edu['institute']}"),
//                     Text("City: ${edu['city']}"),
//                     Text("Country: ${edu['country']}"),
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             _newEducation = {...edu};
//                             _educationList.remove(edu);
//                           });
//                         },
//                         child: Text('Edit'),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           }).toList(),
//           Card(
//             elevation: 3,
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 children: [
//                   TextFormField(
//                     initialValue: _newEducation['degree'],
//                     decoration: InputDecoration(labelText: 'Degree/Diploma'),
//                     onChanged: (value) {
//                       setState(() {
//                         _newEducation['degree'] = value;
//                       });
//                     },
//                   ),
//                   TextFormField(
//                     initialValue: _newEducation['year'],
//                     decoration: InputDecoration(labelText: 'Year of Passing'),
//                     keyboardType: TextInputType.number,
//                     inputFormatters: [
//                       FilteringTextInputFormatter.digitsOnly,
//                       LengthLimitingTextInputFormatter(4),
//                     ],
//                     onChanged: (value) {
//                       setState(() {
//                         _newEducation['year'] = value;
//                       });
//                     },
//                   ),
//                   TextFormField(
//                     initialValue: _newEducation['institute'],
//                     decoration: InputDecoration(labelText: 'Institute'),
//                     onChanged: (value) {
//                       setState(() {
//                         _newEducation['institute'] = value;
//                       });
//                     },
//                   ),
//                   TextFormField(
//                     initialValue: _newEducation['city'],
//                     decoration: InputDecoration(labelText: 'City'),
//                     onChanged: (value) {
//                       setState(() {
//                         _newEducation['city'] = value;
//                       });
//                     },
//                   ),
//                   DropdownButtonFormField<String>(
//                     value: _newEducation['country'],
//                     decoration: InputDecoration(labelText: 'Country'),
//                     items: _countries.map((String country) {
//                       return DropdownMenuItem<String>(
//                         value: country,
//                         child: Text(country),
//                       );
//                     }).toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         _newEducation['country'] = value!;
//                       });
//                     },
//                   ),
//                   SizedBox(height: 10),
//                   ElevatedButton(
//                     onPressed: _isSaveEnabled()
//                         ? () {
//                             _addEducation();
//                           }
//                         : null,
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor:
//                           _isSaveEnabled() ? Colors.blue : Colors.grey,
//                     ),
//                     child: Text('Save'),
//                   ),
//                   if (!_isSaveEnabled())
//                     Padding(
//                       padding: const EdgeInsets.only(top: 8.0),
//                       child: Text(
//                         'Please fill all fields correctly',
//                         style: TextStyle(color: Colors.red),
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


// Text('Education',
//                         style: TextStyle(fontWeight: FontWeight.bold)),
//                     SizedBox(height: 10),
//                     if (_educationList
//                         .isEmpty) // Show Add Degree/Diploma button
//                       ElevatedButton(
//                         onPressed: _addEducation,
//                         child: Text('Add New Degree/Diploma'),
//                       ),
//                     ..._educationList.map((edu) {
//                       return Card(
//                         elevation: 3,
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             children: [
//                               TextFormField(
//                                 initialValue: edu['degree'],
//                                 decoration: InputDecoration(
//                                     labelText: 'Degree/Diploma'),
//                                 onChanged: (value) {
//                                   edu['degree'] = value;
//                                   _checkFields(); // Check validity after change
//                                 },
//                                 validator: (value) =>
//                                     FormValidator.checkEducationField(
//                                         value, 'Degree/Diploma'),
//                               ),
//                               TextFormField(
//                                 initialValue: edu['year'],
//                                 decoration: InputDecoration(
//                                     labelText: 'Year of Passing'),
//                                 keyboardType: TextInputType.number,
//                                 onChanged: (value) {
//                                   edu['year'] = value;
//                                   _checkFields();
//                                 },
//                                 validator: (value) =>
//                                     FormValidator.checkEducationField(
//                                         value, 'Year'),
//                               ),
//                               TextFormField(
//                                 initialValue: edu['institute'],
//                                 decoration:
//                                     InputDecoration(labelText: 'Institute'),
//                                 onChanged: (value) {
//                                   edu['institute'] = value;
//                                   _checkFields();
//                                 },
//                                 validator: (value) =>
//                                     FormValidator.checkEducationField(
//                                         value, 'Institute'),
//                               ),
//                               TextFormField(
//                                 initialValue: edu['city'],
//                                 decoration: InputDecoration(labelText: 'City'),
//                                 onChanged: (value) {
//                                   edu['city'] = value;
//                                   _checkFields();
//                                 },
//                                 validator: (value) =>
//                                     FormValidator.checkEducationField(
//                                         value, 'City'),
//                               ),
//                               DropdownButtonFormField<String>(
//                                 value: edu['country']!.isNotEmpty
//                                     ? edu['country']
//                                     : null,
//                                 decoration:
//                                     InputDecoration(labelText: 'Country'),
//                                 items: [
//                                   'Afghanistan',
//                                   'Albania',
//                                   'Algeria',
//                                   'Andorra',
//                                   'Angola',
//                                   'Antigua and Barbuda',
//                                   'Argentina',
//                                   'Armenia',
//                                   'Australia',
//                                   'Austria',
//                                   'Azerbaijan',
//                                   'Bahamas',
//                                   'Bahrain',
//                                   'Bangladesh',
//                                   'Barbados',
//                                   'Belarus',
//                                   'Belgium',
//                                   'Belize',
//                                   'Benin',
//                                   'Bhutan',
//                                   'Bolivia',
//                                   'Bosnia and Herzegovina',
//                                   'Botswana',
//                                   'Brazil',
//                                   'Brunei',
//                                   'Bulgaria',
//                                   'Burkina Faso',
//                                   'Burundi',
//                                   'Cabo Verde',
//                                   'Cambodia',
//                                   'Cameroon',
//                                   'Canada',
//                                   'Central African Republic',
//                                   'Chad',
//                                   'Chile',
//                                   'China',
//                                   'Colombia',
//                                   'Comoros',
//                                   'Congo (Congo-Brazzaville)',
//                                   'Costa Rica',
//                                   'Croatia',
//                                   'Cuba',
//                                   'Cyprus',
//                                   'Czech Republic',
//                                   'Denmark',
//                                   'Djibouti',
//                                   'Dominica',
//                                   'Dominican Republic',
//                                   'Ecuador',
//                                   'Egypt',
//                                   'El Salvador',
//                                   'Equatorial Guinea',
//                                   'Eritrea',
//                                   'Estonia',
//                                   'Eswatini (fmr. "Swaziland")',
//                                   'Ethiopia',
//                                   'Fiji',
//                                   'Finland',
//                                   'France',
//                                   'Gabon',
//                                   'Gambia',
//                                   'Georgia',
//                                   'Germany',
//                                   'Ghana',
//                                   'Greece',
//                                   'Grenada',
//                                   'Guatemala',
//                                   'Guinea',
//                                   'Guinea-Bissau',
//                                   'Guyana',
//                                   'Haiti',
//                                   'Holy See',
//                                   'Honduras',
//                                   'Hungary',
//                                   'Iceland',
//                                   'India',
//                                   'Indonesia',
//                                   'Iran',
//                                   'Iraq',
//                                   'Ireland',
//                                   'Italy',
//                                   'Jamaica',
//                                   'Japan',
//                                   'Jordan',
//                                   'Kazakhstan',
//                                   'Kenya',
//                                   'Kiribati',
//                                   'Korea (North)',
//                                   'Korea (South)',
//                                   'Kosovo',
//                                   'Kuwait',
//                                   'Kyrgyzstan',
//                                   'Laos',
//                                   'Latvia',
//                                   'Lebanon',
//                                   'Lesotho',
//                                   'Liberia',
//                                   'Libya',
//                                   'Liechtenstein',
//                                   'Lithuania',
//                                   'Luxembourg',
//                                   'Madagascar',
//                                   'Malawi',
//                                   'Malaysia',
//                                   'Maldives',
//                                   'Mali',
//                                   'Malta',
//                                   'Marshall Islands',
//                                   'Mauritania',
//                                   'Mauritius',
//                                   'Mexico',
//                                   'Micronesia',
//                                   'Moldova',
//                                   'Monaco',
//                                   'Mongolia',
//                                   'Montenegro',
//                                   'Morocco',
//                                   'Mozambique',
//                                   'Myanmar (formerly Burma)',
//                                   'Namibia',
//                                   'Nauru',
//                                   'Nepal',
//                                   'Netherlands',
//                                   'New Zealand',
//                                   'Nicaragua',
//                                   'Niger',
//                                   'Nigeria',
//                                   'North Macedonia (formerly Macedonia)',
//                                   'Norway',
//                                   'Oman',
//                                   'Pakistan',
//                                   'Palau',
//                                   'Palestine',
//                                   'Panama',
//                                   'Papua New Guinea',
//                                   'Paraguay',
//                                   'Peru',
//                                   'Philippines',
//                                   'Poland',
//                                   'Portugal',
//                                   'Qatar',
//                                   'Romania',
//                                   'Russia',
//                                   'Rwanda',
//                                   'Saint Kitts and Nevis',
//                                   'Saint Lucia',
//                                   'Saint Vincent and the Grenadines',
//                                   'Samoa',
//                                   'San Marino',
//                                   'Sao Tome and Principe',
//                                   'Saudi Arabia',
//                                   'Senegal',
//                                   'Serbia',
//                                   'Seychelles',
//                                   'Sierra Leone',
//                                   'Singapore',
//                                   'Slovakia',
//                                   'Slovenia',
//                                   'Solomon Islands',
//                                   'Somalia',
//                                   'South Africa',
//                                   'South Sudan',
//                                   'Spain',
//                                   'Sri Lanka',
//                                   'Sudan',
//                                   'Suriname',
//                                   'Sweden',
//                                   'Switzerland',
//                                   'Syria',
//                                   'Tajikistan',
//                                   'Tanzania',
//                                   'Thailand',
//                                   'Timor-Leste',
//                                   'Togo',
//                                   'Tonga',
//                                   'Trinidad and Tobago',
//                                   'Tunisia',
//                                   'Turkey',
//                                   'Turkmenistan',
//                                   'Tuvalu',
//                                   'Uganda',
//                                   'Ukraine',
//                                   'United Arab Emirates',
//                                   'United Kingdom',
//                                   'United States',
//                                   'Uruguay',
//                                   'Uzbekistan',
//                                   'Vanuatu',
//                                   'Vatican City',
//                                   'Venezuela',
//                                   'Vietnam',
//                                   'Yemen',
//                                   'Zambia',
//                                   'Zimbabwe' /* Your country list here */
//                                 ].map((country) {
//                                   return DropdownMenuItem<String>(
//                                     value: country,
//                                     child: Text(country),
//                                   );
//                                 }).toList(),
//                                 onChanged: (String? value) {
//                                   setState(() {
//                                     edu['country'] = value ?? '';
//                                     _checkFields();
//                                   });
//                                 },
//                               ),
//                               ElevatedButton(
//                                 onPressed: _isSaveEnabled
//                                     ? () {
//                                         setState(() {
//                                           // Save the new education entry
//                                           _educationList.add({...edu});
//                                           // Reset the form fields or navigate away
//                                         });
//                                       }
//                                     : null,
//                                 child: Text('Save'),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }),
//                   ],