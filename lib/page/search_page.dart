import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/monument_bloc/monument_bloc.dart';
import '../../repository/monument/monument_repository.dart';
import '../../service/monument/monument_remote_data_source.dart';
import '../component/searching_monuments_body.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<MonumentRepository>(
      create: (context) => MonumentRepository(
        monumentRemoteDataSource: MonumentRemoteDataSource(),
        // TODO(nono): Implement ProfileLocalDataSource
        //profilelocalDataSource: ProfileLocalDataSource(),
      ),
      child: BlocProvider(
        create: (context) => MonumentBloc(
          monumentRepository:
              RepositoryProvider.of<MonumentRepository>(context),
        )..add(
            GetMonumentsEvent(
              isRefresh: true,
            ),
          ),
        child: const Scaffold(
          body: SafeArea(
            child: SearchingMonumentBody(),
          ),
        ),
      ),
    );
  }
}
