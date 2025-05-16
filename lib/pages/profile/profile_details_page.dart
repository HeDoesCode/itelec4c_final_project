import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/auth_appbar.dart';
import 'package:itelec4c_final_project/pages/profile/profile_update_page.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = 'Julia';
  String _email = 'maryjulia.malagayo.cics@ust.edu.ph';
  String _budget = '₱1000';
  File? _profileImage;

  void _updateProfile(Map<String, dynamic> updatedProfile) {
    setState(() {
      _username = updatedProfile['username'];
      _email = updatedProfile['email'];
      _budget = updatedProfile['budget'];
      _profileImage = updatedProfile['profileImage'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AuthAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[300],
              backgroundImage:
                  _profileImage != null ? FileImage(_profileImage!) : null,
              child:
                  _profileImage == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
            ),
            SizedBox(height: 20),
            Text(
              'Hello, $_username!',
              style: TextStyle(
                fontSize: 24,
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
                    InfoRow(label: 'Username', value: _username),
                    InfoRow(label: 'Email', value: _email),
                    InfoRow(label: 'Budget', value: _budget),
                  ],
                ),
              ),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () async {
                final updatedProfile = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ProfileUpdatePage(
                          username: _username,
                          email: _email,
                          budget: _budget,
                          profileImage: _profileImage,
                        ),
                  ),
                );
                if (updatedProfile != null) {
                  _updateProfile(updatedProfile);
                }
              },
              child: Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(value, style: TextStyle(fontSize: 18, color: Colors.black54)),
        ],
      ),
    );
  }
}
