import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientHomeScreen extends StatefulWidget {
  const PatientHomeScreen({Key? key}) : super(key: key);

  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _getPatientData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final docSnapshot = await _firestore.collection('patients').doc(user.uid).get();
      return docSnapshot.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _getPatientData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return GridView.count(
            padding: EdgeInsets.all(20),
            crossAxisCount: 2,
            children: [
              _buildDashboardItem(
                context,
                'Book Appointment',
                Icons.add_circle,
                () => Navigator.pushNamed(context, '/patient/book-appointment'),
              ),
              _buildDashboardItem(
                context,
                'My Appointments',
                Icons.calendar_today,
                () => Navigator.pushNamed(context, '/patient/appointments'),
              ),
              _buildDashboardItem(
                context,
                'Medical Records',
                Icons.folder_special,
                () => Navigator.pushNamed(context, '/patient/medical-records'),
              ),
              _buildDashboardItem(
                context,
                'Prescriptions',
                Icons.receipt_long,
                () => Navigator.pushNamed(context, '/patient/prescriptions'),
              ),
              _buildDashboardItem(
                context,
                'Find Doctor',
                Icons.search,
                () => Navigator.pushNamed(context, '/patient/find-doctor'),
              ),
              _buildDashboardItem(
                context,
                'Profile',
                Icons.person,
                () => Navigator.pushNamed(context, '/patient/profile'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDashboardItem(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Theme.of(context).primaryColor),
            SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}