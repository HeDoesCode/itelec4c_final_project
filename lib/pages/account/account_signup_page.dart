import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/guest_appbar.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SignUpForm();
  }
}

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final Color darkYellow = Colors.amber[800]!;
  final Color lightYellow = Colors.amber[100]!;

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _budgetController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: GuestAppbar(),
      body: Center(
        child: Container(
          width: 350,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(labelText: 'Username'),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Username is required'
                                      : null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _budgetController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(labelText: 'Budget'),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Budget is required'
                                      : null,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(labelText: 'Password'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkYellow,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // TO-DO: handle signup function
                            }
                          },
                          child: Text('Sign Up'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Already have an account?"),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkYellow,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => Navigator.pushNamed(context, '/login'),
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
