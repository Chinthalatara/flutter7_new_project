import 'dart:typed_data';

class User {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String email;
  final String password;
  final Uint8List? profilePhoto;

  User({
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.email,
    required this.password,
    this.profilePhoto,
  });
}
