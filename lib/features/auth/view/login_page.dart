import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scheduler_app_sms/core/widget/custom_input.dart';
import 'package:scheduler_app_sms/features/auth/provider/login_provider.dart';

import '../../../core/navigations.dart';
import '../../../core/widget/app_bar.dart';
import '../../../core/widget/custom_button.dart';
import 'registration_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool obSecure = true;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var loginNotifier = ref.read(loginModelProvider.notifier);
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: customAppbar(
            title: 'Login'.toUpperCase(),
            icon: FontAwesomeIcons.rightToBracket),
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/images/login.png',
                      width: 200,
                      fit: BoxFit.cover,
                      //height: 100,
                    ),
                    CustomTextFields(
                      prefixIcon: Icons.email,
                      label: 'Email',
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                      onSaved: (email) {
                        loginNotifier.setEmail(email!);
                      },
                    ),
                    const SizedBox(height: 22),
                    CustomTextFields(
                      prefixIcon: Icons.lock,
                      obscureText: obSecure,
                      label: 'Password',
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      suffixIcon: IconButton(
                        icon: Icon(obSecure
                            ? FontAwesomeIcons.eye
                            : FontAwesomeIcons.eyeSlash),
                        onPressed: () {
                          setState(() {
                            obSecure = !obSecure;
                          });
                        },
                      ),
                      onSaved: (password) {
                        loginNotifier.setPassword(password!);
                      },
                    ),
                    const SizedBox(height: 22),
                    CustomButton(
                      text: 'Login',
                      radius: 5,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          loginNotifier.login(ref, context);
                        }
                      },
                    ),
                    const SizedBox(height: 22),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don\'t have an account?'),
                        TextButton(
                          onPressed: () {
                            navigateAndBack(context, const RegisterPage());
                          },
                          child: const Text('Register'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
