import 'package:smart_trip_planner/feature/auth/data/models/auth_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show
        SupabaseClient,
        OAuthProvider,
        Supabase,
        GoTrueClientSignInProvider;

abstract class AuthDatasource {
  Future<UserModel?> signInWithGoogle();
  Future<UserModel?> signUpWithGoogle();
  Future<UserModel?> signInWithEmail(String email, String password);
  Future<UserModel?> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Stream<UserModel?> get userChanges;
}

class SupabaseAuthDatasource implements AuthDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  @override
  Future<UserModel?> signInWithEmail(String email, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) return null;
    return UserModel.fromSupabase(user.toJson());
  }

  @override
  Future<UserModel?> signUpWithEmail(String email, String password) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
    );
    final user = response.user;
    print("SUPABASE RESPONSE: ${user?.toJson()}");
    if (user == null) return null;
    return UserModel.fromSupabase(user.toJson());
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://login-callback',
    );
    return null; // Will redirect → handle later in auth controller
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Stream<UserModel?> get userChanges =>
      _client.auth.onAuthStateChange.map((event) {
        final user = event.session?.user;
        return user != null ? UserModel.fromSupabase(user.toJson()) : null;
      });

  @override
  Future<UserModel?> signUpWithGoogle() async {
    await _client.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.flutter://login-callback',
    );
    return null; // Supabase redirects to browser. You can listen to authStateChanges
  }
}
