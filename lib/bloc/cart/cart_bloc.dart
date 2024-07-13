import 'package:flutter_bloc/flutter_bloc.dart';

import '../../object/ticket.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartState(cartElements: <CartElement>[], totalPrice: 0)) {
    on<AddArticle>((event, emit) {
      final List<CartElement> cartElements =
          List<CartElement>.from(state.cartElements);
      final int index = cartElements
          .indexWhere((element) => element.articles[0].id == event.article.id);
      if (index == -1) {
        cartElements.add(CartElement(articles: [event.article]));
      } else {
        cartElements[index].articles.add(event.article);
      }
      double totalPrice = 0;
      for (int i = 0; i < cartElements.length; i++) {
        totalPrice +=
            cartElements[i].articles[0].price * cartElements[i].articles.length;
      }
      totalPrice = double.parse(totalPrice.toStringAsFixed(2));
      emit(
        state.copyWith(
          cartElements: cartElements,
          totalPrice: totalPrice,
          meetId: event.meetId,
        ),
      );
    });

    on<RemoveArticle>((event, emit) {
      final List<CartElement> cartElements =
          List<CartElement>.from(state.cartElements);
      final int index = cartElements
          .indexWhere((element) => element.articles[0].id == event.article.id);
      if (index != -1) {
        cartElements[index].articles.removeAt(0);
        if (cartElements[index].articles.isEmpty) {
          cartElements.removeAt(index);
        }
      }
      double totalPrice = 0;
      for (int i = 0; i < cartElements.length; i++) {
        totalPrice +=
            cartElements[i].articles[0].price * cartElements[i].articles.length;
      }
      totalPrice = double.parse(totalPrice.toStringAsFixed(2));
      emit(state.copyWith(cartElements: cartElements, totalPrice: totalPrice));
    });

    on<ClearCart>((event, emit) {
      emit(state.copyWith(cartElements: <CartElement>[], totalPrice: 0));
    });

    on<MeetTicketBought>((event, emit) {
      emit(state.copyWith(meetBuyStatus: CartStatus.meetTicketBought));
    });
  }
}
