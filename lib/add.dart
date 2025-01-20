import 'package:cloud_firestore/cloud_firestore.dart'; // Firebase Firestore
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Firestore instance

  Future<void> _submitData() async {
    final String name = _nameController.text.trim();
    final String company = _companyController.text.trim();

    if (name.isEmpty) {
      // Show an error if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Both fields are required.'),
        ),
      );
      return;
    }

    try {
      // Save data to Firestore
      await _firestore.collection('attendance').add({
        'name': name,
        'company': company,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success message and clear fields
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Data submitted successfully!'),
        ),
      );
      _nameController.clear();
      _companyController.clear();
    } catch (e) {
      // Handle errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting data: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Name TextField
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Company Name TextField
            TextField(
              controller: _companyController,
              decoration: const InputDecoration(
                labelText: 'Company Name (if applicable)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton(
              onPressed: _submitData,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
