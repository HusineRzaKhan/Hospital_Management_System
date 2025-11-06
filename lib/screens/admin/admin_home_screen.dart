import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  _AdminHomeScreenState createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
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
      body: GridView.count(
        padding: EdgeInsets.all(20),
        crossAxisCount: 2,
        children: [
          _buildDashboardItem(
            context,
            'Manage Doctors',
            Icons.medical_services,
            () => Navigator.pushNamed(context, '/admin/manage-doctors'),
          ),
          _buildDashboardItem(
            context,
            'View Appointments',
            Icons.calendar_today,
            () => Navigator.pushNamed(context, '/admin/appointments'),
          ),
          _buildDashboardItem(
            context,
            'Approve Registrations',
            Icons.approval,
            () => Navigator.pushNamed(context, '/admin/approve-registrations'),
          ),
          _buildDashboardItem(
            context,
            'Manage Departments',
            Icons.business,
            () => Navigator.pushNamed(context, '/admin/departments'),
          ),
          _buildDashboardItem(
            context,
            'Reports',
            Icons.analytics,
            () => Navigator.pushNamed(context, '/admin/reports'),
          ),
          _buildDashboardItem(
            context,
            'Settings',
            Icons.settings,
            () => Navigator.pushNamed(context, '/admin/settings'),
          ),
        ],
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