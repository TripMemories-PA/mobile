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
  });

  MonumentState copyWith({
    List<Poi>? monuments,
    int? monumentsPerPage,
    int? monumentsPage,
    MonumentStatus? status,
    MonumentStatus? searchingMonumentByNameStatus,
    bool? isRefresh,
    bool? searchMonumentsHasMoreMonuments,
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
    );
  }

  final List<Poi> monuments;
  final int monumentsPerPage;
  final int monumentsPage;
  final MonumentStatus status;
  final MonumentStatus searchingMonumentByNameStatus;
  final bool searchMonumentsHasMoreMonuments;
  final bool isRefresh;
}
