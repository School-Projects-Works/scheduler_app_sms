import 'package:flutter/material.dart';
import 'package:scheduler_app_sms/features/auth/data/user_model.dart';
import 'package:scheduler_app_sms/features/task/data/task_model.dart';
import 'package:scheduler_app_sms/features/task/services/functions.dart';
import 'package:scheduler_app_sms/utils/text_styles.dart';
import '../../utils/app_colors.dart';
import '../appBar/gradient_app_bar.dart';

Widget fullAppbar(BuildContext context, UserModel? user, int todayTask,TaskModel ?due) {
  return NewGradientAppBar(
    flexibleSpace: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomPaint(
          painter: CircleOne(),
        ),
        CustomPaint(
          painter: CircleTwo(),
        ),
      ],
    ),
    title: Container(
      margin: const EdgeInsets.only(top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Hello ${user!.name}!',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          Text(
            'Today you have $todayTask tasks',
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      InkWell(
        onTap: () {
          // Navigator.pushNamed(context, '/profile');
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: CustomColors.headerGreyLight,
          ),
          margin: const EdgeInsets.fromLTRB(0, 20, 20, 0),
          child: user.photoUrl != null && user.photoUrl!.isNotEmpty
              ? ClipOval(child: Image.network(user.photoUrl!))
              : const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
        ),
      ),
    ],
    elevation: 0,
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [CustomColors.headerBlueDark, CustomColors.headerBlueLight],
    ),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(10),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
        decoration: BoxDecoration(
          color: CustomColors.headerGreyLight,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
             Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Today\'s due Task',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
                due!=null?due!.title:'No task due today' ,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w300),
                ),
                const SizedBox(
                  height: 3,
                ),
                Text(
             due!=null?     formatTime(due.time):'',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const Spacer(),
            Image.asset(
              'assets/images/bell-left.png',
              scale: 1.3,
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 80),
              child: const Icon(
                Icons.clear,
                color: Colors.white,
                size: 18.0,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget emptyAppbar() {
  return NewGradientAppBar(
    flexibleSpace: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CustomPaint(
          painter: CircleOne(),
        ),
        CustomPaint(
          painter: CircleTwo(),
        ),
      ],
    ),
    title: Container(
      margin: const EdgeInsets.only(top: 20),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Hello Brenda!',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          Text(
            'Today you have no tasks',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    ),
    actions: <Widget>[
      Container(
        margin: const EdgeInsets.fromLTRB(0, 20, 20, 0),
        child: Image.asset('assets/images/photo.png'),
      ),
    ],
    elevation: 0,
    gradient: const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [CustomColors.headerBlueDark, CustomColors.headerBlueLight],
    ),
  );
}

PreferredSizeWidget customAppbar({required String title, IconData? icon}) {
  var style = CustomTextStyles();
  return PreferredSize(
    preferredSize: const Size.fromHeight(100),
    child: NewGradientAppBar(
      flexibleSpace: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomPaint(
            painter: CircleOne(),
          ),
          CustomPaint(
            painter: CircleTwo(),
          ),
        ],
      ),
      title: Container(
        // margin: const EdgeInsets.only(top: 20),
        child: Text(
          title,
          style: style.titleStyle(
              fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      actions: <Widget>[
        if (icon != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(icon, color: Colors.white),
          ),
      ],
      elevation: 0,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [CustomColors.headerBlueDark, CustomColors.headerBlueLight],
      ),
    ),
  );
}

class CircleOne extends CustomPainter {
  late Paint _paint;

  CircleOne() {
    _paint = Paint()
      ..color = CustomColors.headerCircle
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(const Offset(28.0, 0.0), 99.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CircleTwo extends CustomPainter {
  late Paint _paint;

  CircleTwo() {
    _paint = Paint()
      ..color = CustomColors.headerCircle
      ..strokeWidth = 10.0
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(const Offset(-30, 20), 50.0, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
