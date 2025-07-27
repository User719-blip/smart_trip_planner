
import 'package:smart_ai_trip_planner/feature/auth/domain/entity/auth_entity.dart';
import 'package:smart_ai_trip_planner/feature/auth/domain/repo/auth_repo.dart';

class SignInWithGoogle {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  Future<AppUser?> call() {
    return repository.signInWithGoogle();
  }
}
