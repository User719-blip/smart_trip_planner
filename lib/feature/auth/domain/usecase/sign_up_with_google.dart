
import 'package:smart_trip_planner/feature/auth/domain/entity/auth_entity.dart';
import 'package:smart_trip_planner/feature/auth/domain/repo/auth_repo.dart';

class SignUpWithGoogle {
  final AuthRepository repository;

  SignUpWithGoogle(this.repository);

  Future<AppUser?> call() {
    return repository.signUpWithGoogle();
  }
}
