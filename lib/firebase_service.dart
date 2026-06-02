import 'package:cloud_firestore/cloud_firestore.dart';
import 'UserInput.dart'; // Import model ở Bước 1

class FirebaseService {
  // Lấy instance của Firestore
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Hàm lưu dữ liệu người dùng vào Firestore
  Future<void> saveUser(UserInput user) async {
    try {
      // Chỉ định chính xác Collection tên là 'Users'
      await _db.collection('Users').add(user.toMap());
      print('Đã lưu dữ liệu lên Firestore thành công!');
    } catch (e) {
      print('Lỗi khi lưu dữ liệu: $e');
      rethrow; // Đẩy lỗi ra ngoài để giao diện hiển thị nếu cần
    }
  }
}