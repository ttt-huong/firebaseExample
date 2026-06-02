class UserInput {
  final String? id; // Dùng để lưu document ID từ Firestore nếu cần
  final String name;
  final String email;
  final int age;

  // Constructor
  UserInput({
    this.id,
    required this.name,
    required this.email,
    required this.age,
  });

  // Hàm chuyển đổi đối tượng thành Map (JSON) để đẩy lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'age': age,
    };
  }

  // Hàm khởi tạo đối tượng từ dữ liệu lấy về từ Firestore (nếu cần sau này)
  factory UserInput.fromMap(Map<String, dynamic> map, String documentId) {
    return UserInput(
      id: documentId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      age: map['age'] ?? 0,
    );
  }
}