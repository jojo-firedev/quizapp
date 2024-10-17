import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'dart:convert';

part 'screen_app_event.dart';
part 'screen_app_state.dart';

class ScreenAppBloc extends Bloc<ScreenAppEvent, ScreenAppState> {
  Socket? _socket;

  ScreenAppBloc() : super(ScreenAppInitial()) {
    on<ConnectToServer>(_onConnectToServer);
    on<DisplayCategories>(_onDisplayCategories);
    on<DisplayQuestion>(_onDisplayQuestion);
    on<DisplayCountdown>(_onDisplayCountdown);
    on<DisplayAnswer>(_onDisplayAnswer);
    on<DisplayScore>(_onDisplayScore);
    on<DisplayPointInput>(_onDisplayPointInput);
    on<DisplayFinalScore>(_onDisplayFinalScore);
  }

  // Event handler for connecting to the server
  void _onConnectToServer(
      ConnectToServer event, Emitter<ScreenAppState> emit) async {
    emit(ScreenAppConnecting());
    try {
      _socket = await Socket.connect(InternetAddress.loopbackIPv4, 4040);
      _socket?.listen((List<int> data) {
        final String message = utf8.decode(data);
        final decodedData = jsonDecode(message);
        _handleData(decodedData);
      });
      emit(ScreenAppWaitingForData());
    } catch (e) {
      print('Error: $e');
      emit(ScreenAppInitial());
    }
  }

  // Handle incoming data from the server
  void _handleData(Map<String, dynamic> data) {
    if (data['type'] == 'categories') {
      add(DisplayCategories(
        categories: Map<String, bool>.from(data['categories']),
        selectedCategory: data['selectedCategory'],
      ));
    } else if (data['type'] == 'question') {
      add(DisplayQuestion(
        question: data['question'],
        category: data['category'],
        jugendfeuerwehr: data['jugendfeuerwehr'],
      ));
    } else if (data['type'] == 'countdown') {
      add(DisplayCountdown(
        question: data['question'],
        category: data['category'],
        countdown: data['countdown'],
      ));
    } else if (data['type'] == 'answer') {
      add(DisplayAnswer(
        question: data['question'],
        answer: data['answer'],
        category: data['category'],
        jugendfeuerwehr: data['jugendfeuerwehr'],
      ));
    } else if (data['type'] == 'score') {
      add(DisplayScore(score: data['score']));
    } else if (data['type'] == 'point_input') {
      add(DisplayPointInput(
        jugendfeuerwehren: List<String>.from(data['jugendfeuerwehren']),
        currentPoints: List<int>.from(data['currentPoints']),
        inputPoints: List<int>.from(data['inputPoints']),
      ));
    } else if (data['type'] == 'final_score') {
      add(DisplayFinalScore(
        points: Map<String, int>.from(data['points']),
      ));
    }
  }

  // Event handler for DisplayCategories
  void _onDisplayCategories(
      DisplayCategories event, Emitter<ScreenAppState> emit) {
    emit(ScreenAppShowCategory(event.categories, event.selectedCategory));
  }

  // Event handler for DisplayQuestion
  void _onDisplayQuestion(DisplayQuestion event, Emitter<ScreenAppState> emit) {
    emit(ScreenAppShowQuestion(
        event.question, event.category, event.jugendfeuerwehr));
  }

  // Event handler for DisplayCountdown
  void _onDisplayCountdown(
      DisplayCountdown event, Emitter<ScreenAppState> emit) {
    emit(ScreenAppShowCountdown(
        event.question, event.category, event.countdown));
  }

  // Event handler for DisplayAnswer
  void _onDisplayAnswer(DisplayAnswer event, Emitter<ScreenAppState> emit) {
    emit(ScreenAppShowAnswer(
        event.question, event.answer, event.category, event.jugendfeuerwehr));
  }

  // Event handler for DisplayScore
  void _onDisplayScore(DisplayScore event, Emitter<ScreenAppState> emit) {
    emit(ScreenAppShowScore(event.score));
  }

  // Event handler for DisplayPointInput
  void _onDisplayPointInput(
      DisplayPointInput event, Emitter<ScreenAppState> emit) {
    emit(ScreenAppShowPointInput(
      event.jugendfeuerwehren,
      event.currentPoints,
      event.inputPoints,
    ));
  }

  FutureOr<void> _onDisplayFinalScore(
      DisplayFinalScore event, Emitter<ScreenAppState> emit) {
    emit(ScreenAppShowFinalScore(event.points));
  }
}
