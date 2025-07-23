import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/feature/auth/presentation/controller/auth_controller.dart';
import 'package:smart_trip_planner/feature/auth/presentation/page/signin_page.dart';
import 'package:smart_trip_planner/feature/auth/presentation/widgets/auth_feild.dart';
import '../../../../core/theme/theme.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  late final TextEditingController _emailController = TextEditingController();
  late final TextEditingController _passwordController =
      TextEditingController();
  late final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    _passwordController;
    _emailController;
    _confirmPasswordController;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    "✈️ Itinera AI",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Create your Account",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Let’s get started",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.subtitle),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: authState.isLoading
                          ? null
                          : () {
                              ref
                                  .read(authControllerProvider.notifier)
                                  .signInGoogle();
                            },
                      icon: Image.asset('assets/icon/google.png', height: 24),
                      label: const Text(
                        "Sign up with Google",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Text("or Sign up with Email"),
                  const SizedBox(height: 24),
                  AuthField(
                    hintText: "Email address",
                    icon: const Icon(Icons.email),
                    controller: _emailController,
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    hintText: "Password",
                    icon: const Icon(Icons.lock),
                    isObscureText: true,
                    controller: _passwordController,
                  ),
                  const SizedBox(height: 16),
                  AuthField(
                    hintText: "Confirm Password",
                    icon: const Icon(Icons.lock_outline),
                    isObscureText: true,
                    controller: _confirmPasswordController,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton(
                      onPressed: () {
                        final email = _emailController.text.trim();
                        final password = _passwordController.text.trim();
                        // final confirmPassword = _confirmPasswordController.text
                        // .trim();
                        if (_passwordController.text !=
                            _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Passwords do not match"),
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Signing up...")),
                        );

                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const SignInPage(),
                            ),
                          );
                        ref
                            .read(authControllerProvider.notifier)
                            .signUp(email, password);
                      },
                      child: const Text("Sign UP"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
