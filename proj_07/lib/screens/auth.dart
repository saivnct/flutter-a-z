import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proj_07/widgets/user_image_picker.dart';

enum AuthMode { signup, login }

final _firebaseAuth = FirebaseAuth.instance;

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() {
    return _AuthScreenState();
  }
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  AuthMode authMode = AuthMode.login;
  var _email = '';
  var _username = '';
  var _pass = '';
  File? _userImageFile;

  var _isLoading = false;

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    //close soft keyboard
    FocusScope.of(context).unfocus();

    if (!isValid) {
      return;
    }

    if (authMode == AuthMode.signup && _userImageFile == null) {
      return;
    }

    //trigger onSaved for all form fields
    _formKey.currentState!.save();
    // print(_email);
    // print(_pass);

    try {
      setState(() {
        _isLoading = true;
      });

      if (authMode == AuthMode.login) {
        final userCredentials = await _firebaseAuth.signInWithEmailAndPassword(
            email: _email, password: _pass);
      } else if (authMode == AuthMode.signup) {
        final userCredentials = await _firebaseAuth
            .createUserWithEmailAndPassword(email: _email, password: _pass);

        final storageRef = FirebaseStorage.instance
            .ref()
            .child('user_images')
            .child('${userCredentials.user!.uid}.jpg');
        await storageRef.putFile(_userImageFile!);
        final imageURL = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredentials.user!.uid)
            .set({
          'username': _username,
          'email': _email,
          'image_url': imageURL,
        });
      }
    } on FirebaseAuthException catch (error) {
      //on catch allow define the type of error
      //only exception of the type FirebaseAuthException will be caught & handled
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? "Authentication failed")),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(
                    top: 30, bottom: 20, left: 20, right: 20),
                width: 200,
                child: Image.asset('assets/images/chat.png'),
              ),
              Card(
                margin: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        //make sure this column only take as much vertical space as it needs
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (authMode == AuthMode.signup)
                            UserImagePicker(
                              onSelectedImage: (imageFile) {
                                _userImageFile = imageFile;
                              },
                            ),
                          if (authMode == AuthMode.signup)
                            TextFormField(
                              decoration:
                                  const InputDecoration(labelText: 'Username'),
                              enableSuggestions: false,
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.trim().length < 4) {
                                  return 'Please enter a valid username.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _username = value!;
                              },
                            ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                            //disable auto capitalization (1st character not uppercase)
                            textCapitalization: TextCapitalization.none,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  !value.contains('@')) {
                                return 'Please enter a valid email address.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value.trim().length < 6) {
                                return 'Please enter a valid password. Password must be at least 6 characters long.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _pass = value!;
                            },
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          if (_isLoading) const CircularProgressIndicator(),
                          if (!_isLoading)
                            ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                              child: Text(authMode == AuthMode.login
                                  ? 'Login'
                                  : 'Signup'),
                            ),
                          if (!_isLoading)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  authMode = (authMode == AuthMode.login)
                                      ? AuthMode.signup
                                      : AuthMode.login;
                                });
                              },
                              child: Text(authMode == AuthMode.login
                                  ? 'Create new account'
                                  : 'Already have an account? Login.'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
