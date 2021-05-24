part of 'addnote_cubit.dart';

class AddNoteState {
  String title;
  String discription;
  String videoLink;
  int status;
  bool videoLinkcheck;
  AddNoteState({
    this.title,
    this.discription,
    this.videoLink,
    this.status,
    this.videoLinkcheck,
  });

  AddNoteState copyWith({
    String title,
    String discription,
    String videoLink,
    int status,
    bool videoLinkcheck,
  }) {
    return AddNoteState(
      title: title ?? this.title,
      discription: discription ?? this.discription,
      videoLink: videoLink ?? this.videoLink,
      status: status ?? this.status,
      videoLinkcheck: videoLinkcheck ?? this.videoLinkcheck,
    );
  }

  List<Object> get props => [
        videoLinkcheck,
        title,
        discription,
        videoLink,
        status,
      ];

  @override
  String toString() {
    return 'AddNoteState(title: $title, discription: $discription, videoLink: $videoLink, status: $status, videoLinkcheck: $videoLinkcheck)';
  }
}
