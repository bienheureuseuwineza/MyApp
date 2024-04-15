import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ClassMe/ThemeProvider.dart';
import 'package:ClassMe/google_signin_api.dart';
import 'package:ClassMe/main.dart';
import 'package:ClassMe/my_button.dart';
import 'package:ClassMe/my_textfield.dart';
import 'package:ClassMe/pages/login.dart';
import 'package:ClassMe/popup.dart';
import 'package:ClassMe/square_tile.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatelessWidget {
  SignupPage({Key? key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // sign user up method
  void signUserUp(BuildContext context) async {
    // Get the values from the controllers
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Check if password and confirm password match
    if (password == confirmPassword) {
      try {
        // Create a new user with Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // User registered successfully
        print('User registered successfully: ${userCredential.user?.email}');

        // Automatically sign in the user after successful registration
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email, password: password);

        // Show a success message
        showCustomPopup(context, 'Registration successful!');

      } on FirebaseAuthException catch (e) {
         // Handle registration errors
        print('Error during registration: ${e.message}');

        // Show appropriate error message
        if (e.code == 'weak-password') {
          showotherPopup(context, 'Error', 'Weak password. Please choose a stronger password.');
        } else if (e.code == 'email-already-in-use') {
          showotherPopup(context, 'Error', 'Email is already in use. Please use a different email.');
        } else {
          // Handle other error cases
          showotherPopup(context, 'Error', 'Registration failed. Please try again later.');
        }
      }
    } else {
      // Passwords do not match, show an error message
      showotherPopup(context, 'Error', 'Passwords do not match');
    }
  }


  // Function to show a popup with header and body
  void showCustomPopup(BuildContext context, String message) {
    // Call the showPopup function from popup.dart
    showPopup(context, 'Success', message);
    
    // Optionally, you can add additional actions after the popup is closed
    // For example, navigate to another page.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MyApp(),
      ),
    );
  }

  // navigate to login page
  void goToLoginPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // Function to show a popup with header and body
  void showotherPopup(BuildContext context, String header, String message) {
    // Call the showPopup function from popup.dart
    showPopup(context, header, message);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.currentTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: themeProvider.currentTheme.primaryColor,
        title: Text(
          'Sign Up',
          style: TextStyle(
            color: themeProvider.currentTheme.scaffoldBackgroundColor,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // logo
                  Icon(
                    Icons.auto_stories_rounded,
                    size: 80,
                    color: themeProvider.currentTheme.primaryColor,
                  ),

                  const SizedBox(height: 20),

                  // welcome message
                  Text(
                    'Welcome to our community',
                    style: TextStyle(
                      color: themeProvider.currentTheme.primaryColor,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 15),

                  // email textfield
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                    
                  ),

                  const SizedBox(height: 10),

                  // password textfield
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // confirm password textfield
                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 20),

                  // sign up button
                ElevatedButton(
  onPressed: () => signUserUp(context),
  child: Text(
    'Sign Up',
    style: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
       color: Colors.white, 
    ),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor:themeProvider.currentTheme.primaryColor,
    disabledBackgroundColor: Colors.white,
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),
),

                  const SizedBox(height: 30),

                  // or continue with
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: themeProvider.currentTheme.dividerColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or Use',
                            style: TextStyle(
                              color: themeProvider.currentTheme.primaryColor,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            thickness: 0.5,
                            color: themeProvider.currentTheme.dividerColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // google + apple sign up buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // google button
                      GestureDetector(
                        onTap: () async {
                          final user = await GoogleSignInApi.login();
                          if (user == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Sign in failed'),
                              ),
                            );
                          } else {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => MyApp(),
                              ),
                            );
                          }
                        },
                        child: SquareTile(imagePath: 'lib/images/google.png'),
                      ),
                      SizedBox(width: 25),

                      // apple button
                      SquareTile(imagePath: 'lib/images/linkedin.png'),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // already a member? login now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Have an account?',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => goToLoginPage(context),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: themeProvider.currentTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
