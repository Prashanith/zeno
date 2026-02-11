import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../services/init_services.dart';
import '../../services/notification_service.dart';
import 'package:intl/intl.dart';

class UpcomingTasks extends StatefulWidget {
  const UpcomingTasks({super.key});

  @override
  State<UpcomingTasks> createState() => _UpcomingTasksState();
}

class _UpcomingTasksState extends State<UpcomingTasks> {
  late List<PendingNotificationRequest> scheduledTasks = [];
  Future<List<PendingNotificationRequest>> _future = Future.delayed(
    Duration(seconds: 0),
    () => [],
  );

  Future<List<PendingNotificationRequest>> fetchData() async {
    var list = await locator<NotificationService>().getAll();
    return list;
  }

  void _reload() {
    setState(() {
      _future = fetchData();
    });
  }

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PendingNotificationRequest>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No scheduled tasks'));
        }

        final notifications = snapshot.data!;

        return ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final task = notifications[index];
            return ListTile(
              title: Text(task.title ?? ''),
              subtitle: Text(task.body ?? ''),
              trailing: Text(
                DateFormat(
                  'MMM dd hh:mm a',
                ).format(DateTime.parse(task.payload ?? '').toLocal()),
              ),
            );
          },
        );
      },
    );
  }
}
