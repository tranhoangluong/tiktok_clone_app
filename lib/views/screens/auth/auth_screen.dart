import 'package:flutter/material.dart';
import 'package:toptop/views/screens/auth/login_phone_screen.dart';
import 'package:toptop/views/screens/auth/login_screen.dart';
import 'package:toptop/views/screens/auth/register_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return body(context);
  }
  Widget body(BuildContext context){
    return SafeArea(
      child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: const Text(
                    "Log in to TopTop",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  )),
              Container(
                  margin: const EdgeInsets.only(top: 20,bottom: 20),
                  child: const Text(
                    "Manage your account, check notifications,\ncomment on videos, and more",
                    style: TextStyle(fontSize: 16,color: Colors.grey),
                    textAlign: TextAlign.center,
                  )),
              login(context),
              const SizedBox(height: 20), // Khoảng cách giữa nút đăng nhập và dòng đăng ký
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign up.",
                  style: TextStyle(fontSize: 12, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )),
    );
  }
  Widget login(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginWithPhoneNumber()),
              );
            },
            style: ElevatedButton.styleFrom(// Màu nền của nút
              backgroundColor: Colors.white38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // Độ bo tròn góc của nút
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(Icons.phone,color: Colors.black,),
                  SizedBox(width: 20),
                  Text("Login with Phone number", style: TextStyle(fontSize: 14,color: Colors.black)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            style: ElevatedButton.styleFrom(// Màu nền của nút
              backgroundColor: Colors.white38,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5), // Độ bo tròn góc của nút
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Icon(Icons.email,color: Colors.black,),
                  SizedBox(width: 20),
                  Text("Login with Email", style: TextStyle(fontSize: 14,color: Colors.black)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}