import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({Key? key}) : super(key: key);

  @override
  _DoctorHomeScreenState createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  Future<Map<String, dynamic>?> _getDoctorData() async {
    final user = _auth.currentUser;
    if (user != null) {
      final docSnapshot = await _firestore.collection('doctors').doc(user.uid).get();
      return docSnapshot.data();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Dashboard'),
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
        future: _getDoctorData(),
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
                'Today\'s Appointments',
                Icons.today,
                () => Navigator.pushNamed(context, '/doctor/appointments/today'),
              ),
              _buildDashboardItem(
                context,
                'All Appointments',
                Icons.calendar_month,
                () => Navigator.pushNamed(context, '/doctor/appointments'),
              ),
              _buildDashboardItem(
                context,
                'Patient Records',
                Icons.people,
                () => Navigator.pushNamed(context, '/doctor/patients'),
              ),
              _buildDashboardItem(
                context,
                'Prescriptions',
                Icons.medical_information,
                () => Navigator.pushNamed(context, '/doctor/prescriptions'),
              ),
              _buildDashboardItem(
                context,
                'My Schedule',
                Icons.schedule,
                () => Navigator.pushNamed(context, '/doctor/schedule'),
              ),
              _buildDashboardItem(
                context,
                'Profile',
                Icons.person,
                () => Navigator.pushNamed(context, '/doctor/profile'),
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