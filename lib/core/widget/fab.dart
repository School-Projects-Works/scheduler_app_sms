import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/core/navigations.dart';
import 'package:scheduler_app_sms/core/provider/nav_provider.dart';
import 'package:scheduler_app_sms/features/appointment/views/new_appointment_page.dart';
import '../../features/home/views/new_task_page.dart';
import '../../utils/app_colors.dart';

FloatingActionButton customFab(
    context, WidgetRef ref, GlobalKey<FormState> form) {
  var pageIndex = ref.watch(navigationProvider);
  return FloatingActionButton(
    onPressed: () {
      if (pageIndex == 2) {
        navigateTransparentRoute(context, const NewAppointmentPage());
      } else {
        mainBottomSheet(context, ref, form);
      }
    },
    elevation: 5,
    backgroundColor: Colors.transparent,
    child: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            CustomColors.greenDark,
            CustomColors.greenLight,
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.greenDark,
            blurRadius: 10.0,
            spreadRadius: 5.0,
            offset: Offset(0.0, 0.0),
          ),
        ],
      ),
      child: Image.asset('assets/images/fab-add.png'),
    ),
  );
}
