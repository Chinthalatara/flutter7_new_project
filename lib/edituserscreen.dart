import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_registration/modelclass.dart';
import 'package:user_registration/providerfile.dart';

class EditUserScreen extends ConsumerStatefulWidget {
  final User user;

  EditUserScreen({required this.user});

  @override
  ConsumerState<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends ConsumerState<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName, _lastName, _mobileNumber, _email, _password;
  Uint8List? _profilePhotoBytes;

  @override
  void initState() {
    super.initState();
    // Pre-fill the form with the current user data
    _firstName = widget.user.firstName;
    _lastName = widget.user.lastName;
    _mobileNumber = widget.user.mobileNumber;
    _email = widget.user.email;
    _password = widget.user.password;
    _profilePhotoBytes = widget.user.profilePhoto;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Update the user via Riverpod
      final updatedUser = User(
        firstName: _firstName!,
        lastName: _lastName!,
        mobileNumber: _mobileNumber!,
        email: _email!,
        password: _password!,
        profilePhoto: _profilePhotoBytes,
      );

      ref.read(userProvider.notifier).updateUser(updatedUser);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Updated')));

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit User')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                label: 'First Name',
                initialValue: _firstName,
                onSave: (value) => _firstName = value,
                validator: (value) => value!.isEmpty ? 'Enter First Name' : null,
              ),
              _buildTextField(
                label: 'Last Name',
                initialValue: _lastName,
                onSave: (value) => _lastName = value,
                validator: (value) => value!.isEmpty ? 'Enter Last Name' : null,
              ),
              _buildTextField(
                label: 'Mobile Number',
                initialValue: _mobileNumber,
                onSave: (value) => _mobileNumber = value,
                validator: (value) => value!.isEmpty ? 'Enter Mobile Number' : null,
              ),
              _buildTextField(
                label: 'Email ID',
                initialValue: _email,
                onSave: (value) => _email = value,
                validator: (value) {
                  if (value!.isEmpty) return 'Enter Email ID';
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Enter valid Email ID';
                  }
                  return null;
                },
              ),
              _buildTextField(
                label: 'Password',
                initialValue: _password,
                isPassword: true,
                onSave: (value) => _password = value,
                validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
              ),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Update User'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? initialValue,
    required FormFieldSetter<String> onSave,
    required FormFieldValidator<String> validator,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        initialValue: initialValue,
        obscureText: isPassword,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onSaved: onSave,
        validator: validator,
      ),
    );
  }
}
