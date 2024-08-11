import 'package:flutter/material.dart';
import 'package:scheduler_app_sms/core/widget/bottom_sheet.dart';
import '../../utils/app_colors.dart';

FloatingActionButton customFab(context) {
  Modal modal = Modal();

  return FloatingActionButton(
    onPressed: () {
      modal.mainBottomSheet(context);
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
            CustomColors.purpleLight,
            CustomColors.purpleDark,
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(50.0),
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColors.purpleShadow,
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
