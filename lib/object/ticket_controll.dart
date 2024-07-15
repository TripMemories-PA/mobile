import 'profile.dart';
import 'ticket.dart';

class ControlledTicket {
  ControlledTicket({
    required this.id,
    required this.paid,
    required this.qrCode,
    required this.ticket,
    required this.user,
    required this.createdAt,
    this.meetId,
  });

  factory ControlledTicket.fromJson(Map<String, dynamic> json) {
    return ControlledTicket(
      id: json['id'] as int,
      paid: json['paid'] as bool,
      qrCode: json['qrCode'] as String,
      ticket: Ticket.fromJson(json['ticket'] as Map<String, dynamic>),
      user: Profile.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      meetId: json['meetId'] as int?,
    );
  }

  int id;
  bool paid;
  String qrCode;
  Ticket ticket;
  Profile user;
  DateTime createdAt;
  int? meetId;

  ControlledTicket copyWith({
    int? id,
    bool? paid,
    String? qrCode,
    Ticket? ticket,
    Profile? user,
    DateTime? createdAt,
    int? meetId,
  }) {
    return ControlledTicket(
      id: id ?? this.id,
      paid: paid ?? this.paid,
      qrCode: qrCode ?? this.qrCode,
      ticket: ticket ?? this.ticket,
      user: user ?? this.user,
      createdAt: createdAt ?? this.createdAt,
      meetId: meetId ?? this.meetId,
    );
  }
}
