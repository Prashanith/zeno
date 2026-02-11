import 'dart:async';
import 'dart:math';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import '../../../services/android_alarm_service.dart';
import '../../../services/notification_service.dart';
import '../../../utils/cron_converter.dart';
import '../models/task.dart';
import 'schedule_task_service.dart';

class SchedulingService {
  Future<void> scheduleCron(int id) async {
    final scheduledTask = await ScheduledTaskService.getTaskById(id.toString());
    if (scheduledTask != null) {
      var next = DateTime.now();
      if (scheduledTask.scheduledAt == null) {
        next =
            scheduledTask.scheduledAt ??
            CronUtils.computeNextRun(scheduledTask.cron) ??
            DateTime.now();
        scheduledTask.scheduledAt = next;
        await ScheduledTaskService.updateTaskById(scheduledTask);
      } else {
        next = scheduledTask.scheduledAt ?? DateTime.now();
      }
      next = next.toUtc().toLocal();
      await listen(scheduledTask, next);
    }
  }

  Future<void> listen(Task scheduledTask, DateTime next) async {
    await AndroidAlarmManager.oneShotAt(
      next,
      int.tryParse(scheduledTask.id) ?? 0,
      alarmCallback,
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
