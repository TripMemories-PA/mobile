import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/cart/cart_bloc.dart';
import '../constants/string_constants.dart';
import '../num_extensions.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final int total = context.read<CartBloc>().state.cartElements.fold(
              0,
              (previousValue, element) =>
                  previousValue + element.articles.length,
            );
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                navigationShell,
                if (total > 0)
                  Positioned(
                    right: 10,
                    child: Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart_outlined),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return _buildCart();
                              },
                            );
                          },
                        ),
                        Positioned(
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 15,
                              minHeight: 15,
                            ),
                            child: Text(
                              '$total',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            showUnselectedLabels: true,
            selectedItemColor: Theme.of(context).primaryColor,
            unselectedItemColor: Colors.grey,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.search_outlined,
                ),
                label: StringConstants().search,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.location_on_outlined,
                ),
                label: StringConstants().map,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.notifications_outlined,
                ),
                label: StringConstants().feed,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                ),
                label: StringConstants().shop,
              ),
              BottomNavigationBarItem(
                icon: const Icon(
                  Icons.person_outline,
                ),
                label: StringConstants().profile,
              ),
            ],
            currentIndex: navigationShell.currentIndex,
            onTap: (int index) => _onTap(context, index),
          ),
        );
      },
    );
  }

  Dialog _buildCart() {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.fromBorderSide(
                BorderSide(),
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.90,
            height: MediaQuery.of(context).size.height * 0.90,
            child: Column(
              children: [
                TextButton(
                  child: Text(StringConstants().close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        for (final cartElement
                            in context.read<CartBloc>().state.cartElements)
                          Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                height: 80,
                                child: Row(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          10,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          15.0,
                                        ),
                                        child: Image.network(
                                          cartElement.articles[0].imageUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    10.pw,
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      child: Text(
                                        cartElement.articles[0].title,
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '${cartElement.articles.length}',
                                    ),
                                    const Spacer(),
                                    Column(
                                      children: [
                                        Text(
                                          '${StringConstants().price}: ${cartElement.articles[0].price}',
                                        ),
                                        SizedBox(
                                          height: 40,
                                          width: 40,
                                          child: IconButton(
                                            onPressed: () => {
                                              context.read<CartBloc>().add(
                                                    RemoveArticle(cartElement
                                                        .articles[0]),
                                                  ),
                                            },
                                            icon: const Icon(
                                              Icons.delete,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5.0,
                                ),
                                child: Container(
                                  height: 1,
                                  color: Colors.grey,
                                  width: double.infinity,
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                Text(
                    '${StringConstants().total}: ${context.read<CartBloc>().state.totalPrice}',
                    style: const TextStyle(
                      fontSize: 20,
                    )),
                10.ph,
              ],
            ),
          );
        },
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
