import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState();
}

class _RegisterPageState
    extends State<RegisterPage> {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  final String baseUrl =
      'http://10.0.2.2:5006/api/auth';

  bool isLoading = false;

  Future<void> register() async {

    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text("Vui lòng nhập đầy đủ thông tin"),
        ),
      );

      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('$baseUrl/register'),

      headers: {
        'Content-Type':
            'application/json',
      },

      body: jsonEncode({
        'name':
            nameController.text,
        'email':
            emailController.text,
        'password':
            passwordController.text,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content:
              Text('Đăng ký thành công'),
        ),
      );

      Navigator.pop(context);
    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text(response.body),
        ),
      );
    }
  }

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
                    Icons.person_add_alt_1,
                    size: 90,
                    color: Colors.blue,
                  ),

                  const SizedBox(
                      height: 10),

                  const Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                      height: 8),

                  Text(
                    "Đăng ký tài khoản mới",
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
                        nameController,

                    decoration:
                        InputDecoration(
                      labelText:
                          "Name",

                      prefixIcon:
                          const Icon(
                        Icons.person,
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

                    obscureText:
                        true,

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
                              : register,

                      child: isLoading
                          ? const CircularProgressIndicator(
                              color:
                                  Colors.white,
                            )
                          : const Text(
                              "Register",
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
                        "Đã có tài khoản? ",
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pop(
                              context);
                        },

                        child: const Text(
                          "Đăng nhập",
                          style: TextStyle(
                            color:
                                Colors.blue,
                            fontWeight:
                                FontWeight.bold,
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