/// Represents the type of user accessing the AgriNexus platform.
enum UserRole { farmer, consumer, none }

/// Lightweight user session model used across the app.
class AppUser {
  final String name;
  final String identifier; // phone (farmer) or email (consumer)
  final UserRole role;

  const AppUser({
    required this.name,
    required this.identifier,
    required this.role,
  });
}
