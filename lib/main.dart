import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proidtest/firebase_options.dart';

import 'add.dart'; // Import the new page

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? selectedActivity; // Variable to hold the selected activity
  TimeOfDay? startTime; // Variable to hold the start time
  TimeOfDay? endTime; // Variable to hold the end time

  // Function to show time picker
  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? (startTime ?? TimeOfDay.now()) : (endTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked; // Update start time
        } else {
          endTime = picked; // Update end time
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoSphere Attendance Tracking',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.lightGreen[100], // Light green background for entire screen
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.green, // Green background for the container
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Text(
                  'EcoSphere Attendance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20), // Add some space between the title and the dropdown
              const Text(
                'Enter Activity',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 20), // Add some space between the text and the dropdown
              DropdownButton<String>(
                value: selectedActivity,
                hint: const Text('Select an activity'),
                items: <String>[
                  'Beach Cleaning',
                  'Tree Planting',
                  'Homegrown Solutions',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedActivity = newValue; // Update the selected activity
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => _selectTime(context, true),
                    child: Text(
                      startTime == null
                          ? 'Select Start Time'
                          : 'Start Time: ${startTime!.format(context)}',
                    ),
                  ),
                  const SizedBox(
                      width: 10), // Add some space between the start and end time buttons
                  TextButton(
                    onPressed: () => _selectTime(context, false),
                    child: Text(
                      endTime == null ? 'Select End Time' : 'End Time: ${endTime!.format(context)}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Conditionally show image when both start and end times are set
              if (startTime != null && endTime != null) ...[
                const SizedBox(height: 20), // Space before image
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddPage()),
                    );
                  },
                  child: SizedBox(
                    width: 400,
                    height: 400,
                    child: Image.asset('assets/qr-code.png'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
