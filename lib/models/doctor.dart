class Doctor {
  String id;
  String name;
  String specialty;
  String availability;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.availability,
  });

  factory Doctor.fromMap(Map<String, dynamic> map) => Doctor(
        id: map['id'],
        name: map['name'],
        specialty: map['specialty'],
        availability: map['availability'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'specialty': specialty,
        'availability': availability,
      };
}
