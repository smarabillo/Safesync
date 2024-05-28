import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  File? _image;
  var _isLoading = false;
  final picker = ImagePicker();
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = {
        'Username': prefs.getString('username') ?? 'User',
        'Full Name': prefs.getString('fullname') ?? 'User',
        'Email': prefs.getString('email') ?? 'User',
        'Address': prefs.getString('address') ?? 'User',
        'Contact Number': prefs.getString('contact_num') ?? 'User',
      };
    });
  }

  Future<void> _showImagePickerDialog() async {
    setState(() {
      _isLoading = true;
    });
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
      _isLoading = false;
    });
  }

  void _logoutUser() async {
    final response = await http.post(
      Uri.parse('https://kayegm.helioho.st/logout.php'),
    );

    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    } else {
      print('Error: ${response.body}');
    }
  }

  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: _showImagePickerDialog,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey,
              backgroundImage: _image != null ? FileImage(_image!) : null,
              child: _image == null
                  ? const Icon(
                      Icons.account_circle,
                      size: 120,
                      color: Colors.white,
                    )
                  : null,
            ),
            if (_isLoading)
              const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoTiles(Map<String, String> userInfo) {
    return Card(
      margin: const EdgeInsets.all(12),
      color: Color.fromARGB(255, 241, 241, 241),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color.fromARGB(64, 136, 136, 136)),
      ),
      elevation: 0, // Adds a shadow effect
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: userInfo.entries.map((entry) {
            return Container(
              decoration: const BoxDecoration(
                border: const Border(
                  bottom: BorderSide(
                    color: Color.fromRGBO(224, 224, 224, 0.592),
                    width: 1.0,
                  ),
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                title: Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    color: Colors.black26,
                  ),
                ),
                subtitle: Text(
                  entry.value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Color.fromARGB(181, 0, 0, 0),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return _buildUserInfoTiles(userData!.map((key, value) => MapEntry(key.toString(), value.toString())));
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _logoutUser();
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF1375E8),
        title: const Text(
          'Your Profile',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutConfirmationDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProfileAvatar(),
                const SizedBox(height: 20),
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildUserInfo(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
