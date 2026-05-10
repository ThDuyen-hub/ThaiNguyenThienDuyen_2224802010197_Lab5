import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'register_page.dart';
import 'todo_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() =>
      _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final api = ApiService();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          Colors.grey.shade100,

      body: SafeArea(

        child: Center(

          child: SingleChildScrollView(

            child: Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 30,
              ),

              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center,

                children: [

                  const Icon(
                    Icons.task_alt,
                    size: 90,
                    color: Colors.blue,
                  ),

                  const SizedBox(
                      height: 10),

                  const Text(
                    "Todo App",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 8),

                  Text(
                    "Đăng nhập để tiếp tục",
                    style: TextStyle(
                      color:
                          Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(
                      height: 40),

                  TextField(
                    controller:
                        emailController,

                    decoration:
                        InputDecoration(
                      labelText:
                          "Email",

                      prefixIcon:
                          const Icon(
                        Icons.email,
                      ),

                      filled: true,
                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 20),

                  TextField(
                    controller:
                        passwordController,

                    obscureText: true,

                    decoration:
                        InputDecoration(
                      labelText:
                          "Password",

                      prefixIcon:
                          const Icon(
                        Icons.lock,
                      ),

                      filled: true,
                      fillColor:
                          Colors.white,

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                                15),
                        borderSide:
                            BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(
                      height: 30),

                  SizedBox(
                    width:
                        double.infinity,
                    height: 55,

                    child:
                        ElevatedButton(

                      style:
                          ElevatedButton.styleFrom(
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  15),
                        ),
                      ),

                      onPressed:
                          isLoading
                              ? null
                              : () async {

                          setState(() {
                            isLoading =
                                true;
                          });

                          bool success =
                              await api.login(
                            emailController.text,
                            passwordController.text,
                          );

                          setState(() {
                            isLoading =
                                false;
                          });

                          if (success) {

                            Navigator.pushReplacement(
                              context,

                              MaterialPageRoute(
                                builder:
                                    (_) =>
                                        const TodoPage(),
                              ),
                            );
                          } else {

                            ScaffoldMessenger.of(
                                    context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Sai email hoặc mật khẩu",
                                ),
                              ),
                            );
                          }
                        },

                      child: isLoading
                          ? const CircularProgressIndicator(
                              color:
                                  Colors.white,
                            )
                          : const Text(
                              "Login",
                              style:
                                  TextStyle(
                                fontSize:
                                    18,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(
                      height: 15),

                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,

                    children: [

                      const Text(
                        "Chưa có tài khoản? ",
                      ),

                      GestureDetector(

                        onTap: () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      const RegisterPage(),
                            ),
                          );
                        },

                        child: const Text(
                          "Đăng ký",
                          style: TextStyle(
                            color:
                                Colors.blue,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}