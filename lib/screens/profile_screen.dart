  import 'package:flutter/material.dart';
  import 'package:iconsax_flutter/iconsax_flutter.dart';
  import 'package:ionicons/ionicons.dart';
  import 'package:provider/provider.dart';
  import '../providers/auth_provider.dart';

  class ProfileScreen extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      final authProvider = Provider.of<AuthProvider>(context);
      final user = authProvider.user;

      if (user == null) {
        return Scaffold(
          body: Center(child: Text('Error: User data is null')),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          automaticallyImplyLeading: false,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      Card(
                        color: Color(
                                    0xFF5B0B0E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.white, // Memberi warna pada bulatan ikon
                                child: Icon(Iconsax.user_copy,
                                    color:  Color(
                                    0xFF5B0B0E),
                                    size: 40), // Icon for avatar
                              ),
                              SizedBox(height: 16),
                              Text(
                                user['name'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                user['role'],
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              Divider(height: 60),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        _showEditProfileDialog(
                                            context, authProvider, user);
                                      },
                                      icon: Icon(Iconsax.edit_copy,
                                          color: Colors.lightBlue),
                                      label: Text(
                                        'Edit Profile',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _showChangePasswordDialog(
                                          context, authProvider),
                                      icon: Icon(Iconsax.lock_1_copy,
                                          color: Colors.deepOrange),
                                      label: Text('Change Password',
                                          style: TextStyle(color: Colors.black)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: Icon(Icons.logout),
                          title: Text('Logout'),
                          onTap: () async {
                            await authProvider.logout();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    void _showChangePasswordDialog(
        BuildContext context, AuthProvider authProvider) {
      final _currentPasswordController = TextEditingController();
      final _newPasswordController = TextEditingController();
      final _formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Color.fromARGB(255, 80, 36, 36),
          title: Text('Change Password', style: TextStyle(color: Colors.white)),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  decoration: InputDecoration(labelText: 'Current Password', labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white), // Atur warna teks input tex
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your current password';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _newPasswordController,
                  decoration: InputDecoration(labelText: 'New Password', labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white), // Atur warna teks input tex
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
                    }
                    if (value.length < 8) {
                      return 'Password must be at least 8 characters';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await authProvider.changePassword(
                      _currentPasswordController.text,
                      _newPasswordController.text,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password changed successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to change password')),
                    );
                  }
                }
              },
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }

    void _showEditProfileDialog(BuildContext context, AuthProvider authProvider,
        Map<String, dynamic> user) {
      final _nameController = TextEditingController(text: user['name']);
      final _emailController = TextEditingController(text: user['email']);
      final _phoneController = TextEditingController(text: user['phone']);
      final _formKey = GlobalKey<FormState>();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
           backgroundColor: Color.fromARGB(255, 80, 36, 36),
          title: Text('Edit Profile', style: TextStyle(color: Colors.white)),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Name', labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white), // Atur warna teks input tex
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white), // Atur warna teks input tex
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone', labelStyle: TextStyle(color: Colors.white)),
                  style: TextStyle(color: Colors.white), // Atur warna teks input tex
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    if (!value.startsWith('08')) {
                      return 'Phone number must start with 08';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await authProvider.updateProfile({
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'phone': _phoneController.text,
                    });
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Profile updated successfully')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to update profile')),
                    );
                  }
                }
              },
              child: Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      );
    }
  }
