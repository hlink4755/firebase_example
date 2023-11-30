import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_example/ui/auth/login_screen.dart';
import 'package:firebase_example/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/base_appbar.dart';
import '../../../widgets/rounded_button.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formField = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final ValueNotifier<bool> _isVisibleNotifier = ValueNotifier(true);

  FirebaseAuth auth = FirebaseAuth.instance;

  bool loading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: BaseAppbar(
            automaticallyImplyLeading: true,
            title: const Text('Signup'),
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
                  title: 'Sign up',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    if (_formField.currentState!.validate()) {
                      auth
                          .createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passController.text)
                          .then((value) {
                            setState(() {
                              loading = false;
                            });
                      })
                          .onError((error, stackTrace) {
                        Utils().toastMessage(error.toString());
                        setState(() {
                          loading = false;
                        });
                      });
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account'),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginScreen(),
                              ));
                        },
                        child: const Text('Login'))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
