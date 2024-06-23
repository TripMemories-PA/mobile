part of 'monument_bloc.dart';

enum MonumentStatus { loading, notLoading, error }

class MonumentState {
  const MonumentState({
    this.monuments = const [],
    this.monumentsPerPage = 10,
    this.monumentsPage = 0,
    this.status = MonumentStatus.notLoading,
    this.searchingMonumentByNameStatus = MonumentStatus.notLoading,
    this.searchMonumentsHasMoreMonuments = true,
    this.isRefresh = false,
    this.selectedMonument,
    this.selectedMonumentPosts = const [],
    this.postMonumentPage = 0,
    this.selectedPostGetMonumentsStatus = MonumentStatus.notLoading,
    this.getMonumentsHasMorePosts = true,
  });

  MonumentState copyWith({
    List<Poi>? monuments,
    int? monumentsPerPage,
    int? monumentsPage,
    MonumentStatus? status,
    MonumentStatus? searchingMonumentByNameStatus,
    bool? isRefresh,
    bool? searchMonumentsHasMoreMonuments,
    Poi? selectedMonument,
    List<Post>? selectedMonumentPosts,
    int? postMonumentPage,
    MonumentStatus? selectedPostGetMonumentsStatus,
    bool? getMonumentsHasMorePosts,
  }) {
    return MonumentState(
      monuments: monuments ?? this.monuments,
      monumentsPerPage: monumentsPerPage ?? this.monumentsPerPage,
      monumentsPage: monumentsPage ?? this.monumentsPage,
      status: status ?? this.status,
      searchingMonumentByNameStatus:
          searchingMonumentByNameStatus ?? this.searchingMonumentByNameStatus,
      searchMonumentsHasMoreMonuments: searchMonumentsHasMoreMonuments ??
          this.searchMonumentsHasMoreMonuments,
      isRefresh: isRefresh ?? this.isRefresh,
      selectedMonument: selectedMonument ?? this.selectedMonument,
      selectedMonumentPosts:
          selectedMonumentPosts ?? this.selectedMonumentPosts,
      postMonumentPage: postMonumentPage ?? this.postMonumentPage,
      selectedPostGetMonumentsStatus:
          selectedPostGetMonumentsStatus ?? this.selectedPostGetMonumentsStatus,
      getMonumentsHasMorePosts:
          getMonumentsHasMorePosts ?? this.getMonumentsHasMorePosts,
    );
  }

  final List<Poi> monuments;
  final int monumentsPerPage;
  final int monumentsPage;
  final MonumentStatus status;
  final MonumentStatus searchingMonumentByNameStatus;
  final bool searchMonumentsHasMoreMonuments;
  final bool isRefresh;
  final Poi? selectedMonument;
  final List<Post> selectedMonumentPosts;
  final int postMonumentPage;
  final MonumentStatus selectedPostGetMonumentsStatus;
  final bool getMonumentsHasMorePosts;
}
