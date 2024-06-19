import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:toptop/provider/login_phone.dart';

class LoginWithPhoneNumber extends StatelessWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginPhoneProvider>(builder: (context, myProvider, _) {
      return Scaffold(
        extendBody: true,
        backgroundColor: Colors.white,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: const Text("Nhập số điện thoại",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 35
                  ),),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: IntlPhoneField(
                          decoration: const InputDecoration(
                            counterText: '',
                          ),
                          initialCountryCode: 'VN',
                          onCountryChanged: (phone) {
                            myProvider.selectedCountry(
                                '+${phone.fullCountryCode.toString()}');
                          },
                        )
                    ),
                    const SizedBox(width: 8,),
                    Expanded(
                      flex: 4,
                      child: TextField(
                        controller: context
                            .watch<LoginPhoneProvider>()
                            .textEditingController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintText: "VD: 384745334",
                          hintStyle: TextStyle(
                              color: Colors.grey, fontSize: 14),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.grey, width: 1.5),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.black87, width: 1),
                          ),
                        ),
                        onChanged: (value) {
                          myProvider.onTextFieldChanged();
                        },
                      ),
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Visibility(
                  visible: myProvider.isErrorText,
                  child: const Text("bạn cần nhập đúng định dạng số",
                    style: TextStyle(color: Colors.red,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<LoginPhoneProvider>().onSubmitPhone(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text("Xác nhận"),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

}