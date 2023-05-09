import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:robot_chat_flutter/model/message.dart';
import 'package:robot_chat_flutter/model/ui_state.dart';

abstract class ListEvent {
  const ListEvent();
}

class AddMessageEvent extends ListEvent {
  final Message message;

  const AddMessageEvent(this.message);
}

class ListBloc extends Bloc<ListEvent, List<Message>> {
  ListBloc() : super([]) {
    on<AddMessageEvent>((event, emit) {
      emit([event.message, ...state]);
    });
  }
}

class UiStateCubit extends Cubit<UiState> {
  UiStateCubit() : super(Initial());

  void updateState(UiState state) {
    emit(state);
  }
}

class ScrollToTopCubit extends Cubit<int> {
  ScrollToTopCubit() : super(0);

  void updateCommand() {
    if (state == 0) {
      emit(1);
    } else {
      emit(-state);
    }
  }
}
