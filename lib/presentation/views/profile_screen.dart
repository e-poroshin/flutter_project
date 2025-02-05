import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../l10n/app_localizations.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();

    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();

    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    viewModel.loadProfile();
    viewModel.addListener(_populateFields);
  }

  void _populateFields() {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    setState(() {
      _firstNameController.text = viewModel.profile?.firstName ?? '';
      _lastNameController.text = viewModel.profile?.lastName ?? '';
      _emailController.text = viewModel.profile?.email ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ProfileViewModel>(context);
    var localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(localizations.translate('profile'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: localizations.translate('firstName'),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => viewModel.updateProfile(
                value,
                _lastNameController.text,
                _emailController.text,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: localizations.translate('lastName'),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => viewModel.updateProfile(
                _firstNameController.text,
                value,
                _emailController.text,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: localizations.translate('email'),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => viewModel.updateProfile(
                _firstNameController.text,
                _lastNameController.text,
                value,
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
                onPressed: viewModel.hasChanged
                    ? () async {
                        await viewModel.saveProfile();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(localizations.translate('profileSaved'))),
                        );
                      }
                    : null,
                child: Text(localizations.translate('save')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    final viewModel = Provider.of<ProfileViewModel>(context, listen: false);
    viewModel.removeListener(_populateFields);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
