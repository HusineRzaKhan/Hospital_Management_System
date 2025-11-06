import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String? _role;

  User? get user => _user;
  String? get role => _role;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      _loadUserRole();
      notifyListeners();
    });
  }

  Future<void> _loadUserRole() async {
    if (_user != null) {
      // Check each role collection for the user
      final adminDoc = await _firestore.collection('admins').doc(_user!.uid).get();
      if (adminDoc.exists) {
        _role = 'admin';
        notifyListeners();
        return;
      }

      final doctorDoc = await _firestore.collection('doctors').doc(_user!.uid).get();
      if (doctorDoc.exists) {
        _role = 'doctor';
        notifyListeners();
        return;
      }

      final patientDoc = await _firestore.collection('patients').doc(_user!.uid).get();
      if (patientDoc.exists) {
        _role = 'patient';
        notifyListeners();
        return;
      }
    }
  }

  Future<void> login({
    required String email,
    required String password,
    String? role,
  }) async {
    try {
      final UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        // Verify the role if provided
        if (role != null) {
          final roleDoc = await _firestore
              .collection('${role}s')
              .doc(credential.user!.uid)
              .get();

          if (!roleDoc.exists) {
            await _auth.signOut();
            throw 'User is not registered as a $role';
          }
        }

        _user = credential.user;
        await _loadUserRole();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> registerDoctor({
    required String email,
    required String password,
    required Map<String, dynamic> doctorData,
  }) async {
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _firestore.collection('doctors').doc(credential.user!.uid).set({
          ...doctorData,
          'email': email,
          'approved': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        _user = credential.user;
        _role = 'doctor';
        notifyListeners();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> registerPatient({
    required String email,
    required String password,
    required Map<String, dynamic> patientData,
  }) async {
    try {
      final UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        await _firestore.collection('patients').doc(credential.user!.uid).set({
          ...patientData,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        _user = credential.user;
        _role = 'patient';
        notifyListeners();
      }
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    _role = null;
    notifyListeners();
  }
}
