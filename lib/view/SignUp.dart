import 'package:currencyapp/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../confi/NavigationServices.dart';
import '../confi/routes/routesname.dart';
import '../data/response/Status.dart';
import '../widgets/snackbar.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController nameController = TextEditingController();
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
                child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Sign up",
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
                              controller: nameController,
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
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: "Enter your email",
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
                          ),
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
                          if (nameController.text.isEmpty &&
                              emailController.text.isEmpty &&
                              passwordController.text.isEmpty) {
                            showSnackBar(
                                context, "detail missing  unsuccessful",
                                isSuccess: false);
                          } else {
                            final response = await authVM.signUp(
                              emailController.text.trim(),
                              passwordController.text.trim(),
                              nameController.text.trim(),
                            );

                            if (response.status == Status.success) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content:
                                    Text(response.message.toString())),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Error: ${response.message.toString()}")),
                              );
                            }
                          }
                        },
                        child: const Text(
                          'Sign Up',
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
                          NavigatorServices.GoTo(RoutesName.login_route);
                        },
                        child: const Text(
                          'Already have an account? Login',
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
}
