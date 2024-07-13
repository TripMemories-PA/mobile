import '../bloc/meet/meet_bloc.dart';
import '../object/meet.dart';
import '../object/poi/poi.dart';

class MeetBlocAndObjDTO {
  MeetBlocAndObjDTO({required this.meetBloc, this.meet, required this.poi});

  final MeetBloc meetBloc;
  final Meet? meet;
  final Poi poi;
}
