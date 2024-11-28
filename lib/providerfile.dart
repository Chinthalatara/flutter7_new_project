 import 'package:flutter_riverpod/flutter_riverpod.dart';
 import 'dart:typed_data';

 import 'package:user_registration/modelclass.dart';



// class UserNotifier extends StateNotifier<List<User>> {
//   UserNotifier() : super([]);

//   // Create
//   void addUser(User user) {
//     state = [...state, user];
//   }

//   // Read
//   List<User> getUsers() => state;

//   // Update
//   void updateUser(String mobileNumber, User updatedUser) {
//     state = state.map((user) {
//       return user.mobileNumber == mobileNumber ? updatedUser : user;
//     }).toList();
//   }

//   // Delete
//   void deleteUser(String mobileNumber) {
//     state = state.where((user) => user.mobileNumber != mobileNumber).toList();
//   }
// }

final userProvider = StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<List<User>> {
  UserNotifier() : super([]);

  // Add user to the list
  void addUser(User user) {
    state = [...state, user];
  }

  // Delete a user by mobile number
  void deleteUser(String mobileNumber) {
    state = state.where((user) => user.mobileNumber != mobileNumber).toList();
  }

  // Update a user in the list
  void updateUser(User updatedUser) {
    state = [
      for (final user in state)
        if (user.mobileNumber == updatedUser.mobileNumber) updatedUser else user
    ];
  }
}
