import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/profile_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;
  bool _hasChanged = false;

  @override
  void initState() {
    super.initState();
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    _firstNameController =
        TextEditingController(text: profileProvider.firstName);
    _lastNameController = TextEditingController(text: profileProvider.lastName);
    _emailController = TextEditingController(text: profileProvider.email);

    _firstNameController.addListener(_onFieldChange);
    _lastNameController.addListener(_onFieldChange);
    _emailController.addListener(_onFieldChange);
  }

  void _onFieldChange() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    setState(() {
      _hasChanged = _firstNameController.text != profileProvider.firstName ||
          _lastNameController.text != profileProvider.lastName ||
          _emailController.text != profileProvider.email;
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _hasChanged
                  ? () {
                      profileProvider.saveProfile(
                        _firstNameController.text,
                        _lastNameController.text,
                        _emailController.text,
                      );
                      setState(() {
                        _hasChanged = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile saved!')),
                      );
                    }
                  : null,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
