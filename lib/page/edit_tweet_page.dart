import 'package:flutter/material.dart';

import '../component/custom_card.dart';
import '../num_extensions.dart';

class EditTweetPage extends StatelessWidget {
  const EditTweetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              _buildHeader(context),
              20.ph,
              CustomCard(
                width: double.infinity,
                height: 200,
                borderColor: Colors.transparent,
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                content: CustomCard(
                  height: 40,
                  width: MediaQuery.of(context).size.width * 0.35,
                  borderRadius: 20,
                  borderColor: Colors.transparent,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      'Ajouter une photo',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.surface,
                      ),
                    ),
                  ),
                  onTap: null,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomCard(
          borderColor: Theme.of(context).colorScheme.primary,
          onTap: null,
          height: 30,
          borderRadius: 20,
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              2.pw,
              SizedBox(
                width: 25,
                height: 25,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(Size(25, 25)),
                    maximumSize: WidgetStateProperty.all(Size(25, 25)),
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.surface),
                    side: WidgetStateProperty.all(
                      BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    padding: WidgetStateProperty.all(
                      EdgeInsets.zero,
                    ),
                  ),
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Theme.of(context).colorScheme.primary,
                    size: 15,
                  ),
                  onPressed: null,
                ),
              ),
              10.pw,
              Text(
                'Retour',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 11),
              ),
              10.pw,
            ],
          ),
        ),
        CustomCard(
          height: 30,
          width: 100,
          borderRadius: 20,
          borderColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.primary,
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Valider',
              style: TextStyle(color: Theme.of(context).colorScheme.surface),
            ),
          ),
          onTap: null,
        ),
      ],
    );
  }
}
