import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../api/monument/model/response/poi/poi.dart';
import '../component/popup/search_monument_popup.dart';

class SearchPage extends HookWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedMonument = useState<Poi?>(null);
    return Scaffold(
      body: ColoredBox(
        color: Colors.blue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  final Poi? result = await searchMonumentPopup(context);
                  if (result == null) {
                    return;
                  } else {
                    if (context.mounted) {
                      selectedMonument.value = result;
                    }
                  }
                },
                child: const Text('RECHERCHER'),
              ),
              if (selectedMonument.value != null)
                Text(selectedMonument.value!.name),
            ],
          ),
        ),
      ),
    );
  }
}
