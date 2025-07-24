import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/core/theme/theme.dart';
import 'package:smart_trip_planner/feature/trip/presetationn/pages/trip_home_page.dart';
import 'package:smart_trip_planner/feature/auth/presentation/controller/auth_controller.dart';
import 'package:smart_trip_planner/feature/auth/presentation/page/signin_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

 await Supabase.initialize(
    url: 'https://drgbidfypnadbuyfvvqc.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRyZ2JpZGZ5cG5hZGJ1eWZ2dnFjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTMyMDE0MjIsImV4cCI6MjA2ODc3NzQyMn0.CmG237fLxTUCitYaxPm3DIicKpQnD2QD4gfWJ5xhh08',
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
            user != null ? const TripHomePage() : const SignInPage(),
        loading: () =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, _) => Scaffold(body: Center(child: Text("Error: $e"))),
      ),
    );
  }
}