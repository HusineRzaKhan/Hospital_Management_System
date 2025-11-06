import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseInitializer {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> initializeData() async {
    // Create Admin Account
    try {
      final adminCredential = await _auth.createUserWithEmailAndPassword(
        email: 'admin@hospital.com',
        password: 'Admin@123',
      );

      await _firestore.collection('admins').doc(adminCredential.user!.uid).set({
        'email': 'admin@hospital.com',
        'role': 'admin',
        'name': 'System Admin',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Admin creation error: $e');
    }

    // Create Doctor Account
    try {
      final doctorCredential = await _auth.createUserWithEmailAndPassword(
        email: 'doctor@hospital.com',
        password: 'Doctor@123',
      );

      await _firestore.collection('doctors').doc(doctorCredential.user!.uid).set({
        'email': 'doctor@hospital.com',
        'role': 'doctor',
        'name': 'Dr. John Smith',
        'specialization': 'General Medicine',
        'approved': true,
        'experience': '10 years',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Doctor creation error: $e');
    }

    // Create Patient Account
    try {
      final patientCredential = await _auth.createUserWithEmailAndPassword(
        email: 'patient@example.com',
        password: 'Patient@123',
      );

      await _firestore.collection('patients').doc(patientCredential.user!.uid).set({
        'email': 'patient@example.com',
        'role': 'patient',
        'name': 'Jane Doe',
        'age': 30,
        'bloodGroup': 'O+',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Patient creation error: $e');
    }
  }
}