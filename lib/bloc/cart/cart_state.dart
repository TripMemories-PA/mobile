part of 'cart_bloc.dart';

enum CartStatus { meetTicketBought, initial, error }

class CartState {
  CartState({
    required this.cartElements,
    required this.totalPrice,
    this.meetId,
    this.meetBuyStatus = CartStatus.initial,
  });

  CartState copyWith({
    List<CartElement>? cartElements,
    double? totalPrice,
    int? meetId,
    CartStatus? meetBuyStatus,
  }) {
    return CartState(
      cartElements: cartElements ?? this.cartElements,
      totalPrice: totalPrice ?? this.totalPrice,
      meetId: meetId ?? this.meetId,
      meetBuyStatus: meetBuyStatus ?? CartStatus.initial,
    );
  }

  List<CartElement> cartElements;
  double totalPrice;
  int? meetId;
  CartStatus meetBuyStatus;
}

class CartElement {
  CartElement({
    required this.articles,
  });

  List<Ticket> articles;
}
