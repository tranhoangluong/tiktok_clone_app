import 'package:flutter/material.dart';
import 'package:toptop/database/service/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final _registerFormKey = GlobalKey<FormState>();

  bool isValidEmail(String email) {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email);
  }

  String? validateEmail(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (!isValidEmail(value)) {
      return "Wrong Email !";
    } else {
      return null;
    }
  }

  doRegister(BuildContext context) {
    if(validate()){
      AuthService.registerFetch(
          context: context,
          email: emailController.text,
          password: passwordController.text,
          fullName: nameController.text,
          uid: ''
      );
    }
  }

  bool validate() {
    if (nameController.text.isNotEmpty && emailController.text.isNotEmpty && passwordController.text.isNotEmpty && confirmPasswordController.text.isNotEmpty) {
      return true;
    }
    return false;
  }

  String? validatePassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value.length <= 5) {
      return "Your password is so short !";
    } else {
      return null;
    }
  }

  String? validateConfirmPassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value != passwordController.text) {
      return "Your confirmation password does not match !";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            Icons.west,
            color: Colors.grey,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            info(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  doRegister(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text("Confirm"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget info() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(margin: const EdgeInsets.symmetric(vertical: 20),
              child: const Text('Sign up for TikTok',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),)),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              hintText: "Full name",
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: emailController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              hintText: "Email",
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: passwordController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              hintText: "Password",
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          TextField(
            controller: confirmPasswordController,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15.0),
              hintText: "Confirm Password",
            ),
            obscureText: true,
          ),
        ],
      ),
    );
  }
}