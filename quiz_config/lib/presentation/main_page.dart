import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_config/bloc/quiz_config_bloc.dart';
import 'package:quiz_config/presentation/import_fragen_screen.dart';
import 'package:quiz_config/presentation/initial_screen.dart';
import 'package:quiz_config/presentation/select_jugendfeuerwehren_screen.dart';
import 'package:quiz_config/presentation/start_neuen_tag_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<QuizConfigBloc>(context),
      builder: (context, state) {
        if (state is QuizConfigInitial) {
          return const InitialScreen();
        } else if (state is QuizConfigStartNeuenTag) {
          return StartNeuenTagScreen(
            selectedDate: state.datum,
            durchlaeufe: state.durchlaeufe,
          );
        } else if (state is QuizConfigImportFragen) {
          return const ImportFragenScreen();
        } else if (state is QuizConfigSelectJugendfeuerwehren) {
          return SelectJugendfeuerwehrenScreen(
            jugendfeuerwehren: state.jugendfeuerwehren,
            ausgewaehlteJugendfeuerwehren: state.ausgewaehlteJugendfeuerwehren,
          );
        } else if (state is QuizConfigAssignFragen) {
          return Text('Assign Fragen: ${state.selectedItems}');
        } else {
          return const Text('Unknown state');
        }
      },
    );
  }
}
