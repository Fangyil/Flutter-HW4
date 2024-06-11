import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:transmed/home_page.dart';
import 'snackbar_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool _isObscure = true;
  final String apiUrl = 'https://favqs.com/api/session';
  final TextEditingController loginController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String result = ''; // To store the result from the API call
  String warning = '';
  String login = '';
  String token = '';
  String email = '';

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false; // 没有'userData'这一项，返回 false，自动登录失败
    }
    final extractedUserData = json.decode(prefs.getString('userData')!);
    token = extractedUserData['token'].toString();
    login = extractedUserData['userId'].toString();
    email = extractedUserData['email'].toString();

    debugPrint('log in');
    debugPrint('token: $token');
    debugPrint('login: $login');
    debugPrint('email: $email');

    Navigator.of(context).pop();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(
          email: email,
          name: login,
          token: token,
        ),
      ),
    );

    return true; // 数据有效，返回 true，自动登录成功
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _postData() async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Authorization': 'Token token="2c69381664fd2d1176f4cd15e8590490"',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "user": {
            'login': loginController.text,
            'password': passwordController.text,
            // Add any other data you want to send in the body
          }
        }),
      );
      debugPrint(loginController.text);
      debugPrint(passwordController.text);

      final responseData = jsonDecode(response.body);
      debugPrint('Response data: ${response.body}');

      if (responseData['error_code'] == 21) {
        warning = "Invalid login or password.";
      } else if (responseData['error_code'] == 22) {
        warning = "Login is not active. Contact support@favqs.com.";
      } else if (responseData['error_code'] == 23) {
        warning = "User login or password is missing.";
      }

      if (response.statusCode == 200) {
        // Successful POST request, handle the response here
        result =
            'User-Token: ${responseData['User-Token']}\nLogin: ${responseData['login']}\nEmail: ${responseData['email']}';
        login = responseData['login'];
        debugPrint(login);
        if (login == loginController.text) {
          token = responseData['User-Token'];
          email = responseData['email'];

          Navigator.of(context).pop();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                email: email,
                name: login,
                token: token,
              ),
            ),
          );
        } else {
          snack(warning, context);
          debugPrint("here");
        }
      } else {
        // If the server returns an error response, throw an exception
        throw Exception(
            "Request to $apiUrl failed with status ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      setState(() {
        if (warning == '') {
          result = 'Error:\n$e';
          warning = result;
        }
        snack(warning, context);
        warning = '';
      });
    }

    if (token != '' && login != '' && email != '') {
      // 持久保存数据
      // =================================================
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'userId': login,
        'email': email,
      });

      debugPrint('sign up');
      debugPrint('token: $token');
      debugPrint('login: $login');
      debugPrint('email: $email');

      prefs.setString('userData', userData);
      // =================================================
    }
  }

  @override
  void initState() {
    tryAutoLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: TextFormField(
              controller: loginController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                labelText: "Name *",
                hintText: "Enter Your username",
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: TextFormField(
              obscureText: _isObscure,
              controller: passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                      !_isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                ),
                labelText: "Password *",
                hintText: "Only allow num 0-9",
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
              ],
            ),
          ),
          const SizedBox(
            height: 52.0,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 20,
            child: OutlinedButton(
              onPressed: () {
                if (passwordController.text.isEmpty) {
                  warning = "Password can't be blank.";
                } else if (passwordController.text.length < 4) {
                  warning = "Password is too short (minimum is 5 characters)";
                } else if (passwordController.text.length > 100) {
                  warning = "Password is too long (maximize is 100 characters)";
                }
                if (warning != '') {
                  snack(warning, context);
                } else {
                  _postData();
                }
              },
              child: const Text(
                "Login",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
