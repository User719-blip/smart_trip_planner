import 'package:smart_ai_trip_planner/feature/auth/domain/entity/auth_entity.dart';
import 'package:smart_ai_trip_planner/feature/auth/domain/repo/auth_repo.dart';



class SignUpWithEmail {
  final AuthRepository repository;

  SignUpWithEmail(this.repository);

  Future<AppUser?> call(String email, String password) {
      print("📦 Usecase: calling repo.signUpWithEmail");
    return repository.signUpWithEmail(email: email, password: password);
  }
}
