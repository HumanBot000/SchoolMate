import 'package:flutter/material.dart';
import 'package:school_mate/API/supabase/homeworks/tasks.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart';
import 'package:school_mate/Classes/homeworks/Homework.dart';
import 'package:school_mate/pages/home/Widgets/BottomNavBar.dart';
import 'package:school_mate/pages/home/homework/Widgets/HomeworkBox.dart';
import 'package:school_mate/pages/home/homework/add/AddHomework.dart';
import 'package:school_mate/pages/home/schedule/setup/scheduleSetup.dart';

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

  Widget _buildHomeworkPage(List<Homework> tasks) => Stack(children: [
        ListView.separated(
            itemBuilder: (context, index) => HomeworkBox(
                  homework: tasks[index],
                  onCompletionToggle: () => _onCompletionToggle(tasks[index]),
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
                backgroundColor: MaterialStateProperty.all(
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
