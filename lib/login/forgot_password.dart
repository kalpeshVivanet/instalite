// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utilites/constant.dart';
import 'login_page.dart';
import 'sign_up.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  bool _isButtonClick = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isFormValid = _formKey.currentState?.validate() ?? false;

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              100.0), // Adjust the radius as needed
                          border: Border.all(
                            color: Colors.black, // Set the border color
                            width: 2.0, // Set the border width
                          ),
                        ),
                        padding: const EdgeInsets.all(
                            10.0), // Adjust the padding as needed
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          size: 100,
                        ),
                      ),
                      spaceht20,
                      const Text(
                        "Trouble with logging in?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      spaceht20,
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 35),
                        child: Text(
                          "Enter your email address, phone number or username, and we'll send you a link to get back into your account.",
                          style: TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      spaceht20,
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextFormField(
                          controller: _emailController,
                          style: const TextStyle(fontSize: 13.0),
                          decoration: const InputDecoration(
                            hintText: "Phone number, email or username",
                            hintStyle: TextStyle(fontSize: 13),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            filled: true,
                            fillColor: Color.fromARGB(255, 241, 241, 241),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter phone number, email or username";
                            }
                            return null;
                          },
                        ),
                      ),
                      spaceht20,
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            backgroundColor: isFormValid
                                ? Colors.blue
                                : Colors.blue.shade100,
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.85, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as needed
                            ),
                          ),
                          onPressed: isFormValid
                              ? () async {
                                  if (_formKey.currentState?.validate() ??
                                      false) {
                                    setState(() {
                                      _isButtonClick = true;
                                    });
                                    bool isMatchFound = false;
                                    try {
                                      QuerySnapshot querySnapshot =
                                          await FirebaseFirestore.instance
                                              .collection('UserDetail')
                                              .get();
                                      // ignore: avoid_function_literals_in_foreach_calls
                                      querySnapshot.docs.forEach((doc) async {
                                        if (doc["Email"] ==
                                                _emailController.text
                                                    .toLowerCase() ||
                                            doc["Mobile"] ==
                                                _emailController.text
                                                    .toLowerCase() ||
                                            doc["UserName"] ==
                                                _emailController.text
                                                    .toLowerCase()) {
                                          String email = doc["Email"];

                                          isMatchFound = true;
                                          await _auth.sendPasswordResetEmail(
                                              email: email.toLowerCase());
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text(
                                                  "Password reset link sent to your register email successfully"),
                                            ),
                                          );

                                          setState(() {
                                            _isButtonClick = false;
                                          });
                                          _emailController.clear();
                                        }
                                      });
                                      if (!isMatchFound) {
                                        throw FirebaseAuthException(
                                          code: 'invalid-email',
                                          message:
                                              'User not found with provided email, mobile, or username.',
                                        );
                                      }
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'invalid-email') {
                                        setState(() {
                                          _isButtonClick = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text(
                                                "User not found with provided email, mobile, or username."),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                }
                              : null,
                          child: _isButtonClick
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Send Login Link")),
                      // ElevatedButton(
                      //     onPressed: () {
                      //       if (_formKey.currentState?.validate() ?? false) {
                      //         print("true");
                      //       } else {
                      //         print("false");
                      //       }
                      //     },
                      //     child: Text("dd")),
                      spaceht40,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: const Divider(
                              indent: 5,
                              endIndent: 10,
                              thickness: 1.0,
                              color: Color.fromARGB(255, 198, 198, 198),
                            ),
                          ),
                          const Text("OR"),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: const Divider(
                              indent: 10,
                              endIndent: 5,
                              // height: 20,
                              thickness: 1.0,
                              color: Color.fromARGB(255, 198, 198, 198),
                            ),
                          ),
                        ],
                      ),
                      spaceht20,
                      TextButton(
                          onPressed: () {
                            Get.to(() => SignUp(), transition: Transition.zoom);
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return const SignUp();
                            // }));
                          },
                          child: const Text("Create New Account"))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Color.fromARGB(255, 198, 198, 198),
                width: 1.5, // Set the border width
              ),
            ),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 0, top: 0, right: 0, bottom: 18),
            child: TextButton(
                onPressed: () {
                  Get.to(() => LoginPage(), transition: Transition.zoom);
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return const LoginPage();
                  // }));
                },
                child: const Text(
                  "Back to Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0,
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
