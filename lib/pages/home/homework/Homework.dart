import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:school_mate/API/supabase/homeworks/tasks.dart';
import 'package:school_mate/API/supabase/schedule/schedule.dart';
import 'package:school_mate/Classes/homeworks/Homework.dart';
import 'package:school_mate/Widgets/specialThemes/futuristic.dart';
import 'package:school_mate/l10n/app_localizations.dart';
import 'package:school_mate/main.dart';
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
  AppLocalizations get l10n => AppLocalizations.of(context)!;
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
    final double maxDx = screenSize.width - dialogWidth - 16.0;
    final double maxDy = screenSize.height - dialogHeight - 16.0;
    final dx = (offset.dx + dialogWidth > screenSize.width
        ? maxDx
        : offset.dx).clamp(16.0, maxDx < 16.0 ? 16.0 : maxDx);
    final dy = (offset.dy + dialogHeight > screenSize.height
        ? maxDy
        : offset.dy).clamp(16.0, maxDy < 16.0 ? 16.0 : maxDy);

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
                          WidgetsBinding.instance.addPostFrameCallback(
                              (_) => ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Text(l10n.homeworkDeleted),
                                    ),
                                  ));
                          Navigator.of(context).pop();
                          await deleteTask(homework);
                          setState(() {
                            tasks = tasks
                                .where((task) => task.taskID != homework.taskID)
                                .toList();
                          });
                          logger.i("Deleted a task");
                        },
                        icon: const Icon(Icons.delete),
                        label: Text(l10n.delete),
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

  Widget _buildHomeworkPage(List<Homework> tasks) {
    final topPadding = MediaQuery.of(context).padding.top + kToolbarHeight + 48;
    return Stack(children: [
      ListView.separated(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: topPadding + 16,
            bottom: 100,
          ),
          itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FutureBuilder<dynamic>(
                        future: fetchSchedule(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Text('${l10n.errorPrefix}: ${snapshot.error}');
                          } else if (snapshot.connectionState == ConnectionState.done) {
                            final data = snapshot.data;
                            if (data == null) {
                              return ScheduleSetupPage(
                                  headerTitle: l10n.scheduleSetupWarning);
                            }
                            return AddHomeworkPage(
                              schedule: data,
                              task: tasks[index],
                            );
                          } else {
                            return const Center(child: CircularProgressIndicator());
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
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemCount: tasks.length),
      Align(
        alignment: Alignment.bottomRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
          child: IconButton(
            tooltip: l10n.addHomeworkTooltip,
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => FutureBuilder<dynamic>(
                    future: fetchSchedule(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('${l10n.errorPrefix}: ${snapshot.error}');
                      } else if (snapshot.connectionState == ConnectionState.done) {
                        final data = snapshot.data;
                        if (data == null) {
                          return ScheduleSetupPage(
                              headerTitle: l10n.scheduleSetupWarning);
                        }
                        return AddHomeworkPage(schedule: data);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              );
            },
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            iconSize: 30,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(const Color(0xFF3A7BFF)),
              elevation: WidgetStateProperty.all(6),
              shadowColor: WidgetStateProperty.all(Colors.black38),
            ),
          ),
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text(
              l10n.homeworkTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
            centerTitle: true,
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              indicatorColor: const Color(0xFF3A7BFF),
              tabs: [
                Tab(
                  icon: const Icon(Icons.watch_later),
                  child: Text(l10n.openTab),
                ),
                Tab(
                  icon: const Icon(Icons.check),
                  child: Text(l10n.completedTab),
                )
              ],
            ),
          ),
          bottomNavigationBar: const HomeNavBar(currentIndex: 2),
          body: Stack(
            children: [
              buildGradientBackground(),
              const ParticleBackground(),
              TabBarView(
                  controller: _tabController,
                  children: isLoading
                      ? List.generate(
                          2,
                          (index) =>
                              const Center(child: CircularProgressIndicator()))
                      : [
                          Stack(
                            children: [
                              Positioned.fill(
                                top: MediaQuery.of(context).padding.top +
                                    kToolbarHeight +
                                    48 +
                                    100,
                                child: Opacity(
                                  opacity: 0.1,
                                  child: Lottie.asset(
                                    'assets/animations/working_person_black.json',
                                    alignment: Alignment.topCenter,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              _buildHomeworkPage(tasks
                                  .where((homework) => !homework.isCompleted)
                                  .toList()),
                            ],
                          ),
                          _buildHomeworkPage(tasks
                              .where((homework) => homework.isCompleted)
                              .toList())
                        ]),
            ],
          )),
    );
  }
}
