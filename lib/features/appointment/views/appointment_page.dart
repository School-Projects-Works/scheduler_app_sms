import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/core/widget/custom_input.dart';
import 'package:scheduler_app_sms/features/appointment/provider/app_provider.dart';
import 'package:scheduler_app_sms/features/appointment/views/app_item.dart';
import 'package:scheduler_app_sms/features/auth/provider/user_provider.dart';

import '../../../utils/app_colors.dart';

class AppointmentPage extends ConsumerStatefulWidget {
  const AppointmentPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AppointmentPageState();
}

class _AppointmentPageState extends ConsumerState<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    var appStream = ref.watch(appointmentStream);
    var user = ref.watch(userProvider);
    return appStream.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
                child: Text(
              error.toString(),
              style: const TextStyle(color: Colors.black),
            )),
        data: (data) {
          var app = ref.watch(appointmentFilterProvider);
          Timer.periodic(const Duration(seconds: 15),
              (Timer t) => sendMessageOnApp(data, user));
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFields(
                    hintText: 'search appointment',
                    onChanged: (value) {
                      ref
                          .read(appointmentFilterProvider.notifier)
                          .filter(value);
                    },
                    suffixIcon: const Icon(Icons.search),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                      left: 20,
                      bottom: 15,
                    ),
                    child: const Text(
                      'Pending Appointments',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textSubHeader),
                    ),
                  ),
                  if (app.pending.isEmpty)
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 15),
                      child: const Text(
                        'No pending appointment',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: CustomColors.textSubHeader),
                      ),
                    ),
                  if (app.pending.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: app.pending.length,
                      itemBuilder: (context, index) {
                        var ap = app.pending[index];
                        return AppItem(app: ap);
                      },
                    ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                      left: 20,
                      bottom: 15,
                    ),
                    child: const Text(
                      'Accepted Appointments',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textSubHeader),
                    ),
                  ),
                  if (app.accepted.isEmpty)
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 15),
                      child: const Text(
                        'No accepted appointment',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: CustomColors.textSubHeader),
                      ),
                    ),
                  if (app.accepted.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: app.accepted.length,
                      itemBuilder: (context, index) {
                        var ap = app.accepted[index];
                        return AppItem(app: ap);
                      },
                    ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                      left: 20,
                      bottom: 15,
                    ),
                    child: const Text(
                      'Declined Appointments',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: CustomColors.textSubHeader),
                    ),
                  ),
                  if (app.declined.isEmpty)
                    Container(
                      margin: const EdgeInsets.only(left: 20, bottom: 15),
                      child: const Text(
                        'No declined appointment',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            color: CustomColors.textSubHeader),
                      ),
                    ),
                  if (app.declined.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: app.declined.length,
                      itemBuilder: (context, index) {
                        var ap = app.declined[index];
                        return AppItem(app: ap);
                      },
                    ),
                ],
              ),
            ),
          );
        });
  }
}
