import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itelec4c_final_project/components/auth_appbar.dart';
import 'package:itelec4c_final_project/pages/profile/profile_update_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = "";
  String _email = "";

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
      _username = user['username'];
      _email = currentUser!.email ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(100, 255, 224, 178),
      appBar: AuthAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
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
                  ],
                ),
              ),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileUpdatePage(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Edit Profile'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Logout'),
                ),
              ],
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
