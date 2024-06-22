// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:instalite/main_screen.dart';
import '../utilites/constant.dart';
import 'forgot_password.dart';
import 'sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoginButtonClick = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Instagram",
                        style: TextStyle(
                            fontFamily: 'Billabong',
                            fontWeight: FontWeight.bold,
                            fontSize: 45),
                      ),
                      spaceht30,
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
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: !_isPasswordVisible,
                          style: const TextStyle(fontSize: 13.0),
                          decoration: InputDecoration(
                            hintText: "Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                            suffixIconColor:
                                _isPasswordVisible ? Colors.blue : Colors.grey,
                            hintStyle: const TextStyle(fontSize: 13),
                            border: const OutlineInputBorder(),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            filled: true,
                            fillColor: const Color.fromARGB(255, 241, 241, 241),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter password";
                            }
                            return null;
                          },
                        ),
                      ),
                      spaceht20,
                      ElevatedButton(
                          style: TextButton.styleFrom(
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.85, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  10.0), // Adjust the radius as needed
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              setState(() {
                                _isLoginButtonClick = true;
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
                                          _emailController.text.toLowerCase() ||
                                      doc["Mobile"] ==
                                          _emailController.text.toLowerCase() ||
                                      doc["UserName"] ==
                                          _emailController.text.toLowerCase()) {
                                    try {
                                      String email = doc["Email"];
                                      isMatchFound = true;

                                      await _auth.signInWithEmailAndPassword(
                                        email: email.toLowerCase(),
                                        password: _passwordController.text,
                                      );
                                      final auth = FirebaseAuth.instance;
                                      User user = auth.currentUser!;
                                      if (user.emailVerified) {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return MainScreen();
                                        }));
                                      } else {
                                        user = auth.currentUser!;
                                        user.sendEmailVerification();

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.green,
                                            content: Text(
                                                "Your Email is not Verified..verify first! link send to $email"),
                                          ),
                                        );
                                        auth.signOut();
                                        // await user.reload();
                                      }

                                      setState(() {
                                        _isLoginButtonClick = false;
                                      });
                                      _emailController.clear();
                                      _passwordController.clear();
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'wrong-password' ||
                                          e.code == 'invalid-credential') {
                                        setState(() {
                                          _isLoginButtonClick = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.red,
                                            content: Text("Invalid password"),
                                          ),
                                        );
                                      }
                                    }
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
                                    _isLoginButtonClick = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          "User not found with provided email, mobile, or username."),
                                    ),
                                  );
                                }
                              }
                            }
                          },
                          child: _isLoginButtonClick
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Log in")),
                      spaceht20,
                      TextButton(
                          onPressed: () {
                            Get.to(() => const ForgotPassword(),
                                transition: Transition.zoom);
                            // Navigator.push(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return const ForgotPassword();
                            // }));
                          },
                          child: const Text("Forgotten your password?",
                              style: TextStyle(fontSize: 13.0))),
                      spaceht20,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            FontAwesomeIcons.facebook,
                            color: Colors.blue,
                          ),
                          // spacewt5,
                          TextButton(
                              onPressed: () async {
                                // Trigger Facebook login
                                final result =
                                    await FacebookAuth.instance.login();

                                // Check if the login was successful
                                if (result.status == LoginStatus.success) {
                                  // Authenticate with Firebase using the Facebook access token
                                  final AuthCredential credential =
                                      FacebookAuthProvider.credential(
                                          result.accessToken!.token);
                                  await FirebaseAuth.instance
                                      .signInWithCredential(credential);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MainScreen();
                                  }));
                                  print('User signed in with Facebook');
                                  print(credential);
                                } else {
                                  print('Facebook login failed');
                                }
                              },
                              child: const Text("Log in with Facebook",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                  )))
                        ],
                      ),
                    ],
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 13.0),
                  ),
                  TextButton(
                      onPressed: () {
                        Get.to(() => const SignUp(),
                            transition: Transition.zoom);
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) {
                        //   return const SignUp();
                        // }));
                      },
                      child: const Text(
                        "Sign up.",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13.0,
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
