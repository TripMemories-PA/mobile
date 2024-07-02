part of 'cart_bloc.dart';

sealed class CartEvent {}

class AddArticle extends CartEvent {
  AddArticle(this.article);

  final Article article;
}

class RemoveArticle extends CartEvent {
  RemoveArticle(this.article);

  final Article article;
}
