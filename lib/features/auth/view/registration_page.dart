import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scheduler_app_sms/core/widget/custom_button.dart';

import '../../../core/widget/app_bar.dart';
import '../../../core/widget/custom_input.dart';
import '../provider/registration_provider.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var newUserNotifier = ref.read(newUserProvider.notifier);
    return SafeArea(
        child: Scaffold(
      //resizeToAvoidBottomInset: false,
      appBar: customAppbar(
          title: 'REGISTRATION'.toUpperCase(), icon: FontAwesomeIcons.userPlus),
      body: SizedBox(
          width: size.width,
          height: size.height,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/login.png',
                      width: 200,
                      fit: BoxFit.cover,
                      //height: 100,
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    CustomTextFields(
                      prefixIcon: Icons.person,
                      label: 'Full Name',
                      validator: (name) {
                        if (name == null || name.isEmpty) {
                          return 'Name is required';
                        }
                        return null;
                      },
                      onSaved: (name) {
                        newUserNotifier.setName(name!);
                      },
                    ),
                    const SizedBox(
                      height: 22,
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
                        newUserNotifier.setEmail(email!);
                      },
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    //phone
                    CustomTextFields(
                      prefixIcon: Icons.phone,
                      label: 'Phone',
                      validator: (phone) {
                        if (phone == null || phone.isEmpty) {
                          return 'Phone is required';
                        } else if (phone.length < 10) {
                          return 'Phone number must be 10 digits';
                        }
                        return null;
                      },
                      onSaved: (phone) {
                        newUserNotifier.setPhoneNumber(phone!);
                      },
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    CustomTextFields(
                      prefixIcon: Icons.lock,
                      obscureText: true,
                      label: 'Password',
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      onSaved: (password) {
                        newUserNotifier.setPassword(password!);
                      },
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    CustomButton(
                      text: 'Register',
                      radius: 5,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          newUserNotifier.register(context, ref);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 22,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Already have an account?'),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Login'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )),
    ));
  }
}
