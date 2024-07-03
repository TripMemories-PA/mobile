import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/monument/model/response/pois_response/pois_response.dart';
import '../../api/post/model/response/get_all_posts_response.dart';
import '../../object/poi/poi.dart';
import '../../object/position.dart';
import '../../object/post/post.dart';
import '../../object/radius.dart';
import '../../object/sort_possibility.dart';
import '../../repository/monument/i_monument_repository.dart';

part 'monument_event.dart';
part 'monument_state.dart';

class MonumentBloc extends Bloc<MonumentEvent, MonumentState> {
  MonumentBloc({
    required this.monumentRepository,
  }) : super(const MonumentState()) {
    on<GetMonumentsEvent>((event, emit) async {
      try {
        if (event.isRefresh) {
          emit(
            state.copyWith(
              searchingMonumentByNameStatus: MonumentStatus.loading,
              status: MonumentStatus.loading,
            ),
          );
        } else {
          emit(
            state.copyWith(
              searchingMonumentByNameStatus: MonumentStatus.loading,
            ),
          );
        }
        final PoisResponse monuments = await monumentRepository.getMonuments(
          page: event.isRefresh ? 1 : state.monumentsPage + 1,
          perPage: state.monumentsPerPage,
          position: event.position,
          sortByName: event.sortByName,
          order: event.order ?? AlphabeticalSortPossibility.ascending,
          searchingCriteria: event.searchingCriteria,
        );
        emit(
          state.copyWith(
            monumentsPage: state.isRefresh ? 0 : state.monumentsPage + 1,
            monuments: event.isRefresh
                ? monuments.data
                : [
                    ...state.monuments,
                    ...monuments.data,
                  ],
            searchMonumentsHasMoreMonuments:
                monuments.data.length == state.monumentsPerPage,
            searchingMonumentByNameStatus: MonumentStatus.notLoading,
            status: MonumentStatus.notLoading,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            searchingMonumentByNameStatus: MonumentStatus.error,
            status: MonumentStatus.error,
          ),
        );
      }
    });

    on<GetMonumentsOnMapEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: MonumentStatus.loading,
        ),
      );
      int page = 1;
      final List<Poi> monumentsToAdd = [];
      final PoisResponse monumentsFirstRound =
          await monumentRepository.getMonuments(
        page: page,
        perPage: 10,
        position: event.position,
        radius: event.radius,
        sortByName: true,
        order: AlphabeticalSortPossibility.ascending,
      );
      if (!event.isRefresh) {
        for (final Poi poi in monumentsFirstRound.data) {
          if (!state.monuments.contains(poi)) {
            monumentsToAdd.add(poi);
          }
        }
        while (monumentsToAdd.length < perPage) {
          page++;
          final PoisResponse monumentsNextRounds =
              await monumentRepository.getMonuments(
            page: page,
            perPage: 10,
            position: event.position,
            radius: event.radius,
            sortByName: true,
            order: AlphabeticalSortPossibility.ascending,
          );
          for (final Poi poi in monumentsNextRounds.data) {
            if (!state.monuments.contains(poi) &&
                !monumentsToAdd.contains(poi)) {
              monumentsToAdd.add(poi);
            }
          }
          if (monumentsNextRounds.data.length < perPage ||
              monumentsToAdd.length == monumentsNextRounds.data.length) {
            break;
          }
        }
      } else {
        monumentsToAdd.addAll(monumentsFirstRound.data);
      }
      final List<Poi> finalList = state.monuments + monumentsToAdd;
      if (finalList.length > 50) {
        finalList.removeRange(0, 10);
      }
      emit(
        state.copyWith(
          monuments: finalList,
          status: MonumentStatus.notLoading,
        ),
      );
    });

    on<GetMonumentEvent>((event, emit) async {
      emit(
        state.copyWith(
          status: MonumentStatus.loading,
        ),
      );
      final Poi monument = await monumentRepository.getMonument(event.id);
      add(GetMonumentPostsEvent(id: event.id, isRefresh: true));
      emit(
        state.copyWith(
          selectedMonument: monument,
          status: MonumentStatus.notLoading,
        ),
      );
    });

    on<GetMonumentPostsEvent>((event, emit) async {
      emit(
        state.copyWith(
          selectedPostGetMonumentsStatus: MonumentStatus.loading,
        ),
      );
      final GetAllPostsResponse posts =
          await monumentRepository.getMonumentPosts(
        poiId: event.id,
        page: event.isRefresh ? 1 : state.postMonumentPage + 1,
        perPage: perPage,
      );
      emit(
        state.copyWith(
          selectedPostGetMonumentsStatus: MonumentStatus.notLoading,
          selectedMonumentPosts: event.isRefresh
              ? posts.data
              : [
                  ...state.selectedMonumentPosts,
                  ...posts.data,
                ],
          getMonumentsHasMorePosts: posts.data.length == perPage,
          postMonumentPage: event.isRefresh ? 0 : state.postMonumentPage + 1,
        ),
      );
    });
  }
  final int perPage = 10;
  final IMonumentRepository monumentRepository;
}
