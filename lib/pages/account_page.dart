import 'dart:io';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        'user_id': prefs.getString('user_id') ?? 'User',
        'fullname': prefs.getString('fullname') ?? 'User',
        'username': prefs.getString('username') ?? 'User',
        'email': prefs.getString('email') ?? 'User',
        'age': prefs.getString('age') ?? 'User',
        'address': prefs.getString('address') ?? 'User',
        'contact_num': prefs.getString('contact_num') ?? 'User',
      };
    });
  }

  Future<void> _showImagePickerDialog() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
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
    child: Stack(
      children: [
        Center(
          child: CircleAvatar(
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
        ),
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    ),
  );
}




  Widget _buildUserInfo() {
    if (userData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      children: [
        _buildUserInfoTile('User ID', userData!['user_id']),
        _buildUserInfoTile('Full Name', userData!['fullname']),
        _buildUserInfoTile('Username', userData!['username']),
        _buildUserInfoTile('Email', userData!['email']),
        _buildUserInfoTile('Address', userData!['address']),
        _buildUserInfoTile('Contact Number', userData!['contact_num']),
      ],
    );
  }

  Widget _buildUserInfoTile(String label, String value) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
      ),
      subtitle: Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
      ),
    );
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
        title: const Text('Your Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
                  child: _buildUserInfo(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
