import 'package:hive/hive.dart';

part 'child.g.dart'; // Required for Hive serialization

@HiveType(typeId: 0) // Ensure typeId is unique
class Child extends HiveObject {
  // Extending HiveObject allows easy database operations
  @HiveField(0)
  int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String lastname;

  @HiveField(3)
  int age;

  @HiveField(4)
  String contactInfo;

  @HiveField(5)
  String address;

  Child({
    required this.id,
    required this.name,
    required this.lastname,
    required this.age,
    required this.contactInfo,
    required this.address,
    required String contact,
  });
}
