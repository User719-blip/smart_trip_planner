# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.kts.

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-dontwarn io.flutter.embedding.**

# Isar specific rules
-keep class io.isar.** { *; }
-keep @io.isar.annotation.Collection class * { *; }
-keep class **\$*.class { *; }

# Keep all classes with Isar annotations
-keep @io.isar.annotation.* class * { *; }

# Keep generated Isar files
-keep class **.*Schema { *; }
-keep class **.*Adapter { *; }

# Keep your model classes (replace with your actual package)
-keep class com.example.smart_trip_planner.feature.trip.data.models.** { *; }

# Additional safety for reflection
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses