// feature/profile/controller/profile_controller.dart
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final profileControllerProvider = StateNotifierProvider<ProfileController, ProfileState>(
  (ref) => ProfileController(),
);

class ProfileState {
  final String? name;
  final String? imagePath;

  ProfileState({this.name, this.imagePath});

  ProfileState copyWith({String? name, String? imagePath}) {
    return ProfileState(
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController() : super(ProfileState()) {
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('profile_name');
    final imagePath = prefs.getString('profile_image');
    state = ProfileState(name: name, imagePath: imagePath);
  }

  Future<void> updateName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', name);
    state = state.copyWith(name: name);
  }

  Future<void> updateImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);
    state = state.copyWith(imagePath: path);
  }
}
