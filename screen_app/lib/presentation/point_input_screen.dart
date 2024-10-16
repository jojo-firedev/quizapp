import 'package:flutter/material.dart';

class PointInputScreen extends StatelessWidget {
  const PointInputScreen({
    super.key,
    required this.jugendfeuerwehren,
    required this.currentPoints,
    required this.inputPoints,
  });

  final List<String> jugendfeuerwehren;
  final List<int> currentPoints;
  final List<int> inputPoints;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Punktevergabe')),
      body: ListView.builder(
        itemCount: jugendfeuerwehren.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    jugendfeuerwehren[index],
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    'Aktuelle Punkte: ${currentPoints[index]}',
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumKey(
                        text: '1',
                        isSelected: inputPoints[index] == 1,
                      ),
                      NumKey(
                        text: '2',
                        isSelected: inputPoints[index] == 2,
                      ),
                      NumKey(
                        text: '3',
                        isSelected: inputPoints[index] == 3,
                      ),
                      NumKey(
                        text: '4',
                        isSelected: inputPoints[index] == 4,
                      ),
                      NumKey(
                        text: '5',
                        isSelected: inputPoints[index] == 5,
                      ),
                      NumKey(
                        text: '6',
                        isSelected: inputPoints[index] == 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NumKey extends StatelessWidget {
  const NumKey({
    required this.text,
    required this.isSelected,
    super.key,
  });

  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.primary),
      ),
      padding: const EdgeInsets.all(25),
      margin: const EdgeInsets.only(left: 8, right: 8),
      child: Text(
        text,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.black,
          fontSize: 30,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
