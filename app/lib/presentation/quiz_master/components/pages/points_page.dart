import 'package:flutter/material.dart';
import 'package:quizapp/globals.dart';
import 'package:quizapp/models/punkte.dart';
import 'package:quizapp/presentation/quiz_master/bloc/quiz_master_bloc.dart';

class PointsPage extends StatelessWidget {
  const PointsPage({
    required this.state,
    required this.bloc,
    Key? key,
  }) : super(key: key);

  final QuizMasterPoints state;
  final QuizMasterBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Punktevergabe')),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      body: ListView.builder(
        itemCount: state.jfBuzzerAssignments.length,
        itemBuilder: (context, index) {
          int currentPoints = state.jfBuzzerAssignments[index].punkte
              .firstWhere(
                  (element) =>
                      element.kategorieReihenfolge ==
                      state.currentCategoryReihenfolge,
                  orElse: () =>
                      Punkte(kategorieReihenfolge: 0, gesetztePunkte: 0))
              .gesetztePunkte;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    state.jfBuzzerAssignments[index].jugendfeuerwehr.name,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: Text(
                    Global.teilnehmer[index].gesamtPunkte.toString(),
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      NumKey(
                        text: '1',
                        isSelected: currentPoints == 1,
                        onTap: () => bloc.add(AktualisierePunkte(
                          jfTisch: state
                              .jfBuzzerAssignments[index].jugendfeuerwehr.tisch,
                          points: 1,
                        )),
                      ),
                      NumKey(
                          text: '2',
                          isSelected: currentPoints == 2,
                          onTap: () => bloc.add(AktualisierePunkte(
                                jfTisch: state.jfBuzzerAssignments[index]
                                    .jugendfeuerwehr.tisch,
                                points: 2,
                              ))),
                      NumKey(
                          text: '3',
                          isSelected: currentPoints == 3,
                          onTap: () => bloc.add(AktualisierePunkte(
                                jfTisch: state.jfBuzzerAssignments[index]
                                    .jugendfeuerwehr.tisch,
                                points: 3,
                              ))),
                      NumKey(
                          text: '4',
                          isSelected: currentPoints == 4,
                          onTap: () => bloc.add(AktualisierePunkte(
                                jfTisch: state.jfBuzzerAssignments[index]
                                    .jugendfeuerwehr.tisch,
                                points: 4,
                              ))),
                      NumKey(
                        text: '5',
                        isSelected: currentPoints == 5,
                        onTap: () => bloc.add(AktualisierePunkte(
                          jfTisch: state
                              .jfBuzzerAssignments[index].jugendfeuerwehr.tisch,
                          points: 5,
                        )),
                      ),
                      NumKey(
                        text: '6',
                        isSelected: currentPoints == 6,
                        onTap: () => bloc.add(AktualisierePunkte(
                          jfTisch: state
                              .jfBuzzerAssignments[index].jugendfeuerwehr.tisch,
                          points: 6,
                        )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.add(BestaetigePunkte());
        },
        child: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}

class NumKey extends StatelessWidget {
  const NumKey({
    required this.text,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String text;
  final bool isSelected;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).colorScheme.primary),
        ),
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.only(left: 6, right: 6),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
