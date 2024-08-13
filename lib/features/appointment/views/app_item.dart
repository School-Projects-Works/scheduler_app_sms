import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scheduler_app_sms/features/appointment/provider/app_provider.dart';
import 'package:scheduler_app_sms/features/task/data/appointment_model.dart';

import '../../../core/navigations.dart';
import '../../../core/widget/blinking_widget.dart';
import '../../../core/widget/custom_dialog.dart';
import '../../auth/provider/user_provider.dart';
import '../../task/services/functions.dart';
import '../provider/new_app_provider.dart';
import 'edit_appointment.dart';

class AppItem extends ConsumerStatefulWidget {
  const AppItem({super.key, required this.app, this.showDate = true});
  final AppointmentModel app;
  final bool showDate;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppItemState();
}

class _AppItemState extends ConsumerState<AppItem> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.
      startActionPane: user.id == widget.app.recieverId
          ? ActionPane(
              // A motion is a widget used to control how the pane animates.
              motion: const ScrollMotion(),

              // A pane can dismiss the Slidable.

              // All actions are defined in the children parameter.
              children: [
                // A SlidableAction can have an icon and/or a label.
                if (widget.app.status == 'pending')
                  SlidableAction(
                    onPressed: (context) {
                      CustomDialogs.showDialog(
                          message:
                              'Are you sure you want to accept appointment?',
                          type: DialogType.warning,
                          secondBtnText: 'Accept',
                          onConfirm: () {
                            ref
                                .read(appointmentFilterProvider.notifier)
                                .updateTask(
                                    widget.app.copyWith(status: 'accepted'));
                          });
                    },
                    backgroundColor: const Color.fromARGB(255, 18, 232, 43),
                    foregroundColor: Colors.white,
                    icon: Icons.check,
                    label: 'Done',
                  ),
                if ((widget.app.status == 'pending' ||
                    widget.app.status == 'accepted'))
                  SlidableAction(
                    onPressed: (context) {
                      CustomDialogs.showDialog(
                          message:
                              'Are you sure you want to decline appointment?',
                          type: DialogType.warning,
                          secondBtnText: 'Decline',
                          onConfirm: () {
                            ref
                                .read(appointmentFilterProvider.notifier)
                                .updateTask(
                                    widget.app.copyWith(status: 'declined'));
                          });
                    },
                    backgroundColor: const Color.fromARGB(255, 233, 45, 45),
                    foregroundColor: Colors.white,
                    icon: Icons.play_arrow,
                    label: 'Ongoing',
                  ),
              ],
            )
          : null,

      // The end action pane is the one at the right or the bottom side.
      endActionPane: widget.app.senderId == user.id
          ? ActionPane(
              motion: const ScrollMotion(),
              children: [
                if (widget.app.status != 'completed')
                  SlidableAction(
                    // An action can be bigger than the others.
                    flex: 1,
                    onPressed: (context) {
                      ref.read(editAppointmentProvider.notifier).setAppointment(widget.app);
                      navigateTransparentRoute(context, const EditAppointment());
                    },
                    backgroundColor: const Color.fromARGB(255, 54, 138, 217),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                SlidableAction(
                  onPressed: (context) {
                    CustomDialogs.showDialog(
                        message: 'Are you sure you want to delete this appointment?',
                        type: DialogType.warning,
                        secondBtnText: 'Delete',
                        onConfirm: () {
                          ref
                              .read(appointmentFilterProvider.notifier)
                              .deleteTask(widget.app.id);
                        });
                  },
                  backgroundColor: const Color.fromARGB(255, 207, 3, 13),
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            )
          : null,

      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // borderRadius: BorderRadius.circular(10),
          border: Border(
            left: BorderSide(
              width: 5,
              color: widget.app.status == 'pending'
                  ? Colors.black
                  : widget.app.status == 'completed'
                      ? Colors.green
                      : widget.app.status == 'declined'
                          ? Colors.red
                          : widget.app.status == 'accepted'
                              ? Colors.blue
                              : Colors.red,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 4,
              offset: const Offset(3, 5), // changes position of shadow
            ),
          ],
        ),
        margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Appointment with:',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  widget.app.recieverName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      height: 2,
                      decoration: widget.app.status == 'completed' ||
                              widget.app.status == 'declined'
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      fontSize: 16,
                      color: widget.app.status == 'completed'
                          ? Colors.green
                          : widget.app.status == 'declined'
                              ? Colors.red
                              : Colors.black,
                      fontWeight: FontWeight.w800),
                ),
              ],
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(formatTime(widget.app.time),
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey)),
                    if (widget.showDate)
                      Text(formatDate(widget.app.date),
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey)),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.app.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            decoration: widget.app.status == 'completed'
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87),
                      ),
                      Text(
                        widget.app.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey),
                      ),
                      //task type
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                            color: widget.app.type.toLowerCase() == 'work'
                                ? Colors.green
                                : widget.app.type.toLowerCase() == 'personal'
                                    ? Colors.blue
                                    : widget.app.type.toLowerCase() == 'study'
                                        ? const Color.fromRGBO(255, 152, 0, 1)
                                        : widget.app.type.toLowerCase() ==
                                                'meeting'
                                            ? Colors.purple
                                            : Colors.red,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          widget.app.type,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
                //const Spacer(),
                if (widget.app.status == 'accepted')
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(
                      FontAwesomeIcons.personDigging,
                      size: 18,
                      color: Colors.blue,
                    ),
                  ),
                if (widget.app.status == 'completed')
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(
                      FontAwesomeIcons.check,
                      size: 18,
                      color: Colors.green,
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: isTimeDue(widget.app.time, widget.app.date)
                      ? BlinkWidget(children: [
                          Icon(
                            widget.app.notifierMe
                                ? Icons.notifications
                                : Icons.notifications_off,
                            size: 18,
                            color: widget.app.notifierMe
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ])
                      : Icon(
                          widget.app.notifierMe
                              ? Icons.notifications
                              : Icons.notifications_off,
                          size: 18,
                          color: widget.app.notifierMe
                              ? Colors.green
                              : Colors.grey,
                        ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
