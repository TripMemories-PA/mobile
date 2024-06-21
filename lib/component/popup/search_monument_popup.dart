import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../api/monument/model/response/poi/poi.dart';
import '../../bloc/monument_bloc/monument_bloc.dart';
import '../../repository/monument/monument_repository.dart';
import '../../service/monument/monument_remote_data_source.dart';
import '../custom_card.dart';
import '../searching_monuments_body.dart';

class SearchMonumentPopup extends StatelessWidget {
  const SearchMonumentPopup({
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
        )..add(GetMonumentsEvent()),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Builder(
            builder: (context) => Dialog(
              child: CustomCard(
                width: MediaQuery.of(context).size.width * 0.90,
                height: MediaQuery.of(context).size.height * 0.81,
                content: SizedBox.expand(
                  child: Stack(
                    children: [
                      const SearchingMonumentBody(
                        needToPop: true,
                      ),
                      Positioned(
                        top: 30,
                        right: 10,
                        child: SizedBox(
                          height: 25,
                          child: ElevatedButton(
                            onPressed: () {
                              context.pop();
                            },
                            child: const Text('Fermer'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<Poi?> searchMonumentPopup(
  BuildContext context,
) async =>
    showDialog<Poi>(
      context: context,
      builder: (_) => const SearchMonumentPopup(),
    );
