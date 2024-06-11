import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transmed/home_page.dart';
import 'snackbar_item.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.title});

  final String title;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isObscureFirst = true;
  bool _isObscureSecond = true;
  final RegExp limitName = RegExp(r'^(?=.*[A-Za-z])[A-Za-z0-9_]+$');
  final RegExp limitEmail = RegExp(
      "^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}\$");
  final String apiUrl = 'https://favqs.com/api/users';
  final TextEditingController loginController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  String result = ''; // To store the result from the API call
  String warning = '';
  String login = '';
  String token = '';
  String email = '';

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
            'email': emailController.text,
            'password': passwordController.text,
            // Add any other data you want to send in the body
          }
        }),
      );
      debugPrint(loginController.text);
      debugPrint(emailController.text);
      debugPrint(passwordController.text);

      final responseData = jsonDecode(response.body);
      debugPrint('Response data: ${response.body}');

      if (responseData['error_code'] == 31) {
        warning = "User session present.";
      } else if (responseData['message'] == "Email has already been taken") {
        warning = "Email has already been taken.";
      } else if (responseData['message'] == 'Username has already been taken') {
        warning = 'Username has already been taken';
      }

      if (response.statusCode == 200) {
        // Successful POST request, handle the response here
        result =
            'User-Token: ${responseData['User-Token']}\nLogin: ${responseData['login']}';
        login = responseData['login'];

        if (login == loginController.text) {
          token = responseData['User-Token'];
          email = emailController.text;

          // Navigator.of(context).restorablePush(_dialogBuilder);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return _dialogBuilder();
            },
          );

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
        } else {
          snack(warning, context);
        }
      } else {
        // If the server returns an error response, throw an exception
        throw Exception(
            "Request to $apiUrl failed with status ${response.statusCode}: ${response.body}");
      }
    } catch (e) {
      if (warning == '') {
        result = 'Error:\n$e';
        debugPrint(result);
        warning = result;
      }
      snack(warning, context);
    }
    warning = '';
  }

  @override
  void dispose() {
    loginController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
                hintText: "Set Your username",
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                labelText: "Email *",
                hintText: "Enter your email",
              ),
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: TextFormField(
              obscureText: _isObscureFirst,
              controller: passwordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(!_isObscureFirst
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscureFirst = !_isObscureFirst;
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
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: TextFormField(
              obscureText: _isObscureSecond,
              controller: confirmpasswordController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(!_isObscureSecond
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscureSecond = !_isObscureSecond;
                    });
                  },
                ),
                labelText: "Confirm Password *",
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
            width: MediaQuery.of(context).size.width / 2.5,
            height: MediaQuery.of(context).size.height / 20,
            child: OutlinedButton(
              onPressed: () {
                if (!limitName.hasMatch(loginController.text)) {
                  warning =
                      "Entering containing only letters, numbers, \nor underscores, with at least one letter.";
                } else if (!limitEmail.hasMatch(emailController.text)) {
                  warning = "Invalid email address.";
                } else if (passwordController.text.isEmpty) {
                  warning = "Password can't be blank.";
                } else if (passwordController.text !=
                    confirmpasswordController.text) {
                  warning = "Two passwords are not the same.";
                } else if (passwordController.text.length < 5) {
                  warning = "Password is too short (minimum is 5 characters)";
                } else if (passwordController.text.length > 100) {
                  warning = "Password is too long (maximize is 100 characters)";
                }
                if (warning != '') {
                  snack(warning, context);
                  warning = '';
                } else {
                  _postData();
                }
              },
              child: const Text(
                "Sign up",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // @pragma('vm:entry-point')
  _dialogBuilder() {
    return AlertDialog(
      title: const Text('Congratulations!'),
      content: const Text(
        'Welcome to TRANSMED\nYour registration was successful.\nPlease log in.',
      ),
      actions: <Widget>[
        TextButton(
          style: TextButton.styleFrom(
            textStyle: Theme.of(context).textTheme.labelLarge,
          ),
          child: const Text('Confirm'),
          onPressed: () {
            // Navigator.of(context).pop();
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
          },
        ),
      ],
    );
  }
}
