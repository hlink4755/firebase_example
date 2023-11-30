import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_example/posts/posts_screen.dart';
import 'package:firebase_example/ui/auth/signup_screen.dart';
import 'package:firebase_example/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/base_appbar.dart';
import '../../../widgets/rounded_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool loading = false;
  final _formField = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final ValueNotifier<bool> _isVisibleNotifier = ValueNotifier(true);

  final FirebaseAuth auth = FirebaseAuth.instance;

  void login() {
    setState(() {
      loading = true;
    });
    auth
        .signInWithEmailAndPassword(
            email: _emailController.text, password: _passController.text)
        .then((value) {
      Utils().toastMessage(value.user.toString());
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PostsScreen(),
          ));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
      Utils().toastMessage(error.toString());
      setState(() {
        loading = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppbar(
          automaticallyImplyLeading: false,
          title: const Text('Login'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formField,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Enter email';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                    hintText: 'Email', prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(
                height: 10,
              ),
              ValueListenableBuilder(
                valueListenable: _isVisibleNotifier,
                builder: (context, value, child) {
                  return TextFormField(
                    controller: _passController,
                    keyboardType: TextInputType.text,
                    obscureText: value ? true : false,
                    obscuringCharacter: '*',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                            onTap: () {
                              _isVisibleNotifier.value =
                                  !_isVisibleNotifier.value;
                            },
                            child: value
                                ? const Icon(CupertinoIcons.eye_slash_fill)
                                : const Icon(CupertinoIcons.eye_fill))),
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              RoundButton(
                title: 'Login',
                loading: loading,
                onTap: () {
                  if (_formField.currentState!.validate()) {
                    login();
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ));
                      },
                      child: const Text('Sign up'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
