import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/core/theme/theme.dart';
import 'package:smart_trip_planner/feature/auth/home/home_page.dart';
import 'package:smart_trip_planner/feature/auth/presentation/controller/auth_controller.dart';
import 'package:smart_trip_planner/feature/auth/presentation/page/signin_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: '',
    anonKey: '',
  );
  runApp(ProviderScope(child: Main()));
}

class Main extends ConsumerWidget {
const Main({ super.key });

  @override
  Widget build(BuildContext context , WidgetRef ref ){
    final authState = ref.watch(authControllerProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'smart trip planner',
      theme: lightTheme,
       home: authState.when(
        data: (user) =>
            user != null ? const HomeScreen() : const SignInPage(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
      ),
    );
  }
}