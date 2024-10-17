import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  final Map<String, int> leaderboardData;

  LeaderboardPage({required this.leaderboardData});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with TickerProviderStateMixin {
  late List<MapEntry<String, int>> _sortedEntries;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  void initState() {
    super.initState();

    // Sort the entries by score (value) in ascending order
    _sortedEntries = widget.leaderboardData.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    // Start animation after a delay
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addItems();
    });
  }

  // Function to add items to the AnimatedList with a delay
  void _addItems() async {
    for (int i = 0; i < _sortedEntries.length; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      _listKey.currentState?.insertItem(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: AnimatedList(
        key: _listKey,
        initialItemCount: 0,
        itemBuilder: (context, index, animation) {
          return _buildLeaderboardItem(_sortedEntries[index], animation);
        },
      ),
    );
  }

  // Build each leaderboard item with animation
  Widget _buildLeaderboardItem(
      MapEntry<String, int> entry, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text(entry.value.toString()),
            ),
            title: Text(
              entry.key,
              style: TextStyle(color: Colors.white),
            ),
            trailing: Text(
              '${entry.value} Punkte',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
