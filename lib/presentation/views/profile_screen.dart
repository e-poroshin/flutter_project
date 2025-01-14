import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/profile_provider.dart';

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

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();

    _firstNameController.addListener(_onFieldChange);
    _lastNameController.addListener(_onFieldChange);
    _emailController.addListener(_onFieldChange);

    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.addListener(_populateFields);
    _populateFields();
  }

  void _populateFields() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    setState(() {
      _firstNameController.text = profileProvider.firstName;
      _lastNameController.text = profileProvider.lastName;
      _emailController.text = profileProvider.email;
    });
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
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.deepPurple;
                    },
                  ),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
                ),
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
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.removeListener(_populateFields);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}