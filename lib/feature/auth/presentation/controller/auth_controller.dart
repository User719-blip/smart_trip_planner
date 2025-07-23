import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/feature/auth/data/provider/auth_provider.dart';
import 'package:smart_trip_planner/feature/auth/data/repo/auth_repo_impl.dart';
import 'package:smart_trip_planner/feature/auth/domain/entity/auth_entity.dart';
import 'package:smart_trip_planner/feature/auth/domain/repo/auth_repo.dart';
import 'package:smart_trip_planner/feature/auth/domain/usecase/sign_in_with_email.dart';
import 'package:smart_trip_planner/feature/auth/domain/usecase/sign_in_with_google.dart';
import 'package:smart_trip_planner/feature/auth/domain/usecase/sign_out.dart';
import 'package:smart_trip_planner/feature/auth/domain/usecase/sign_up_with_email.dart';
import 'package:smart_trip_planner/feature/auth/domain/usecase/sign_up_with_google.dart';


final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.read(authDatasourceProvider);
  return SupabaseAuthRepository(datasource);
});

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<AppUser?>>((ref) {
      // ignore: prefer_typing_uninitialized_variables
      
      final repo = ref.read(authRepositoryProvider); // provide below
      return AuthController(
        signUpWithGoogle: SignUpWithGoogle(repo), 
        signInWithGoogle: SignInWithGoogle(repo),
        signInWithEmail: SignInWithEmail(repo),
        signUpWithEmail: SignUpWithEmail(repo),
        signOutUser: SignOut(repo),
        authRepository: repo,
      );
    });

class AuthController extends StateNotifier<AsyncValue<AppUser?>> {
  final SignInWithGoogle signInWithGoogle;
  final SignUpWithGoogle signUpWithGoogle;
  final SignInWithEmail signInWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SignOut signOutUser;
  final AuthRepository authRepository;

  AuthController({
    required this.signUpWithGoogle, 
    required this.signInWithGoogle,
    required this.signInWithEmail,
    required this.signUpWithEmail,
    required this.signOutUser,
    required this.authRepository,
  }) : super(const AsyncValue.loading()) {
    // Listen to auth state
    authRepository.authStateChanges.listen((user) {
      state = AsyncValue.data(user);
    });
  }

  Future<void> signInGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await signInWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUpGoogle() async {
    state = const AsyncValue.loading();
    try {
      final user = await signUpWithGoogle();
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final user = await signInWithEmail(email, password);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signUp(String email, String password) async {
    print("🔥 Controller → signUp called");
    state = const AsyncValue.loading();
    try {
      final user = await signUpWithEmail(email, password);
      print("SUPABASE RESPONSE: ${user.toString()}"); // Add this line
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    await signOutUser();
    state = const AsyncValue.data(null);
  }
}
