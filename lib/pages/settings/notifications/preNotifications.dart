import 'package:flutter/material.dart';

class NotificationSetting {
  String unit;
  int value;

  NotificationSetting(this.unit, this.value);
}

typedef FetchSettings = Future<List<NotificationSetting>> Function();
typedef UpdateSettings = Future<void> Function(List<NotificationSetting>);
typedef ValidateSettings = bool Function(List<NotificationSetting>);

class NotificationSetup extends StatefulWidget {
  final String title;
  final String itemSuffix;
  final FetchSettings fetchSettings;
  final UpdateSettings updateSettings;
  final ValidateSettings validateSettings;

  const NotificationSetup({
    super.key,
    required this.title,
    required this.itemSuffix,
    required this.fetchSettings,
    required this.updateSettings,
    required this.validateSettings,
  });

  @override
  State<NotificationSetup> createState() => _NotificationSetupState();
}

class _NotificationSetupState extends State<NotificationSetup>
    with TickerProviderStateMixin {
  bool _enabled = false;
  final _listKey = GlobalKey<AnimatedListState>();
  List<NotificationSetting> _items = [];
  List _controllers = <TextEditingController>[];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await widget.fetchSettings();

    setState(() {
      _items = [];
      _controllers.clear();
      _enabled = list.isNotEmpty;
    });

    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      _items.add(item);
      _controllers.add(TextEditingController(text: item.value.toString()));
      _listKey.currentState
          ?.insertItem(i, duration: const Duration(milliseconds: 300));
      await Future.delayed(const Duration(
          milliseconds: 50)); // Small delay for staggered animation (optional)
    }
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _onChange() async {
    if (widget.validateSettings(_items)) {
      await widget.updateSettings(_items);
    }
  }

  Future<void> _add() async {
    final newItem = NotificationSetting('minutes', 5);
    _items.add(newItem);
    _controllers.add(TextEditingController(text: '5'));
    _listKey.currentState?.insertItem(_items.length - 1,
        duration: const Duration(milliseconds: 300));
    await _onChange();
  }

  Future<void> _remove(int index) async {
    if (_items.length == 1) {
      setState(() {
        _enabled = false;
      });
    }
    final removed = _items.removeAt(index);
    _controllers.removeAt(index);
    _listKey.currentState?.removeItem(
      index,
      (context, anim) => _buildItem(removed, index, anim),
      duration: const Duration(milliseconds: 300),
    );
    await _onChange();
  }

  Widget _buildItem(NotificationSetting item, int i, Animation<double> a) {
    return SizeTransition(
      sizeFactor: a,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 50,
                  child: TextField(
                    controller: _controllers[i],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    onChanged: (v) async {
                      final n = int.tryParse(v);
                      if (n == null) return;
                      setState(() => _items[i].value = n);
                      await _onChange();
                    },
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.timer, color: Colors.blueAccent),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _items[i].unit,
                  items: const [
                    DropdownMenuItem(value: 'seconds', child: Text('Seconds')),
                    DropdownMenuItem(value: 'minutes', child: Text('Minutes')),
                    DropdownMenuItem(value: 'hours', child: Text('Hours')),
                    DropdownMenuItem(value: 'days', child: Text('Days')),
                  ],
                  onChanged: (v) async {
                    if (v == null) return;
                    setState(() => _items[i].unit = v);
                    await _onChange();
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                    child: Text(widget.itemSuffix,
                        style: const TextStyle(fontSize: 16))),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _remove(i),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ListView(
        children: [
          SwitchListTile.adaptive(
            title: const Text('Enabled'),
            value: _enabled,
            onChanged: (v) async {
              if (!v) {
                for (int i = _items.length - 1; i >= 0; i--) {
                  final removedItem = _items[i];
                  final controller = _controllers[i];
                  _controllers.removeAt(i);
                  _listKey.currentState?.removeItem(
                    i,
                    (context, animation) =>
                        _buildItem(removedItem, i, animation),
                    duration: const Duration(milliseconds: 300),
                  );

                  controller.dispose();
                }
              }

              setState(() {
                _enabled = v;
                _items = [];
                _controllers = [];
              });
              await _onChange();
            },
          ),
          _enabled // sometimes it takes to long to clear the elements, so there would be a split second error screen
              ? Opacity(
                  opacity: _enabled ? 1 : 0.5,
                  child: IgnorePointer(
                    ignoring: !_enabled,
                    child: Column(
                      children: [
                        AnimatedList(
                          key: _listKey,
                          initialItemCount: _items.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, i, a) =>
                              _buildItem(_items[i], i, a),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.add),
                              label: const Text('Add'),
                              onPressed: _add,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
