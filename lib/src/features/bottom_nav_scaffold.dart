import 'package:flutter/material.dart';
import 'package:zeno/src/features/tasks/create_task.dart';
import 'package:zeno/src/features/tasks/tasks.dart';
import 'package:zeno/src/features/tasks/upcoming_tasks.dart';

import '../widgets/logo.dart';
import 'about/about_us.dart';

class BottomNavScaffold extends StatefulWidget {
  const BottomNavScaffold({super.key});

  @override
  State<BottomNavScaffold> createState() => _BottomNavScaffoldState();
}

class _BottomNavScaffoldState extends State<BottomNavScaffold> {
  int currentIndex = 0;

  Widget getWidget(int i) {
    switch (i) {
      case 0:
        return Tasks();
      case 1:
        return UpcomingTasks();
      case 2:
        return AboutUs();
      default:
        return Center();
    }
  }

  String getTitle(int i) {
    switch (i) {
      case 0:
        return 'Tasks';
      case 1:
        return 'Upcoming Schedules';
      case 2:
        return 'About Us';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle(currentIndex)),
        leading: Transform.scale(scale: 0.7, child: Logo()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.0),
          child: getWidget(currentIndex),
        ),
      ),
      floatingActionButton: currentIndex != 0
          ? null
          : FloatingActionButton(
              elevation: 10,
              shape: const CircleBorder(),
              child: Icon(Icons.add),
              onPressed: () => showModalBottomSheet(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.6,
                ),
                isScrollControlled: true,
                context: context,
                builder: (context) => CreateTask(),
              ),
            ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        height: 90,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (i) => setState(() {
              currentIndex = i;
            }),
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Schedules',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.notifications_sharp),
                label: 'Upcoming',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'About',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
