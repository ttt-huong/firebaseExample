import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'user_input.dart'; 

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveUser(UserInput user) async {
    try {
      // Chỉ định chính xác Collection tên là 'Users' và thêm dữ liệu dạng Map
      DocumentReference docRef = await _db.collection('Users').add(user.toMap());
      
      // In ra ID của document vừa tạo để tiện theo dõi khi debug
      print('Đã lưu dữ liệu lên Firestore thành công! Document ID: ${docRef.id}');
    } catch (e) {
      // In chi tiết lỗi ra console của nhà phát triểnz
      print('Lỗi xảy ra tại FirebaseService.saveUser: $e');
      
      // Đẩy lỗi ra ngoài để phía Giao diện (UI) có thể catch và hiển thị SnackBar thông báo cho người dùng
      rethrow; 
    }
  }
}