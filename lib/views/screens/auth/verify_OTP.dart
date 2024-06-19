import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:toptop/provider/login_phone.dart';
import 'package:timer_count_down/timer_count_down.dart';

class VerifyOTP extends StatelessWidget {
  const VerifyOTP({super.key});

  @override
  Widget build(BuildContext context) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Enter the code",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 35
                    ),),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text('${Provider.of<LoginPhoneProvider>(context, listen: false)
                          .textEditingController.text}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 20
                        ),),
                      const SizedBox(
                        width: 10,
                      ),
                      Center(
                          child: context
                              .watch<LoginPhoneProvider>()
                              .resend ? resend(context) : countDown(context)
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  PinCodeTextField(
                      appContext: context,
                      cursorColor: const Color.fromRGBO(234, 64, 128, 100,),
                      length: 6,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      pinTheme: PinTheme(
                        borderWidth: 2,
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(10),
                        inactiveColor: Colors.grey,
                        selectedColor: const Color.fromRGBO(234, 64, 128, 100,),
                      ),
                      onChanged: (value) {
                        Provider.of<LoginPhoneProvider>(context, listen: false)
                            .inputCode(value);
                      }),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // Visibility(
            //   visible: context
            //       .watch<LoginPhoneProvider>()
            //       .isErrorSms,
            //   child:  Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 15),
            //     child: Text("Confirm",
            //       style: TextStyle(color: Colors.red,
            //         fontWeight: FontWeight.w500,
            //         fontSize: 16,),
            //       textAlign: TextAlign.left,
            //     ),
            //   ),
            // ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<LoginPhoneProvider>(context, listen: false)
                      .verify(context);
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

  Widget countDown(BuildContext context) {
    return Countdown(
      seconds: 60,
      build: (BuildContext context, double time) =>
          Text('Resend ${time.toInt().toString()}',style: const TextStyle(
            fontSize: 17,
          ),),
      interval: const Duration(milliseconds: 1000),
      onFinished: () {
        context.read<LoginPhoneProvider>().Resend(true);
      },
    );
  }

  Widget resend(BuildContext context) {
    return InkWell(
      onTap: () async {
        context.read<LoginPhoneProvider>().Resend(false);
        context.read<LoginPhoneProvider>().smsError(false);
        await Provider.of<LoginPhoneProvider>(
            context, listen: false).onSubmitPhone(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
              width: 2,
              color: Colors.grey
          ),
          borderRadius: BorderRadius.circular(50),
        ),
        child:  const Text("Resend",
          style: TextStyle(
              fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}