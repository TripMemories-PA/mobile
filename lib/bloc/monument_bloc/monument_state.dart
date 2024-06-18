part of 'monument_bloc.dart';

enum MonumentStatus { loading, notLoading, error }

class MonumentState {
  const MonumentState({
    this.monuments,
    this.monumentsPerPage = 50,
    this.monumentsPage = 1,
    this.status = MonumentStatus.notLoading,
    this.searchingMonumentByNameStatus = MonumentStatus.notLoading,
    this.searchMonumentsHasMoreMonuments = true,
  });

  MonumentState copyWith({
    List<Poi>? monuments,
    int? monumentsPerPage,
    int? monumentsPage,
    MonumentStatus? status,
    MonumentStatus? searchingMonumentByNameStatus,
    bool? searchMonumentsHasMoreUsers,
  }) {
    return MonumentState(
      monuments: monuments ?? this.monuments,
      monumentsPerPage: monumentsPerPage ?? this.monumentsPerPage,
      monumentsPage: monumentsPage ?? this.monumentsPage,
      status: status ?? this.status,
      searchingMonumentByNameStatus:
          searchingMonumentByNameStatus ?? this.searchingMonumentByNameStatus,
      searchMonumentsHasMoreMonuments:
          searchMonumentsHasMoreUsers ?? searchMonumentsHasMoreMonuments,
    );
  }

  final List<Poi>? monuments;
  final int monumentsPerPage;
  final int monumentsPage;
  final MonumentStatus status;
  final MonumentStatus searchingMonumentByNameStatus;
  final bool searchMonumentsHasMoreMonuments;
}
