part of 'cart_bloc.dart';

class CartState {
  CartState({
    required this.cartElements,
    required this.totalPrice,
  });

  CartState copyWith({
    List<CartElement>? cartElements,
    double? totalPrice,
  }) {
    return CartState(
      cartElements: cartElements ?? this.cartElements,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  List<CartElement> cartElements;
  double totalPrice;
}

class CartElement {
  CartElement({
    required this.articles,
  });

  List<Article> articles;
}
