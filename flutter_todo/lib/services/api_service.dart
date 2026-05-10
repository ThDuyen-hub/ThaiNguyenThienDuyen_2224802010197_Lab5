import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {

  static const String baseUrl =
      "http://10.0.2.2:5006/api";

  // LOGIN
  Future<bool> login(
      String email,
      String password) async {

    final response =
        await http.post(
      Uri.parse(
          "$baseUrl/auth/login"),

      headers: {
        "Content-Type":
            "application/json"
      },

      body: jsonEncode({
        "email": email,
        "password": password
      }),
    );

    if (response.statusCode ==
        200) {

      final data =
          jsonDecode(
              response.body);

      SharedPreferences prefs =
          await SharedPreferences
              .getInstance();

      await prefs.setString(
        "token",
        data["token"],
      );

      return true;
    }

    return false;
  }

  // GET TOKEN
  Future<String> getToken()
  async {

    SharedPreferences prefs =
        await SharedPreferences
            .getInstance();

    return prefs.getString(
            "token") ??
        "";
  }

  // GET TODOS
  Future<List> getTodos()
  async {

    String token =
        await getToken();

    final response =
        await http.get(
      Uri.parse(
          "$baseUrl/todo"),

      headers: {
        "Authorization":
            "Bearer $token"
      },
    );

    return jsonDecode(
        response.body);
  }

  // ADD TODO
  Future<void> addTodo(
      String title)
  async {

    String token =
        await getToken();

    await http.post(
      Uri.parse(
          "$baseUrl/todo"),

      headers: {
        "Authorization":
            "Bearer $token",
        "Content-Type":
            "application/json"
      },

      body: jsonEncode({
        "title": title,
        "isCompleted":
            false
      }),
    );
  }

  // UPDATE TODO
  Future<void> updateTodo(
    int id,
    String title,
    bool isCompleted,
  ) async {

    String token =
        await getToken();

    await http.put(
      Uri.parse(
          "$baseUrl/todo/$id"),

      headers: {
        "Authorization":
            "Bearer $token",
        "Content-Type":
            "application/json"
      },

      body: jsonEncode({
        "title": title,
        "isCompleted":
            isCompleted
      }),
    );
  }

  // DELETE TODO
  Future<void> deleteTodo(
      int id)
  async {

    String token =
        await getToken();

    await http.delete(
      Uri.parse(
          "$baseUrl/todo/$id"),

      headers: {
        "Authorization":
            "Bearer $token"
      },
    );
  }

  // LOGOUT
  Future<void> logout()
  async {

    SharedPreferences prefs =
        await SharedPreferences
            .getInstance();

    await prefs.remove(
        "token");
  }
}