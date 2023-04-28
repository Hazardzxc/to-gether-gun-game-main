import 'package:cloud_firestore/cloud_firestore.dart';

class Rooms {
  final int? roomId;
  final String? createBy;
  final String? password;
  final bool? capital;
  final int? status;
  final Map<String, dynamic>? member;

  Rooms({
    this.roomId,
    this.createBy,
    this.password,
    this.capital,
    this.status,
    this.member,
  });

  factory Rooms.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Rooms(
      roomId: data?['room_id'],
      createBy: data?['create_by'],
      password: data?['password'],
      capital: data?['capital'],
      status: data?['status'],
      member: data?['member'] as Map<String, dynamic>,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (roomId != null) "roomId": roomId,
      if (createBy != null) "createBy": createBy,
      if (password != null) "password": password,
      if (capital != null) "capital": capital,
      if (status != null) "status": status,
      if (member != null) "member": member,
    };
  }
}
