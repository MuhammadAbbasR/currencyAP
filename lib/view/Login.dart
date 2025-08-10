import 'package:currencyapp/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../confi/NavigationServices.dart';
import '../confi/routes/routesname.dart';
import '../viewmodel/auth_viewmodel.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authVM = Provider.of<AuthViewModel>(context);
    return Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  colors: [Colors.black, Colors.black, Colors.black])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Text("Login",
                      style: TextStyle(color: Colors.white, fontSize: 40)),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Welcome",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ]),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20),
                      )),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(children: [
                      SizedBox(
                        height: 40,
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1), // Light shadow
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                            child: TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Enter your name",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                            child: TextField(
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                hintText: "Enter your password",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          )
                        ]),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      authVM.isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () async {
                          if (emailController.text.isEmpty &&
                              passwordController.text.isEmpty) {
                            showSnackBar(
                                context, "detail missing  unsuccessful",
                                isSuccess: false);
                          } else {
                            try {
                              await authVM.signIn(emailController.text,
                                  passwordController.text);
                              NavigatorServices.GoTo(RoutesName.home_route);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }

                            //   bool success =
                            //       await SharedPrefencesService.boolsetSignup(user);

                            //   if (success) {
                            //     showSnackBar(context, "Sign up successful");
                            //   } else {
                            //     showSnackBar(context, "Sign up unsuccessful",
                            //         isSuccess: false);
                          }
                          // }
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          NavigatorServices.GoTo(RoutesName.forgetpass);
                          NavigatorServices.GoTo(RoutesName.signup_route);
                        },
                        child: const Text(
                          'Forget Password ?',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          NavigatorServices.GoTo(RoutesName.signup_route);
                        },
                        child: const Text(
                          'Dont  have an account? Sign up',
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
