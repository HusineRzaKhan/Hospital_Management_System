import 'package:doctor/form_validator.dart';
import 'package:doctor/screens/patient_signup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PatientLoginScreen extends StatefulWidget {
  static const routeName = '/login';

  const PatientLoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<PatientLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return; // Invalid form
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        role: 'patient',
      );

      // Navigate to the patient home screen
      Navigator.of(context).pushReplacementNamed('/patient-home');
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => FormValidator.checkValidEmail(value),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () => _login(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF4287F5),
                        padding: EdgeInsets.symmetric(vertical: 12.0),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: Text('Login'),
                    ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  // Navigate directly to the Patient Signup screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PatientSignup()),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Color(0xFF4287F5),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text('Don’t have an account? Create one'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
