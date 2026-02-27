import 'dart:async';
import 'dart:math';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import '../../../services/notification_service.dart';
import '../models/task.dart';
class SchedulingService {
  Future<void> listen(Task scheduledTask, DateTime next) async {
    await AndroidAlarmManager.oneShotAt(
      next,
      int.tryParse(scheduledTask.id) ?? 0,
      ()=>{},
      wakeup: true,
      exact: true,
      rescheduleOnReboot: true,
    );
    await NotificationService.instance.schedule(
      id: Random().nextInt(1000000) + (int.tryParse(scheduledTask.id) ?? 0),
      title: scheduledTask.title,
      body: scheduledTask.description,
      dateTime: next,
    );
  }
}
