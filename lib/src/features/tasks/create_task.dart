import 'package:flutter/material.dart';
import '../../services/init_services.dart';
import '../../widgets/snack_bar.dart';
import 'models/task.dart';
import 'services/schedule_task_service.dart';
import 'services/scheduling_service.dart';

class CreateTask extends StatefulWidget {
  const CreateTask({super.key});

  @override
  State<CreateTask> createState() => _CreateTaskState();
}

class _CreateTaskState extends State<CreateTask> {
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier<bool> loadingNotifier = ValueNotifier<bool>(false);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  TimeOfDay? time;
  bool isDaily = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Text('Add Task', style: TextStyle(fontSize: 30)),
            SizedBox(height: 20),
            TextFormField(
              validator: (v) => !v!.isNotEmpty ? 'Required' : null,
              decoration: InputDecoration(
                isDense: true,
                labelText: 'title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: titleController,
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                isDense: true,
                labelText: 'description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              controller: descriptionController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Open time picker'),
              onPressed: () async {
                TimeOfDay? time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                  initialEntryMode:TimePickerEntryMode.inputOnly,
                  orientation: Orientation.landscape,
                  builder: (BuildContext context, Widget? child) {
                    return child!;
                  },
                );
                setState(() {
                  time = time;
                });
              },
            ),
            if (time != null) Text('Selected time: ${time!.format(context)}'),
          ],
        ),
      ),
      Switch(
        value: isDaily,
        onChanged: (value) {
          setState(() {
            isDaily = value;
          });
        },
      ),
            Expanded(
              flex: 10,
              child: FilledButton(
                onPressed: () async {
                  loadingNotifier.value = true;
                  if (!_formKey.currentState!.validate()) return;
                  _formKey.currentState?.deactivate();
                  try {
                    var task = Task(
                      title: titleController.text,
                      description: descriptionController.text,
                      cron: cronController.text,
                      scheduledAt: lastScheduledAt,
                      todos: [],
                    );

                    var id = await ScheduledTaskService.createTask(task);
                    var service = locator<SchedulingService>();
                    await service.scheduleCron(id);

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(getSnackBar('Schedule Created'));
                    _formKey.currentState?.reset();
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(getSnackBar('Error Creating Schedule'));
                  } finally {
                    _formKey.currentState?.activate();
                    loadingNotifier.value = false;
                  }
                },
                child: Text('Schedule'),
              ),
            ),
            SizedBox(height: 15),
            ValueListenableBuilder(
              valueListenable: loadingNotifier,
              builder: (context, isLoading, _) {
                return ValueListenableBuilder(
                  valueListenable: loadingNotifier,
                  builder: (context, responseMsg, _) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isLoading) const CircularProgressIndicator(),
                      ],
                    );
                  },
                );
              },
            ),
          ],
    ))
    );
  }
}
