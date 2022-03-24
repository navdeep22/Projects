// To parse this JSON data, do
//
//     final bookingModel = bookingModelFromJson(jsonString);

import 'dart:convert';

BookingModel bookingModelFromJson(String str) =>
    BookingModel.fromJson(json.decode(str));

String bookingModelToJson(BookingModel data) => json.encode(data.toJson());

class BookingModel {
  BookingModel({
    this.result,
  });

  List<List<Result>> result;

  factory BookingModel.fromJson(Map<String, dynamic> json) => BookingModel(
        result: List<List<Result>>.from(json["result"]
            .map((x) => List<Result>.from(x.map((x) => Result.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(
            result.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class Result {
  Result({
    this.guestId,
    this.table,
    this.event,
  });

  String guestId;
  Table table;
  Event event;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        guestId: json["guest_id"] == null ? null : json["guest_id"],
        table: json["table"] == null ? null : Table.fromJson(json["table"]),
        event: json["event"] == null ? null : Event.fromJson(json["event"]),
      );

  Map<String, dynamic> toJson() => {
        "guest_id": guestId == null ? null : guestId,
        "table": table == null ? null : table.toJson(),
        "event": event == null ? null : event.toJson(),
      };
}

class Event {
  Event({
    this.id,
    this.eventId,
    this.eventSubId,
    this.guestId,
    this.date,
    this.rate,
    this.quantity,
    this.total,
    this.transactionId,
    this.createdAt,
    this.uid,
    this.bookingUid,
    this.updatedAt,
    this.isPaid,
    this.addon,
  });

  String id;
  String eventId;
  String eventSubId;
  String guestId;
  DateTime date;
  String rate;
  String quantity;
  String total;
  String transactionId;
  DateTime createdAt;
  String uid;
  String bookingUid;
  DateTime updatedAt;
  String isPaid;
  List<Addon> addon;

  factory Event.fromJson(Map<String, dynamic> json) => Event(
        id: json["id"],
        eventId: json["event_id"],
        eventSubId: json["event_sub_id"],
        guestId: json["guest_id"],
        date: DateTime.parse(json["date"]),
        rate: json["rate"],
        quantity: json["quantity"],
        total: json["total"],
        transactionId: json["transaction_id"],
        createdAt: DateTime.parse(json["created_at"]),
        uid: json["uid"],
        bookingUid: json["booking_uid"],
        updatedAt: DateTime.parse(json["updated_at"]),
        isPaid: json["is_paid"],
        addon: List<Addon>.from(json["addon"].map((x) => Addon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "event_id": eventId,
        "event_sub_id": eventSubId,
        "guest_id": guestId,
        "date": date.toIso8601String(),
        "rate": rate,
        "quantity": quantity,
        "total": total,
        "transaction_id": transactionId,
        "created_at": createdAt.toIso8601String(),
        "uid": uid,
        "booking_uid": bookingUid,
        "updated_at": updatedAt.toIso8601String(),
        "is_paid": isPaid,
        "addon": List<dynamic>.from(addon.map((x) => x.toJson())),
      };
}

class Addon {
  Addon({
    this.total,
    this.rate,
    this.quantity,
    this.name,
    this.id,
    this.baseRate,
    this.description,
    this.thumbnail,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.currency,
    this.priority,
    this.type,
  });

  String total;
  String rate;
  String quantity;
  String name;
  String id;
  String baseRate;
  String description;
  String thumbnail;
  String status;
  DateTime createdAt;
  DateTime updatedAt;
  String currency;
  String priority;
  String type;

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
        total: json["total"],
        rate: json["rate"],
        quantity: json["quantity"],
        name: json["name"],
        id: json["id"],
        baseRate: json["base_rate"],
        description: json["description"],
        thumbnail: json["thumbnail"],
        status: json["status"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        currency: json["currency"],
        priority: json["priority"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "rate": rate,
        "quantity": quantity,
        "name": name,
        "id": id,
        "base_rate": baseRate,
        "description": description,
        "thumbnail": thumbnail,
        "status": status,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "currency": currency,
        "priority": priority,
        "type": type,
      };
}

class Table {
  Table({
    this.id,
    this.guestId,
    this.date,
    this.finalRate,
    this.paymentId,
    this.category,
    this.unit,
    this.firstName,
    this.lastName,
    this.status,
    this.email,
    this.noOfGuest,
    this.addon,
  });

  String id;
  String guestId;
  DateTime date;
  String finalRate;
  String paymentId;
  String category;
  String unit;
  String firstName;
  String lastName;
  String status;
  String email;
  String noOfGuest;
  List<Addon> addon;

  factory Table.fromJson(Map<String, dynamic> json) => Table(
        id: json["id"],
        guestId: json["guest_id"],
        date: DateTime.parse(json["date"]),
        finalRate: json["final_rate"],
        paymentId: json["payment_id"],
        category: json["category"],
        unit: json["unit"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        status: json["status"],
        email: json["email"],
        noOfGuest: json["no_of_guest"],
        addon: List<Addon>.from(json["addon"].map((x) => Addon.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "guest_id": guestId,
        "date": date.toIso8601String(),
        "final_rate": finalRate,
        "payment_id": paymentId,
        "category": category,
        "unit": unit,
        "first_name": firstName,
        "last_name": lastName,
        "status": status,
        "email": email,
        "no_of_guest": noOfGuest,
        "addon": List<dynamic>.from(addon.map((x) => x.toJson())),
      };
}
