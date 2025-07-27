
import 'package:smart_ai_trip_planner/feature/auth/domain/entity/auth_entity.dart';
import 'package:smart_ai_trip_planner/feature/auth/domain/repo/auth_repo.dart';

class SignInWithEmail {
  final AuthRepository repository;

  SignInWithEmail(this.repository);

  Future<AppUser?> call(String email, String password) {
     
    return repository.signInWithEmail(email: email, password: password);
  }
}
