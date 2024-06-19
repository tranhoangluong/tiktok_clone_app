import 'package:flutter/material.dart';
import 'package:toptop/database/service/user_service.dart';
import 'package:toptop/views/widget/colors.dart';
import 'package:toptop/views/widget/custom_button.dart';
import 'package:toptop/views/widget/text.dart';
import 'package:toptop/views/widget/textformfield.dart';


class UpdatePasswordScreen extends StatelessWidget {
  UpdatePasswordScreen({super.key});

  TextEditingController newPassword = TextEditingController();

  TextEditingController confirmPasswordController = TextEditingController();

  final _updatePasswordFormKey = GlobalKey<FormState>();

  doEdit(BuildContext context) {
    bool isValidate = _updatePasswordFormKey.currentState!.validate();
    if (isValidate) {
      UserService.changPassword(
          context: context, newPassword: newPassword.text);
    }
  }

  String? validatePassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value.length < 6) {
      return "Your password is so short !";
    }
  }

  String? validateConfirmPassword(String value) {
    if (value == '') {
      return "Empty Field !";
    } else if (value != newPassword.text) {
      return "Your confirmation password does not match !";
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height / 10,
                    left: MediaQuery.of(context).size.width / 5,
                    child: Center(
                      child: CustomText(
                        text: 'Update Password',
                        fontsize: 40,
                        color: Colors.black,
                        fontFamily: 'DancingScript',
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 0,
                    child: IconButton(
                      iconSize: 40,
                      icon: const Icon(
                        Icons.backspace,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).size.height / 12,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 3,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        // borderRadius: new BorderRadius.only(
                        //   bottomRight: const Radius.circular(40.0),
                        //   bottomLeft: const Radius.circular(40.0),
                        // ),
                      ),
                      child: Image.asset(
                        'assets/images/pinkbird.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                        // borderRadius: new BorderRadius.only(
                        //   bottomRight: const Radius.circular(40.0),
                        //   bottomLeft: const Radius.circular(40.0),
                        // ),
                      ),
                      child: Image.asset(
                        'assets/images/pinkwater.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 4 / 6,
                        width: MediaQuery.of(context).size.width - 32,
                        child: Form(
                          key: _updatePasswordFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 20),
                              CustomTextFormField(
                                  controller: newPassword,
                                  text: 'New Password',
                                  hint: '*********',
                                  passCheck: true,
                                  onSave: (value) {
                                    //controller.userPwd = value!;
                                  },
                                  validator: (value) {
                                    return validatePassword(value!);
                                  }),
                              CustomTextFormField(
                                  controller: confirmPasswordController,
                                  text: 'Confirm Password',
                                  hint: '*********',
                                  passCheck: true,
                                  onSave: (value) {
                                    //controller.userPwd = value!;
                                  },
                                  validator: (value) {
                                    return validateConfirmPassword(value!);
                                  }),
                              const SizedBox(height: 20),
                              CustomButton(
                                onPress: () {
                                  doEdit(context);
                                },
                                text: 'SAVE',
                                color: MyColors.thirdColor,
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
          ],
        ),
      ),
    );
  }
}