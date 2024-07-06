class BuyTicketQueryElement {
  BuyTicketQueryElement({
    required this.id,
    required this.quantity,
  });
  int id;
  int quantity;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id; // Modifier 'ticketId' en 'id'
    data['quantity'] = quantity;
    return data;
  }
}

class BuyTicketQuery {
  BuyTicketQuery({
    required this.tickets,
  });
  List<BuyTicketQueryElement> tickets;

  Map<String, dynamic> toJson() {
    return {
      'tickets': tickets.map((ticket) => ticket.toJson()).toList(),
    };
  }
}
