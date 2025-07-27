import 'package:smart_ai_trip_planner/feature/auth/data/datasources/auth_datasource.dart';
import 'package:smart_ai_trip_planner/feature/auth/domain/entity/auth_entity.dart';
import 'package:smart_ai_trip_planner/feature/auth/domain/repo/auth_repo.dart';


class SupabaseAuthRepository implements AuthRepository {
  final AuthDatasource datasource;

  SupabaseAuthRepository(this.datasource);

  @override
  Future<AppUser?> signInWithEmail({required String email, required String password}) {
    return datasource.signInWithEmail(email, password);
  }

  @override
  Future<AppUser?> signUpWithEmail({required String email, required String password}) {
    print("📦 Repo: calling datasource.signUpWithEmail");
    return datasource.signUpWithEmail(email, password);
  }

  @override
  Future<AppUser?> signInWithGoogle() {
    return datasource.signInWithGoogle();
  }

  @override
  Future<void> signOut() => datasource.signOut();

  @override
  Stream<AppUser?> get authStateChanges => datasource.userChanges;

  @override
  Future<AppUser?> signUpWithGoogle() {
     return datasource.signUpWithGoogle();
  }
}
