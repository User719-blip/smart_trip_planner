import 'package:smart_ai_trip_planner/feature/auth/domain/repo/auth_repo.dart';



class SignOut {
  final AuthRepository repository;

  SignOut(this.repository);

  Future<void> call() async {
    await repository.signOut();
  }
}
