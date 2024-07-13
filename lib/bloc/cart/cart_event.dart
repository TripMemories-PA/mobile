part of 'cart_bloc.dart';

sealed class CartEvent {}

class AddArticle extends CartEvent {
  AddArticle(this.article, {this.meetId});

  final Ticket article;
  final int? meetId;
}

class RemoveArticle extends CartEvent {
  RemoveArticle(this.article);

  final Ticket article;
}

class ClearCart extends CartEvent {}

class MeetTicketBought extends CartEvent {}
