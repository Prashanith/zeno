import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/task.dart';
import 'services/schedule_task_service.dart';

class Tasks extends StatefulWidget {
  const Tasks({super.key});

  @override
  State<Tasks> createState() => _TasksState();
}

class _TasksState extends State<Tasks> {
  late List<Task> scheduledTasks = [];
  Future<List<Task>> _future = Future.delayed(Duration(seconds: 0), () => []);

  Future<List<Task>> fetchData() async {
    var list = await ScheduledTaskService.getAllTasks();
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
    return FutureBuilder<List<Task>>(
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

        final tasks = snapshot.data!;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return ExpansionTile(
              dense: true,
              shape: const Border(),
              collapsedShape: const Border(),
              title: Text(
                task.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text(
                task.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                  size: 20,
                ),
                onPressed: () async {
                  var data = await ScheduledTaskService.deleteTaskById(task.id);
                  if (data == 1) {
                    setState(() {
                      _future = fetchData();
                    });
                  }
                },
              ),
              // 4. Content Layout: Added padding and structure
              childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Schedule: ${task.title}',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('MMM dd').format(
                            task.scheduledAt ?? DateTime.now(),
                          ), // Jan 17 Time
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('hh:mm a').format(
                            task.scheduledAt ?? DateTime.now(),
                          ), // Jan 17 Time
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }
}
