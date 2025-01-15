import '/domain/entities/profile.dart';
import '/domain/repositories/profile_repository.dart';
import '../datasources/local/profile_local_datasorce.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource localDataSource;

  ProfileRepositoryImpl(this.localDataSource);

  @override
  Future<Profile> getProfile() async {
    return await localDataSource.getProfile();
  }

  @override
  Future<void> saveProfile(Profile profile) async {
    await localDataSource.saveProfile(profile);
  }
}
