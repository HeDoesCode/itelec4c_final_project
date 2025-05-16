import 'package:flutter/material.dart';

class LandingPage extends StatelessWidget {
  final Color darkYellow = Colors.amber[800]!;
  final Color lightYellow = Colors.amber[100]!;

  LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 500),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkYellow,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed:
                              () => Navigator.pushNamed(context, '/login'),
                          child: Text('Login'),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkYellow,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed:
                              () => Navigator.pushNamed(context, '/signup'),
                          child: Text('Sign Up'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
