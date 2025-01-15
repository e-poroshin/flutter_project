import '/domain/entities/profile.dart';
import '/domain/repositories/profile_repository.dart';

class SaveProfileUseCase {
  final ProfileRepository repository;

  SaveProfileUseCase(this.repository);

  Future<void> call(Profile profile) async {
    await repository.saveProfile(profile);
  }
}
