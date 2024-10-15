import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'screen_app_event.dart';
part 'screen_app_state.dart';

class ScreenAppBloc extends Bloc<ScreenAppEvent, ScreenAppState> {
  ScreenAppBloc() : super(ScreenAppInitial()) {
    on<ScreenAppEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
