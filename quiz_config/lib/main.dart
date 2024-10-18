import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:quiz_config/models/jugendfeuerwehr.dart';
import 'package:quiz_config/services/file_manager_service.dart';

void main() {
  runApp(const QuizConfig());
}

class QuizConfig extends StatelessWidget {
  const QuizConfig({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Config',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: ListSelectionScreen(),
    );
  }
}

class ListSelectionScreen extends StatefulWidget {
  @override
  _ListSelectionScreenState createState() => _ListSelectionScreenState();
}

class _ListSelectionScreenState extends State<ListSelectionScreen> {
  List<Jugendfeuerwehr> availableItems = [];
  List<Jugendfeuerwehr> selectedItems = [];

  @override
  void initState() {
    super.initState();
    _loadCSVData();
  }

  Future<void> _loadCSVData() async {
    List<Jugendfeuerwehr> data =
        await FileManager.loadJugendfeuerwehren('assets/data.csv');
    setState(() {
      availableItems = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Selector & Reorder Example'),
      ),
      body: Row(
        children: [
          // Available Items List
          Expanded(
            child: Column(
              children: [
                Text('Available Items',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ListView.builder(
                    itemCount: availableItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(availableItems[index].name),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward),
                          onPressed: () {
                            setState(() {
                              selectedItems.add(availableItems[index]);
                              availableItems.removeAt(index);
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Selected Items List
          Expanded(
            child: Column(
              children: [
                Text('Selected Items',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Expanded(
                  child: ReorderableListView(
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = selectedItems.removeAt(oldIndex);
                        selectedItems.insert(newIndex, item);
                      });
                    },
                    children: [
                      for (int i = 0; i < selectedItems.length; i++)
                        _buildSelectedItemTile(i),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedItemTile(int index) {
    return ListTile(
      key: ValueKey(selectedItems[index].name),
      title: Text(selectedItems[index].name),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          setState(() {
            availableItems.add(selectedItems[index]);
            selectedItems.removeAt(index);
          });
        },
      ),
    );
  }
}
