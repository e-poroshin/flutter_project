import 'package:flutter/material.dart';

import '/domain/entities/profile.dart';
import '/domain/usecases/get_profile_usecase.dart';
import '/domain/usecases/save_profile_usecase.dart';

class ProfileViewModel extends ChangeNotifier {
  final GetProfileUseCase getProfileUseCase;
  final SaveProfileUseCase saveProfileUseCase;

  ProfileViewModel({
    required this.getProfileUseCase,
    required this.saveProfileUseCase,
  });

  Profile? _profile;
  Profile? _initialProfile;
  bool _hasChanged = false;

  Profile? get profile => _profile;

  bool get hasChanged => _hasChanged;

  Future<void> loadProfile() async {
    _profile = await getProfileUseCase();
    _initialProfile = _profile;
    notifyListeners();
  }

  void updateProfile(String firstName, String lastName, String email) {
    _profile = Profile(firstName: firstName, lastName: lastName, email: email);
    _hasChanged = _profile?.isNotEqual(_initialProfile) ?? true;
    notifyListeners();
  }

  Future<void> saveProfile() async {
    if (_profile != null) {
      await saveProfileUseCase(_profile!);
      _initialProfile = _profile;
      _hasChanged = false;
      notifyListeners();
    }
  }
}
