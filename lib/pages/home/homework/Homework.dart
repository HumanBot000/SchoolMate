import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/homeworks/tasks.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart';
import 'package:school_mate/Classes/homeworks/Homework.dart';
import 'package:school_mate/main.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/homework/Widgets/HomeworkBox.dart';
import 'package:school_mate/pages/home/homework/add/AddHomework.dart';
import 'package:school_mate/pages/home/schedule/setup/scheduleSetup.dart';
import 'package:school_mate/util/extensions/dates.dart';

class HomeworkPage extends StatefulWidget {
  const HomeworkPage({super.key});

  @override
  State<HomeworkPage> createState() => _HomeworkPageState();
}

class _HomeworkPageState extends State<HomeworkPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late List<Homework> tasks;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChange);
    _fetchHomeworks();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChange() {
    if (_tabController.indexIsChanging) {
      _fetchHomeworks();
    }
  }

  void _fetchHomeworks() async {
    setState(() => isLoading = true);
    tasks = await fetchHomeworks();
    setState(() => isLoading = false);
  }

  Future<void> _onCompletionToggle(Homework homework) async {
    await homework.toggleCompletion();
  }

  void _deleteDialog(Offset offset, Homework homework) {
    final screenSize = MediaQuery.of(context).size;
    const dialogWidth = 200.0; // Approximate width of the dialog
    const dialogHeight = 100.0; // Approximate height of the dialog

    // Ensure the dialog stays within the screen bounds
    final dx = offset.dx + dialogWidth > screenSize.width
        ? screenSize.width - dialogWidth - 16 // Adjust for padding
        : offset.dx;
    final dy = offset.dy + dialogHeight > screenSize.height
        ? screenSize.height - dialogHeight - 16 // Adjust for padding
        : offset.dy;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: dy,
              left: dx,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: dialogWidth,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton.icon(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          await deleteTask(homework);
                          WidgetsBinding.instance.addPostFrameCallback((_) =>
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.green,
                                  content:
                                      Text("This homework has been deleted!"),
                                ),
                              ));
                          setState(() {
                            tasks = tasks
                                .where((task) => task.taskID != homework.taskID)
                                .toList();
                          });
                          logger.i("Deleted a task");
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text("Delete"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHomeworkPage(List<Homework> tasks) => Stack(children: [
        ListView.separated(
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                          future: fetchSchedule(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data is String &&
                                  snapshot.data!.isEmpty) {
                                return const ScheduleSetupPage(
                                    headerTitle:
                                        "Before you can add lessons and homeworks, please give us some details about your day. You don't have to add in your exact schedule in order to use these features.");
                              }
                              return AddHomeworkPage(
                                schedule: snapshot.data!,
                                title: tasks[index].title,
                                subject: tasks[index].subject,
                                additionalNote: tasks[index].note,
                                date: tasks[index].dueDate,
                                handIn: tasks[index].handIn,
                                handInTime: tasks[index].dueDate?.toTimeOfDay(),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                      ),
                    );
                  },
                  onLongPressStart: (details) =>
                      _deleteDialog(details.globalPosition, tasks[index]),
                  child: HomeworkBox(
                    homework: tasks[index],
                    onCompletionToggle: () => _onCompletionToggle(tasks[index]),
                  ),
                ),
            separatorBuilder: (context, index) => const Divider(),
            itemCount: tasks.length),
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: IconButton(
              tooltip: "Add a Homework",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder(
                      future: fetchSchedule(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data is String &&
                              snapshot.data!.isEmpty) {
                            return const ScheduleSetupPage(
                                headerTitle:
                                    "Before you can add lessons and homeworks, please give us some details about your day. You don't have to add in your exact schedule in order to use these features.");
                          }
                          return AddHomeworkPage(schedule: snapshot.data!);
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              iconSize: 30,
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(
                    Theme.of(context).colorScheme.primary),
              ),
            ),
          ),
        )
      ]);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Homework"),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(
                  icon: Icon(Icons.watch_later),
                  child: Text("Open"),
                ),
                Tab(
                  icon: Icon(Icons.check),
                  child: Text("Completed"),
                )
              ],
            ),
          ),
          bottomNavigationBar: const HomeNavBar(currentIndex: 2),
          body: TabBarView(
              controller: _tabController,
              children: isLoading
                  ? List.generate(
                      2,
                      (index) =>
                          const Center(child: CircularProgressIndicator()))
                  : [
                      _buildHomeworkPage(tasks
                          .where((homework) => !homework.isCompleted)
                          .toList()),
                      _buildHomeworkPage(tasks
                          .where((homework) => homework.isCompleted)
                          .toList())
                    ])),
    );
  }
}
