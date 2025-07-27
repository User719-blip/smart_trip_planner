// feature/profile/presentation/pages/profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_trip_planner/core/theme/theme.dart';
import 'package:smart_trip_planner/feature/profile/presentation/providers/profile_controller.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileControllerProvider);
    final controller = TextEditingController(text: profile.name);

    Future<void> _pickImage() async {
      final picker = ImagePicker();
      final picked = await picker.pickImage(source: ImageSource.gallery);
      if (picked != null) {
        ref.read(profileControllerProvider.notifier).updateImage(picked.path);
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: profile.imagePath != null
                      ? FileImage(File(profile.imagePath!))
                      : null,
                  backgroundColor: Colors.grey[300],
                  child: profile.imagePath == null
                      ? const Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.green,
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                )
              ],
            ),
            const SizedBox(height: 32),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: "Your name",
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) {
                ref.read(profileControllerProvider.notifier).updateName(value.trim());
              },
            ),
          ],
        ),
      ),
    );
  }
}
