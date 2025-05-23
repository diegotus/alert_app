// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class NotificationModel {
  DateTime date;
  String title;
  String body;
  String? description;
  NotificationModel({
    DateTime? date,
    this.description,
    required this.title,
    required this.body,
  }) : date = date ?? DateTime.now();

  NotificationModel copyWith({
    DateTime? date,
    String? title,
    String? body,
    String? description,
  }) {
    return NotificationModel(
      date: date ?? this.date,
      title: title ?? this.title,
      body: body ?? this.body,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'date': date.millisecondsSinceEpoch,
      'title': title,
      'body': body,
      'description': description,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      date:
          map['date'] == null
              ? DateTime.now()
              : DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      title: map['title'] as String,
      body: map['body'] as String,
      description: map['description'],
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationModel.fromJson(String source) =>
      NotificationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'NotificationModel(date: $date, title: $title, body: $body, description: $description)';

  @override
  bool operator ==(covariant NotificationModel other) {
    if (identical(this, other)) return true;

    return other.date == date &&
        other.title == title &&
        other.body == body &&
        other.description == description;
  }

  @override
  int get hashCode =>
      date.hashCode ^ title.hashCode ^ body.hashCode ^ description.hashCode;
}
