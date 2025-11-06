import 'package:doctor/screens/admin_login.dart';
import 'package:doctor/screens/doctor_login.dart';
// Manager role removed: keep only doctor, patient and admin
import 'package:flutter/material.dart';
import 'patient_login.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0), // Adjust the padding as needed
          child: Image.asset('assets/images/Waiza Mariztu fahuwa yashfeen - 2000x2000 2.png', height: 40), // Your logo image
        ),
      ),
      body: Center(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add the image at the top
            Image.asset(
              'assets/images/Waiza Mariztu fahuwa yashfeen - 2000x2000 2.png', // Path to the image asset
              height: 350,
              width: 350,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20), // Add some spacing
            Text(
              'Welcome to the Hospital App',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Select your role',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 40),
            // Button Row for role selection
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate directly to the Doctor login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorLoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF4287F5), // Blue color like app bar
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: TextStyle(
                        fontSize: 16, color: Colors.white), // White text
                  ),
                  child: Text('Doctor'),
                ),
                SizedBox(width: 20), // Space between buttons
                ElevatedButton(
                  onPressed: () {
                    // Navigate directly to the Patient login screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PatientLoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4287F5),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    textStyle: TextStyle(
                        fontSize: 16, color: Colors.white), // White text
                  ),
                  child: Text('Patient'),
                ),
              ],
            ),
            SizedBox(height: 20), // Space before admin button
            ElevatedButton(
              onPressed: () {
                // Navigate directly to the Admin login screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminLoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF4287F5),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                textStyle: TextStyle(fontSize: 16, color: Colors.white),
              ),
              child: Text('Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
