import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileUpdatePage extends StatefulWidget {
  const ProfileUpdatePage({super.key});

  @override
  _ProfileUpdatePageState createState() => _ProfileUpdatePageState();
}

class _ProfileUpdatePageState extends State<ProfileUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  User? currentUser;
  var user;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future _getUserDetails() async {
    var currentUser = FirebaseAuth.instance.currentUser;
    await currentUser?.reload();
    currentUser = FirebaseAuth.instance.currentUser;

    var user =
        await FirebaseFirestore.instance
            .collection('tbl_users')
            .doc(currentUser!.uid)
            .get();

    setState(() {
      usernameController.text = user['username'];
      emailController.text = currentUser?.email as String;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 255, 224, 178),
      appBar: AppBar(
        title: Text("Edit Profile"),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'Edit your profile',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Username is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(labelText: 'Email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    await currentUser?.verifyBeforeUpdateEmail(
                      emailController.text.trim(),
                    );

                    await currentUser?.reload();
                    currentUser = FirebaseAuth.instance.currentUser;

                    await FirebaseFirestore.instance
                        .collection('tbl_users')
                        .doc(currentUser?.uid)
                        .update({'userrome': usernameController.text.trim()});

                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                  textStyle: TextStyle(fontSize: 16),
                ),
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
