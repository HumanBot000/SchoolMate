import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:school_mate/Classes/schedule/Lesson.dart';
import 'package:school_mate/Classes/schedule/Schedule.dart';
import 'package:school_mate/Classes/schedule/Subject.dart';
import 'package:school_mate/Widgets/public/GradientButton.dart';
import 'package:school_mate/Widgets/public/PreviousPage.dart';
import 'package:school_mate/Widgets/public/TimePicker.dart';
import 'package:school_mate/pages/home/schedule/page/Schedule.dart';
import 'package:school_mate/util/dates.dart';
import 'package:school_mate/util/extensions/dates.dart';
import 'package:school_mate/l10n/app_localizations.dart';

class LessonConfigurationPage extends StatefulWidget {
  final Subject subject;
  final Schedule schedule;
  final String? selectedRoomNumber;
  final Lesson? existingLesson;
  final Function(Subject, TimeOfDay, TimeOfDay, int, List<int>, String)
      onUpdate;

  const LessonConfigurationPage(
      {super.key,
      required this.subject,
      required this.schedule,
      this.selectedRoomNumber,
      required this.onUpdate,
      this.existingLesson});

  @override
  State<LessonConfigurationPage> createState() =>
      _LessonConfigurationPageState();
}

class _LessonConfigurationPageState extends State<LessonConfigurationPage> {
  late int _selectedWeekDay;
  late List<int> _selectedAlternatingWeeks;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  final TextEditingController _roomNumberController = TextEditingController();

  bool get _isDarkText => widget.subject.color.computeLuminance() < 0.5;

  Color get _textColor => _isDarkText ? Colors.white : Colors.black;

  @override
  void initState() {
    super.initState();
    if (widget.existingLesson != null) {
      _selectedWeekDay = widget.existingLesson!.temporalData.weekday - 1;
      _selectedAlternatingWeeks =
          widget.existingLesson!.temporalData.numericalAlternatingWeeks;
      _startTime = widget.existingLesson!.temporalData.startTime;
      _endTime = widget.existingLesson!.temporalData.endTime;
    } else {
      if (widget.schedule.metadata.workdays
          .contains(DateTime.now().weekday - 1)) {
        _selectedWeekDay = DateTime.now().weekday - 1;
      } else {
        _selectedWeekDay = widget.schedule.metadata.workdays[0];
      }
      _selectedAlternatingWeeks = List.generate(
          widget.schedule.metadata.numberOfAlternateWeeks, (index) => index);
    }
    if (widget.selectedRoomNumber != null) {
      _roomNumberController.text = widget.selectedRoomNumber!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(l10n.configureLessonTitle, style: TextStyle(color: _textColor)),
        leading: PreviousPage(iconColor: _textColor),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      // This seems a bit complicated, it has to do with the keyboard expansion https://stackoverflow.com/a/60246126
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildHeader(),
                _buildTeacherInfo(),
                _buildRoomNumberSelector(),
                _buildDayAndWeekSelector(),
                if (_selectedAlternatingWeeks.isEmpty)
                  _buildErrorText(
                      l10n.errorSelectAtLeastOneWeek),
                if (_startTime == null || _endTime == null)
                  _buildErrorText(l10n.errorSelectStartEndTimes),
                if ((_startTime != null && _endTime != null) &&
                    !_endTime!.isAfter(_startTime!))
                  _buildErrorText(l10n.errorEndTimeAfterStartTime),
                if ((_startTime != null && _endTime != null) &&
                    (!_startTime!.isBetween(
                            widget.schedule.metadata.firstLessonTime,
                            widget.schedule.metadata.lastLessonTime) ||
                        !_endTime!.isBetween(
                            widget.schedule.metadata.firstLessonTime,
                            widget.schedule.metadata.lastLessonTime)))
                  _buildErrorText(
                      l10n.errorTimesWithinSchoolDay),
                if ((_startTime != null && _endTime != null) &&
                    widget.schedule.lessonOverlaps(_startTime!, _endTime!,
                        _selectedWeekDay, _selectedAlternatingWeeks,
                        ignoredLessons: widget.existingLesson == null
                            ? []
                            : [widget.existingLesson!]))
                  _buildErrorText(
                      l10n.errorLessonOverlaps),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height * 0.05),
                  child: _buildAddButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateLessonUpdate() {
    if (_selectedAlternatingWeeks.isEmpty) return false;
    if (_startTime == null || _endTime == null) return false;
    if (!_endTime!.isAfter(_startTime!)) return false;
    if (!_startTime!.isBetween(widget.schedule.metadata.firstLessonTime,
            widget.schedule.metadata.lastLessonTime) ||
        !_endTime!.isBetween(widget.schedule.metadata.firstLessonTime,
            widget.schedule.metadata.lastLessonTime)) {
      return false;
    }
    if (widget.schedule.lessonOverlaps(
        _startTime!, _endTime!, _selectedWeekDay, _selectedAlternatingWeeks,
        ignoredLessons:
            widget.existingLesson == null ? [] : [widget.existingLesson!])) {
      return false;
    }
    return true;
  }

  Widget _buildAddButton() {
    final l10n = AppLocalizations.of(context)!;
    return ElevatedGradientButton(
        borderRadius: BorderRadius.circular(12),
        onPressed: () async {
          if (!validateLessonUpdate()) {
            WidgetsBinding.instance.addPostFrameCallback(
                (_) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Theme.of(context).colorScheme.error,
                        content: Text(
                          l10n.errorUnresolvedProblems,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: Theme.of(context).colorScheme.onError),
                        ),
                      ),
                    ));
            return;
          }
          Navigator.of(context).pop();
          widget.onUpdate(
              widget.subject,
              _startTime!,
              _endTime!,
              _selectedWeekDay,
              _selectedAlternatingWeeks,
              _roomNumberController.text);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.existingLesson == null ? Icons.add : Icons.save,
                color: Colors.white),
            Text(widget.existingLesson == null ? l10n.addLessonButton : l10n.updateLessonButton,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.white)),
          ],
        ));
  }

  Widget _buildHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      color: widget.subject.color,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.subject.name,
                style: TextStyle(
                  color: _textColor,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(width: 16),
            Icon(Icons.menu_book, color: _textColor, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        enabled: false,
        decoration: InputDecoration(
          label: Row(
            children: [
              const Icon(Icons.person),
              const SizedBox(width: 8),
              Text(
                  "${widget.subject.teacher.gender.address} ${widget.subject.teacher.name}"),
            ],
          ),
          labelStyle: const TextStyle(fontSize: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }

  Widget _buildRoomNumberSelector() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        // Later we have to use the string because of leading zeros and letters (for buildings for example)
        controller: _roomNumberController,
        decoration: InputDecoration(
          label: Row(
            children: [
              const Icon(Icons.door_front_door),
              const SizedBox(width: 8),
              Text(l10n.roomNumberLabel),
            ],
          ),
          labelStyle: const TextStyle(fontSize: 16),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
      ),
    );
  }

  Widget _buildDayAndWeekSelector() {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isSelectionComplete()
              ? Colors.grey
              : Theme.of(context).colorScheme.error,
        ),
      ),
      child: Column(
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Theme(
                      data: Theme.of(context),
                      // Ensure the current theme is passed down
                      child: SchedulePage(
                        schedule: widget.schedule,
                        showBreaks: true,
                        showLessonTapCallback: false,
                        onBreakSelection: (start, end, weekday) {
                          Navigator.of(context).pop();
                          setState(() {
                            _startTime = start;
                            _endTime = end;
                            _selectedAlternatingWeeks = List.generate(
                                widget.schedule.metadata.numberOfAlternateWeeks,
                                (i) => i);
                            _selectedWeekDay = weekday;
                          });
                        },
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  Text(
                    l10n.selectFromSchedule,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )
                ],
              )),
          _buildWeekdaySelector(),
          _buildAlternatingWeekSelector(),
          _buildTimeSelectors(),
        ],
      ),
    );
  }

  Widget _buildWeekdaySelector() {
    return Row(
      children: widget.schedule.metadata.workdays
          .map((i) => Expanded(
                flex: _selectedWeekDay == i ? 2 : 1,
                child: InkWell(
                  onTap: () => setState(() => _selectedWeekDay = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _selectedWeekDay == i
                          ? Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.2)
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat.E(Localizations.localeOf(context).languageCode).format(DateTime(2024, 1, 1 + i)),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                fontSize: _selectedWeekDay == i ? 20 : 16,
                                fontWeight: _selectedWeekDay == i
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: _selectedWeekDay == i
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: _selectedWeekDay == i
                              ? const Icon(Icons.arrow_upward,
                                  key: ValueKey('iconSelected'))
                              : const SizedBox.shrink(
                                  key: ValueKey('iconDeselected')),
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildAlternatingWeekSelector() {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: List.generate(
          widget.schedule.metadata.numberOfAlternateWeeks,
          (alternatingWeek) => Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedAlternatingWeeks.contains(alternatingWeek)
                      ? _selectedAlternatingWeeks.remove(alternatingWeek)
                      : _selectedAlternatingWeeks.add(alternatingWeek);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _selectedAlternatingWeeks.contains(alternatingWeek)
                      ? Colors.greenAccent.withValues(alpha: 0.8)
                      : Colors.redAccent.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: _selectedAlternatingWeeks.contains(alternatingWeek)
                      ? [
                           BoxShadow(
                             color: Colors.green.withValues(alpha: 0.5),
                             blurRadius: 6,
                             offset: const Offset(0, 3),
                           ),
                         ]
                      : [],
                ),
                child: Text(
                  l10n.weekLabelWithLetter(String.fromCharCode(65 + alternatingWeek)),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize:
                            _selectedAlternatingWeeks.contains(alternatingWeek)
                                ? 20
                                : 16,
                        color: Colors.black,
                        fontWeight:
                            _selectedAlternatingWeeks.contains(alternatingWeek)
                                ? FontWeight.bold
                                : FontWeight.normal,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimeSelectors() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTimeButton(
          gradient: const LinearGradient(colors: [Colors.cyan, Colors.indigo]),
          label: _startTime == null
              ? l10n.selectStartTime
              : DateFormat("HH:mm").format(_startTime!.toDateTime()),
          onPressed: () => _selectTime(
            l10n.lessonStartPrompt,
            _startTime ?? widget.schedule.metadata.firstLessonTime,
            (time) => setState(() {
              _startTime = time;
              _endTime ??= time.add(
                Duration(minutes: widget.schedule.metadata.defaultLessonLength),
              );
            }),
          ),
        ),
        const Icon(Icons.arrow_right_alt),
        Text(
          l10n.minutesValueShort(_calculateLessonDuration().toString()),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const Icon(Icons.arrow_right_alt),
        _buildTimeButton(
          label: _endTime == null
              ? l10n.selectEndTime
              : DateFormat("HH:mm").format(_endTime!.toDateTime()),
          onPressed: () => _selectTime(
            l10n.lessonEndPrompt,
            _endTime ?? TimeOfDay.now(),
            (time) => setState(() => _endTime = time),
          ),
          gradient: LinearGradient(
            colors: [Colors.red.shade300, Colors.orange.shade300],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeButton({
    required String label,
    required VoidCallback onPressed,
    required Gradient gradient,
  }) {
    return Expanded(
      child: ElevatedGradientButton(
        onPressed: onPressed,
        borderRadius: BorderRadius.circular(12),
        gradient: gradient,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorText(String text) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: Theme.of(context).colorScheme.error),
        ),
      ],
    );
  }

  void _selectTime(String headline, TimeOfDay initialTime,
      ValueChanged<TimeOfDay> onSelected) {
    showAdaptiveDialog(
      context: context,
      builder: (context) => CustomTimePicker(
        initialTime: initialTime,
        headline: headline,
        onTimeSelected: onSelected,
      ),
    );
  }

  bool _isSelectionComplete() =>
      _selectedAlternatingWeeks.isNotEmpty &&
      _startTime != null &&
      _endTime != null;

  int _calculateLessonDuration() => _startTime != null && _endTime != null
      ? _endTime!.difference(_startTime!).inMinutes
      : widget.schedule.metadata.defaultLessonLength;
}
