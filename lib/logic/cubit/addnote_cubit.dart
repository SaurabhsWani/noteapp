import 'package:bloc/bloc.dart';

part 'addnote_state.dart';

class AddnoteCubit extends Cubit<AddNoteState> {
  AddnoteCubit()
      : super(AddNoteState(
            title: '',
            discription: '',
            videoLink: '',
            status: 0,
            videoLinkcheck: false));
  void toggleVideo(bool videoLinkcheck) {
    emit(state.copyWith(videoLinkcheck: videoLinkcheck));
  }

  void toggletitle(String title) {
    emit(state.copyWith(title: title));
  }

  void toggledsic(String discription) {
    emit(state.copyWith(discription: discription));
  }

  void togglestatus(int status) {
    emit(state.copyWith(status: status));
  }

  void togglevideolink(String videoLink) {
    emit(state.copyWith(videoLink: videoLink));
  }
}
