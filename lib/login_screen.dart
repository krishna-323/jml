import 'package:flutter/material.dart';
import 'package:jml/home/home_screen.dart';
import 'package:jml/utils/jml_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final userName = TextEditingController();
  bool userBool=false;
  final password = TextEditingController();
  bool showError = false;
  bool passWordHindBool=true;
  bool passWordColor = false;

  void passwordHideAndViewFunc() {
    setState(() {
      passWordHindBool = !passWordHindBool;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              height: 220,
              width: 500,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: Colors.white,),
              child: Row(
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        decoration:   const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10)),
                          color:Colors.white,
                          //Color(0xff00004d),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(18.0),
                              child: Image.asset("assets/logo/Ikyam_color_logo.png"),
                            )
                          ],
                        ),
                      )
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration:  BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10)),
                        color: Colors.blue[50],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(28.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Welcome",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
                            SizedBox(
                              height: 30,
                              child: TextField(
                                controller: userName,
                                style: const TextStyle(fontSize: 12),
                                decoration: decorationInput3("User Name", userBool),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                              child: TextField(
                                controller: password,
                                style: const TextStyle(fontSize: 12),
                                decoration: decorationInput3("Password", userBool),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                color: Color(0xff00004d),
                              ),
                              child: TextButton(onPressed: () {
                                Navigator.of(context).push(
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation, secondaryAnimation) =>  const HomeScreen(selectedDestination: 0,drawerWidth: 190),
                                    )
                                );
                              }, child: const Text("Login",style:  TextStyle(color: Colors.white,),)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  decorationInput3(String hintString, bool val,) {
    return  InputDecoration(

        label: Text(
          hintString,
        ),
        counterText: '',labelStyle: const TextStyle(fontSize: 12),
        contentPadding:  const EdgeInsets.fromLTRB(12, 00, 0, 0),
        hintText: hintString,
        suffixIconColor: const Color(0xfff26442),
        disabledBorder:  const OutlineInputBorder(borderSide:  BorderSide(color:  Colors.white)),
        enabledBorder:const OutlineInputBorder(borderSide:  BorderSide(color: mTextFieldBorder)),
        focusedBorder:  const OutlineInputBorder(borderSide:  BorderSide(color:Color(0xff00004d))),
        border:   const OutlineInputBorder(borderSide:  BorderSide(color:Color(0xff00004d)))
    );
  }
}
