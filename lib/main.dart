import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_details_page.dart';
import 'package:itelec4c_final_project/pages/recipe/recipe_list_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final Color darkYellow = Colors.amber[800]!;
  final Color lightYellow = Colors.amber[100]!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Landing Page App',
      theme: ThemeData(primaryColor: darkYellow),
      home: LandingPage(),
      routes: {
        '/login': (_) => LoginPage(),
        '/signup': (_) => SignUpPage(),
        '/recipes': (_) => RecipeListPage(),
      },
    );
  }
}

class LandingPage extends StatelessWidget {
  final Color darkYellow = Colors.amber[800]!;
  final Color lightYellow = Colors.amber[100]!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              height: 500,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkYellow,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text('Login'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkYellow,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  final Color darkYellow = Colors.amber[800]!;
  final Color lightYellow = Colors.amber[100]!;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: darkYellow,
        leading: BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          Spacer(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Log In',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.all(20),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (!value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkYellow,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Logging in...')),
                              );
                            }
                          },
                          child: Text('Sign In'),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text('Forgot Password?'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text("Don't have an account yet?"),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: darkYellow,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pushNamed(context, '/signup'),
            child: Text('Sign Up'),
          ),
          Spacer(),
        ],
      ),
    );
  }
}


class SignUpPage extends StatelessWidget {
  final Color darkYellow = Colors.amber[800]!;
  final Color lightYellow = Colors.amber[100]!;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        backgroundColor: darkYellow,
        leading: BackButton(color: Colors.white),
      ),
      body: Column(
        children: [
          Spacer(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                Container(
                  padding: EdgeInsets.all(20),
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            } else if (!value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(labelText: 'Password'),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkYellow,
                            foregroundColor: Colors.black,
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Registering...')),
                              );
                            }
                          },
                          child: Text('Register'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text("Already have an account?"),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: darkYellow,
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pushNamed(context, '/login'),
            child: Text('Login'),
          ),
          Spacer(),
        ],
      ),
    );
  }
}


