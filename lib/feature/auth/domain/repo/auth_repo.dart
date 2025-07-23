import 'package:smart_trip_planner/feature/auth/domain/entity/auth_entity.dart';


abstract class AuthRepository {
  Future<AppUser?> signInWithGoogle();
  Future<AppUser?> signUpWithGoogle();
  Future<AppUser?> signInWithEmail({
    required String email,
    required String password,
  });
  Future<AppUser?> signUpWithEmail({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Stream<AppUser?> get authStateChanges; // global user stream
}
