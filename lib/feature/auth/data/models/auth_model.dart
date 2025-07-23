import 'package:smart_trip_planner/feature/auth/domain/entity/auth_entity.dart';



class UserModel extends AppUser {
  const UserModel({
    required super.uid,
    required super.email,
    super.name,
  });

  factory UserModel.fromSupabase(Map<String, dynamic> user) {
    return UserModel(
      uid: user['id'],
      email: user['email'],
      name: user['user_metadata']?['full_name'],
    );
  }
}
