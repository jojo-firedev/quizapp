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
      // Slower delay between items
      await Future.delayed(const Duration(milliseconds: 400));
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
        // Max vertical spacing
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            // Bigger avatar size
            leading: CircleAvatar(
              radius: 30, // Increased size of the avatar
              child: Text(
                entry.value.toString(),
                style: TextStyle(fontSize: 20), // Larger text inside avatar
              ),
            ),
            title: Text(
              entry.key,
              style: TextStyle(
                color: Colors.white,
                fontSize: 30, // Larger font size for name
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Text(
              '${entry.value} Punkte',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28, // Larger font size for score
              ),
            ),
          ),
        ),
      ),
    );
  }
}
