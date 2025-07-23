import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_trip_planner/feature/auth/data/datasources/auth_datasource.dart';
import 'package:smart_trip_planner/feature/auth/data/repo/auth_repo_impl.dart';
import 'package:smart_trip_planner/feature/auth/domain/repo/auth_repo.dart';

/// 🔌 Provides SupabaseAuthDatasource
final authDatasourceProvider = Provider<AuthDatasource>((ref) {
  final client = Supabase.instance.client;
  return SupabaseAuthDatasource(); // already has `_client` internally
});

/// 🔌 Provides SupabaseAuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final datasource = ref.read(authDatasourceProvider);
  return SupabaseAuthRepository(datasource);
});
