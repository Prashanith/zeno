import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../features/tasks/services/schedule_task_service.dart';
import '../features/tasks/services/scheduling_service.dart';
import 'db_service.dart';
import 'init_services.dart';

class AndroidAlarmService {
  static Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }
}

@pragma('vm:entry-point')
Future<void> rescheduleNextForId(int id) async {
  final scheduledTask = await ScheduledTaskService.getTaskById(id.toString());
  if (scheduledTask != null) {
    if (scheduledTask.scheduledAt != null &&
        scheduledTask.scheduledAt!.isBefore(DateTime.now())) {
      var service = locator<SchedulingService>();
      scheduledTask.scheduledAt = next;
      await ScheduledTaskService.updateTaskById(scheduledTask);
      if (next != null) {
        service.listen(scheduledTask, next);
      }
    }
  }
}

@pragma('vm:entry-point')
void alarmCallback(int id) async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  var location = tz.getLocation('Asia/Kolkata');
  tz.setLocalLocation(location);
  if (!locator.isRegistered<DbService>()) {
    await ServiceInitializer.initializeServices(skipPostInitialization: true);
  }
  await rescheduleNextForId(id);
}
