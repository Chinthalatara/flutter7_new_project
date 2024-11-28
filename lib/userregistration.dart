import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:user_registration/modelclass.dart';
import 'package:user_registration/providerfile.dart';
import 'dart:typed_data';
import 'user_list.dart'; // Import the user list screen

class UserRegistrationForms extends ConsumerStatefulWidget {
  @override
  ConsumerState<UserRegistrationForms> createState() => _UserRegistrationFormState();
}

class _UserRegistrationFormState extends ConsumerState<UserRegistrationForms> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName, _lastName, _mobileNumber, _email, _password, _confirmPassword;
  Uint8List? _profilePhotoBytes;

  Future<void> _pickProfilePhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null && result.files.single.bytes != null) {
      setState(() {
        _profilePhotoBytes = result.files.single.bytes;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No file selected')));
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Only save the form if it's valid
      _formKey.currentState!.save();

      // Check if passwords match
      if (_password != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match')));
        return;
      }

      // Create a new user object
      final newUser = User(
        firstName: _firstName!,
        lastName: _lastName!,
        mobileNumber: _mobileNumber!,
        email: _email!,
        password: _password!,
        profilePhoto: _profilePhotoBytes,
      );

      // Add the user via Riverpod
      ref.read(userProvider.notifier).addUser(newUser);

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User Registered Successfully!')));

      // Navigate to the User List screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UserList()),
      );
    } else {
      // Optionally show a message if form validation failed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields correctly.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
        title: Text('User Registration Form'),
        
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              
              children: [
                
                _buildTextField(
                  label: 'First Name',
                  onSave: (value) => _firstName = value,
                  validator: (value) => value!.isEmpty ? 'Enter First Name' : null,
                ),
                _buildTextField(
                  label: 'Last Name',
                  onSave: (value) => _lastName = value,
                  validator: (value) => value!.isEmpty ? 'Enter Last Name' : null,
                ),
                _buildTextField(
                  label: 'Mobile Number',
                  keyboardType: TextInputType.phone,
                  onSave: (value) => _mobileNumber = value,
                  validator: (value) {
                    if (value!.isEmpty) return 'Enter Mobile Number';
                    final users = ref.read(userProvider);
                    if (users.any((user) => user.mobileNumber == value)) {
                      return 'Mobile Number already registered';
                    }
                    return null;
                  },
                ),
                _buildTextField(
                  label: 'Email ID',
                  keyboardType: TextInputType.emailAddress,
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
                  isPassword: false,
                  onSave: (value) => _password = value,
                  validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
                ),
                _buildTextField(
                  label: 'Confirm Password',
                  isPassword: false,
                  onSave: (value) => _confirmPassword = value,
                  validator: (value) => value!.isEmpty ? 'Confirm Password is required' : null,
                ),
                ElevatedButton(
                  onPressed: _pickProfilePhoto,
                  child: Text('Pick Profile Photo'),
                ),
                if (_profilePhotoBytes != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Image.memory(
                      _profilePhotoBytes!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                else
                  Text('No Profile Photo Selected'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    TextInputType keyboardType = TextInputType.text,
    required FormFieldSetter<String> onSave,
    required FormFieldValidator<String> validator,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        keyboardType: keyboardType,
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

