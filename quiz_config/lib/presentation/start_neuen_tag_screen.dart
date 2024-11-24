import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:quiz_config/bloc/quiz_config_bloc.dart';

class StartNeuenTagScreen extends StatefulWidget {
  const StartNeuenTagScreen({
    super.key,
    required this.selectedDate,
    required this.durchlaeufe,
  });

  final DateTime selectedDate;
  final int durchlaeufe;

  @override
  _StartNeuenTagScreenState createState() => _StartNeuenTagScreenState();
}

class _StartNeuenTagScreenState extends State<StartNeuenTagScreen> {
  late DateTime _selectedDate;
  late TextEditingController _dateController;
  late int _durchlaeufe;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _durchlaeufe = widget.durchlaeufe;
    _dateController = TextEditingController(
      text: DateFormat('dd.MM.yyyy').format(_selectedDate),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd.MM.yyyy').format(_selectedDate);
        BlocProvider.of<QuizConfigBloc>(context).add(
          StartNeuenTag(_selectedDate, _durchlaeufe),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            BlocProvider.of<QuizConfigBloc>(context).add(ConfirmNeuerTag()),
        // onPressed: () => Navigator.of(context).pop(),
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Speichern & Weiter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text('Datum: '),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _dateController,
                        readOnly: true,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        onTap: () => _selectDate(context),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const SizedBox(
                      width: 100,
                      child: Text('Durchläufe: '),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          if (_durchlaeufe > 1) {
                            _durchlaeufe--;
                            BlocProvider.of<QuizConfigBloc>(context).add(
                              StartNeuenTag(_selectedDate, _durchlaeufe),
                            );
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 10),
                    Text('$_durchlaeufe'),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          if (_durchlaeufe < 10) {
                            _durchlaeufe++;
                            BlocProvider.of<QuizConfigBloc>(context).add(
                              StartNeuenTag(_selectedDate, _durchlaeufe),
                            );
                          }
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => BlocProvider.of<QuizConfigBloc>(context)
                      .add(ConfirmNeuerTag()),
                  label: const Text('Bestätigen'),
                  icon: const Icon(Icons.check),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
