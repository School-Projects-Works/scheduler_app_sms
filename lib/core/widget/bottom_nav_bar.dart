import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/core/provider/nav_provider.dart';

import '../../utils/app_colors.dart';

class BottomNavigationBarApp extends ConsumerWidget {
  const BottomNavigationBarApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var index = ref.watch(navigationProvider);
    return BottomNavigationBar(
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 10,
      selectedLabelStyle: const TextStyle(color: CustomColors.blueDark),
      selectedItemColor: CustomColors.blueDark,
      unselectedFontSize: 10,
      items: [
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Image.asset(
              'assets/images/home.png',
              color:
                  (index == 0) ? CustomColors.blueDark : CustomColors.textGrey,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Image.asset(
              'assets/images/task.png',
              color:
                  (index == 1) ? CustomColors.blueDark : CustomColors.textGrey,
            ),
          ),
          label: 'Task',
        ),
        BottomNavigationBarItem(
          icon: Container(
            margin: const EdgeInsets.only(bottom: 5),
            child: Image.asset(
              'assets/images/app.png',
              width: 35,
              height: 35,
              color:
                  (index == 2) ? CustomColors.blueDark : CustomColors.textGrey,
            ),
          ),
          label: 'Appointment',
        ),
      ],
      onTap: (tabIndex) {
        ref.read(navigationProvider.notifier).state = tabIndex;
      },
    );
  }
}
