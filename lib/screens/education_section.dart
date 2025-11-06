import 'package:flutter/material.dart';
import 'education_form.dart';

class EducationSection extends StatefulWidget {
  const EducationSection({super.key});

  @override
  State<EducationSection> createState() => _EducationSectionState();
}

class _EducationSectionState extends State<EducationSection> {
  final List<Map<String, dynamic>> _educationList = [];

  void _addEducationCard() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EducationForm(
            onSave: (newEducation) {
              setState(() {
                _educationList.add(newEducation);
                _educationList.sort((a, b) =>
                    int.parse(b['year']).compareTo(int.parse(a['year'])));
              });
            },
          ),
        );
      },
    );
  }

  void _removeEducationCard(int index) {
    setState(() {
      _educationList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Education',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: _addEducationCard,
            child: Text('Add New Degree/Diploma'),
          ),
          if (_educationList.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: _educationList.length,
                itemBuilder: (context, index) {
                  final education = _educationList[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${education['degree']} (${education['year']})',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                icon: Icon(Icons.close),
                                onPressed: () => _removeEducationCard(index),
                              ),
                            ],
                          ),
                          Text('Institute: ${education['institute']}'),
                          Text('City: ${education['city']}'),
                          Text('Country: ${education['country']}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
