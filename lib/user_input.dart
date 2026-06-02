class UserInput {
  final String? id; // Dung de luu document ID tu Firestore neu can
  final String name;
  final String email;
  final int age;

  UserInput({
    this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'age': age,
    };
  }

  factory UserInput.fromMap(Map<String, dynamic> map, String documentId) {
    return UserInput(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? 0,
    );
  }
}
