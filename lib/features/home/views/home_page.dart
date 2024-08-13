import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scheduler_app_sms/core/provider/nav_provider.dart';
import 'package:scheduler_app_sms/features/appointment/views/appointment_page.dart';
import 'package:scheduler_app_sms/features/auth/provider/user_provider.dart';
import 'package:scheduler_app_sms/features/home/views/task_list_page.dart';
import 'package:scheduler_app_sms/features/task/provider/task_provider.dart';
import 'package:scheduler_app_sms/features/task/views/task_page.dart';
import '../../../core/widget/app_bar.dart';
import '../../../core/widget/bottom_nav_bar.dart';
import '../../../core/widget/fab.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final GlobalKey<FormState> form = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var index = ref.watch(navigationProvider);
    var taskStream = ref.watch(taskStreamProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(210.0),
          child: fullAppbar(
              context,
              ref.watch(userProvider),
              ref.watch(taskFilterProvider).todaysTask.length,
              ref.watch(taskFilterProvider).dueTask)),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: taskStream.when(
            data: (data) => () {
                  if (index == 0) {
                    return const TaskListPage();
                  } else if (index == 1) {
                    return const TaskPage();
                  } else {
                  
                    return const AppointmentPage();
                  }
                }(),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
                  child: Text('Error: $error'),
                )),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: customFab(context, ref, form),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(top: 30),
        child: BottomNavigationBarApp(),
      ),
    );
  }
}

// ListView(
//           scrollDirection: Axis.vertical,
//           children: <Widget>[
//             Container(
//               margin: const EdgeInsets.only(top: 15, left: 20, bottom: 15),
//               child: const Text(
//                 'Today',
//                 style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: CustomColors.textSubHeader),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
//               padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   stops: [0.015, 0.015],
//                   colors: [CustomColors.yellowIcon, Colors.white],
//                 ),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: CustomColors.greyBorder,
//                     blurRadius: 10.0,
//                     spreadRadius: 5.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Image.asset('assets/images/checked.png'),
//                   const Text(
//                     '07.00 AM',
//                     style: TextStyle(color: CustomColors.textGrey),
//                   ),
//                   const SizedBox(
//                     width: 180,
//                     child: Text(
//                       'Go jogging with Christin',
//                       style: TextStyle(
//                           color: CustomColors.textGrey,
//                           //fontWeight: FontWeight.w600,
//                           decoration: TextDecoration.lineThrough),
//                     ),
//                   ),
//                   Image.asset('assets/images/bell-small.png'),
//                 ],
//               ),
//             ),
//             Slidable(
              
//               startActionPane: ActionPane(
//                 motion: const ScrollMotion(),
//                 children:[  Container(
//                     padding: const EdgeInsets.only(bottom: 10),
//                     child: Container(
//                       height: 35,
//                       width: 35,
//                       decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(50),
//                           color: CustomColors.trashRedBackground),
//                       child: Image.asset('assets/images/trash.png'),
//                     ),
//                   ),
//                 ]
//                 ),
          
              
//               child: Container(
//                 margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
//                 padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
//                 decoration: const BoxDecoration(
//                   gradient: LinearGradient(
//                     stops: [0.015, 0.015],
//                     colors: [CustomColors.greenIcon, Colors.white],
//                   ),
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(5.0),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: CustomColors.greyBorder,
//                       blurRadius: 10.0,
//                       spreadRadius: 5.0,
//                       offset: Offset(0.0, 0.0),
//                     ),
//                   ],
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: <Widget>[
//                     Image.asset('assets/images/checked-empty.png'),
//                     const Text(
//                       '08.00 AM',
//                       style: TextStyle(color: CustomColors.textGrey),
//                     ),
//                     const SizedBox(
//                       width: 180,
//                       child: Text(
//                         'Send project file',
//                         style: TextStyle(
//                             color: CustomColors.textHeader,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                     Image.asset('assets/images/bell-small.png'),
//                   ],
//                 ),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
//               padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   stops: [0.015, 0.015],
//                   colors: [CustomColors.purpleIcon, Colors.white],
//                 ),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: CustomColors.greyBorder,
//                     blurRadius: 10.0,
//                     spreadRadius: 5.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Image.asset('assets/images/checked-empty.png'),
//                   const Text(
//                     '10.00 AM',
//                     style: TextStyle(color: CustomColors.textGrey),
//                   ),
//                   const SizedBox(
//                     width: 180,
//                     child: Text(
//                       'Meeting with client',
//                       style: TextStyle(
//                           color: CustomColors.textHeader,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Image.asset('assets/images/bell-small-yellow.png'),
//                 ],
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
//               padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   stops: [0.015, 0.015],
//                   colors: [CustomColors.greenIcon, Colors.white],
//                 ),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: CustomColors.greyBorder,
//                     blurRadius: 10.0,
//                     spreadRadius: 5.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Image.asset('assets/images/checked-empty.png'),
//                   const Text(
//                     '13.00 PM',
//                     style: TextStyle(color: CustomColors.textGrey),
//                   ),
//                   const SizedBox(
//                     width: 180,
//                     child: Text(
//                       'Email client',
//                       style: TextStyle(
//                           color: CustomColors.textHeader,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Image.asset('assets/images/bell-small.png'),
//                 ],
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.only(left: 20, bottom: 15),
//               child: const Text(
//                 'Tomorrow',
//                 style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: CustomColors.textSubHeader),
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
//               padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   stops: [0.015, 0.015],
//                   colors: [CustomColors.yellowIcon, Colors.white],
//                 ),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: CustomColors.greyBorder,
//                     blurRadius: 10.0,
//                     spreadRadius: 5.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Image.asset('assets/images/checked-empty.png'),
//                   const Text(
//                     '07.00 AM',
//                     style: TextStyle(color: CustomColors.textGrey),
//                   ),
//                   const SizedBox(
//                     width: 180,
//                     child: Text(
//                       'Morning yoga',
//                       style: TextStyle(
//                           color: CustomColors.textHeader,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Image.asset('assets/images/bell-small.png'),
//                 ],
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
//               padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   stops: [0.015, 0.015],
//                   colors: [CustomColors.greenIcon, Colors.white],
//                 ),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: CustomColors.greyBorder,
//                     blurRadius: 10.0,
//                     spreadRadius: 5.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Image.asset('assets/images/checked-empty.png'),
//                   const Text(
//                     '08.00 AM',
//                     style: TextStyle(color: CustomColors.textGrey),
//                   ),
//                   const SizedBox(
//                     width: 180,
//                     child: Text(
//                       'Sending project file',
//                       style: TextStyle(
//                           color: CustomColors.textHeader,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Image.asset('assets/images/bell-small.png'),
//                 ],
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
//               padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   stops: [0.015, 0.015],
//                   colors: [CustomColors.purpleIcon, Colors.white],
//                 ),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: CustomColors.greyBorder,
//                     blurRadius: 10.0,
//                     spreadRadius: 5.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Image.asset('assets/images/checked-empty.png'),
//                   const Text(
//                     '10.00 AM',
//                     style: TextStyle(color: CustomColors.textGrey),
//                   ),
//                   const SizedBox(
//                     width: 180,
//                     child: Text(
//                       'Meeting with client',
//                       style: TextStyle(
//                           color: CustomColors.textHeader,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Image.asset('assets/images/bell-small-yellow.png'),
//                 ],
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
//               padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   stops: [0.015, 0.015],
//                   colors: [CustomColors.greenIcon, Colors.white],
//                 ),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: CustomColors.greyBorder,
//                     blurRadius: 10.0,
//                     spreadRadius: 5.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Image.asset('assets/images/checked-empty.png'),
//                   const Text(
//                     '13.00 PM',
//                     style: TextStyle(color: CustomColors.textGrey),
//                   ),
//                   const SizedBox(
//                     width: 180,
//                     child: Text(
//                       'Email client',
//                       style: TextStyle(
//                           color: CustomColors.textHeader,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Image.asset('assets/images/bell-small.png'),
//                 ],
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
//               padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   stops: [0.015, 0.015],
//                   colors: [CustomColors.purpleIcon, Colors.white],
//                 ),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: CustomColors.greyBorder,
//                     blurRadius: 10.0,
//                     spreadRadius: 5.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Image.asset('assets/images/checked-empty.png'),
//                   const Text(
//                     '13.00 PM',
//                     style: TextStyle(color: CustomColors.textGrey),
//                   ),
//                   const SizedBox(
//                     width: 180,
//                     child: Text(
//                       'Meeting with client',
//                       style: TextStyle(
//                           color: CustomColors.textHeader,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Image.asset('assets/images/bell-small-yellow.png'),
//                 ],
//               ),
//             ),
//             Container(
//               margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
//               padding: const EdgeInsets.fromLTRB(5, 13, 5, 13),
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   stops: [0.015, 0.015],
//                   colors: [CustomColors.greenIcon, Colors.white],
//                 ),
//                 borderRadius: BorderRadius.all(
//                   Radius.circular(5.0),
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: CustomColors.greyBorder,
//                     blurRadius: 10.0,
//                     spreadRadius: 5.0,
//                     offset: Offset(0.0, 0.0),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: <Widget>[
//                   Image.asset('assets/images/checked-empty.png'),
//                   const Text(
//                     '13.00 PM',
//                     style: TextStyle(color: CustomColors.textGrey),
//                   ),
//                   const SizedBox(
//                     width: 180,
//                     child: Text(
//                       'Email client',
//                       style: TextStyle(
//                           color: CustomColors.textHeader,
//                           fontWeight: FontWeight.w600),
//                     ),
//                   ),
//                   Image.asset('assets/images/bell-small.png'),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 15)
//           ],
//         ),
      
