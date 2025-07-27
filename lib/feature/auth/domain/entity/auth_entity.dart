class AppUser {
  final String uid;
  final String email;
  final String? name;

  const AppUser({
    required this.uid,
    required this.email,
    this.name,
  });
}
