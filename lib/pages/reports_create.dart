import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportsDialog extends StatefulWidget {
  @override
  _ReportsDialogState createState() => _ReportsDialogState();
}

class _ReportsDialogState extends State<ReportsDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedEmergency;
  DateTime? _selectedDate;

  final List<String> _emergencyTypes = [
    'Fire Outbreak',
    'Car Crash',
    'Theft',
    'Harassment',
    'Shooting',
    'Noise Complaint',
    'Medical Attention',
    'Other'
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final reportData = {
        'type_of_emergency': _selectedEmergency,
        'description': _descriptionController.text,
        'location': _locationController.text,
        'date_time': _selectedDate?.toIso8601String(),
      };

      final response = await http.post(
        Uri.parse('https://kayegm.helioho.st/reports.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(reportData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Report submitted successfully')),
        );
        Navigator.of(context).pop(); // Close the dialog on success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit report')),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
  backgroundColor: Colors.white, // Set background color to white
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10), // Set border radius to 10px
  ),
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Center(
              child: Text(
                'Create Report',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedEmergency,
              hint: const Text('Choose Incident'), // Placeholder text
              onChanged: (newValue) {
                setState(() {
                  _selectedEmergency = newValue;
                });
              },
              items: _emergencyTypes.map((emergency) {
                return DropdownMenuItem(
                  value: emergency,
                  child: Text(
                    emergency,
                    style: const TextStyle(
                      color: Colors.black, // Change text color
                      fontSize: 16, // Change text size
                    ),
                  ),
                );
              }).toList(),
              icon: const Icon(
                Icons.arrow_drop_down, // Change dropdown icon
                color: Colors.blue, // Change icon color
              ),
              elevation: 2, // Change dropdown elevation
              isExpanded: true, // Expand dropdown to fit the screen width
              underline: Container(
                height: 2, // Change underline height
                color: Colors.blue, // Change underline color
              ),
              style: const TextStyle(
                color: Colors.black, // Change selected item text color
                fontSize: 16, // Change selected item text size
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _descriptionController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextFormField(

              controller: _locationController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a location';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
                                fillColor: Colors.white,

              ),
              maxLines: 1,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Date: '),
                Text(
                  _selectedDate == null
                      ? 'No date selected'
                      : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: SizedBox(
                width: double.infinity, // Make the SizedBox take the full width available
                child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue), 
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.white), 
                ),
                onPressed: _submitForm,
                child: const Text('Submit'),
              ),
            ) 
            ),
            const SizedBox(height: 16,),
            Center(
              child: SizedBox(
                width: double.infinity, // Make the SizedBox take the full width available
                child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white), 
                  foregroundColor: MaterialStateProperty.all<Color>(Colors.grey), 
                ),
                onPressed: () {
                  setState(() {
                    _selectedEmergency = null;
                    _descriptionController.clear();
                    _locationController.clear();
                    _selectedDate = null;
                  });
                },
                child: const Text('Clear'),
              ),
            ),
              )
               
          ],
        ),
      ),
    ),
  ),
  );
  }
}
void showReportsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ReportsDialog();
    },
  );
}
