import 'package:flutter/material.dart';
import 'user_input.dart'; // Đảm bảo import đúng tên file model viết thường
import 'firebase_service.dart'; // Import file service xử lý Firebase

class UserInputWidget extends StatefulWidget {
  const UserInputWidget({super.key});

  @override
  State<UserInputWidget> createState() => _UserInputWidgetState();
}

class _UserInputWidgetState extends State<UserInputWidget> {
  // Khởi tạo FirebaseService để gọi hàm lưu dữ liệu
  final FirebaseService _firebaseService = FirebaseService();

  // Các bộ điều khiển để lấy dữ liệu từ TextFormField
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  
  // Key để quản lý trạng thái và kiểm tra (validate) Form
  final _formKey = GlobalKey<FormState>();
  
  // Biến trạng thái để hiển thị vòng loading khi đang tương tác với Firebase
  bool _isLoading = false;

  @override
  void dispose() {
    // Hủy các controller khi không sử dụng để tránh rò rỉ bộ nhớ
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  // Hàm xử lý lưu dữ liệu bất đồng bộ
  Future<void> _submitData() async {
    // Kiểm tra tính hợp lệ của toàn bộ Form
    if (_formKey.currentState!.validate()) {
      // Ẩn bàn phím ảo ngay lập tức để cải thiện trải nghiệm người dùng (UX)
      FocusScope.of(context).unfocus();

      setState(() {
        _isLoading = true; // Bật trạng thái loading
      });

      // Thu thập dữ liệu từ giao diện và khởi tạo đối tượng UserInput
      final newUser = UserInput(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        age: int.parse(_ageController.text.trim()),
      );

      try {
        // Gọi hàm lưu vào Firestore
        await _firebaseService.saveUser(newUser);

        // Hiển thị thông báo thành công nếu widget vẫn còn mount trên cây giao diện
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Đã lưu dữ liệu lên Firestore thành công! 🎉'),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
          
          // Xóa trắng các ô nhập liệu sau khi lưu thành công
          _nameController.clear();
          _emailController.clear();
          _ageController.clear();
        }
      } catch (e) {
        // Hiển thị thông báo lỗi nếu xảy ra sự cố (mất mạng, sai quyền Firestore...)
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Lỗi khi lưu dữ liệu: $e ❌'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      } finally {
        // Tắt trạng thái loading dù quá trình lưu thành công hay thất bại
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập thông tin người dùng'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Ô nhập Họ và tên
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                enabled: !_isLoading, // Khóa ô nhập khi đang loading để tránh chỉnh sửa
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Ô nhập Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                enabled: !_isLoading, // Khóa ô nhập khi đang loading
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập Email';
                  }
                  // Kiểm tra định dạng Email hợp lệ bằng Biểu thức chính quy (Regex)
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'Vui lòng nhập email đúng định dạng (VD: abc@gmail.com)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              
              // Ô nhập Tuổi
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Tuổi',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.cake),
                ),
                keyboardType: TextInputType.number,
                enabled: !_isLoading, // Khóa ô nhập khi đang loading
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tuổi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Tuổi phải là một số hợp lệ';
                  }
                  if (int.parse(value) <= 0) {
                    return 'Tuổi nhập vào phải lớn hơn 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),
              
              // Khu vực nút nhấn: Hiển thị vòng xoay loading hoặc Nút xác nhận
              _isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : ElevatedButton(
                      onPressed: _submitData,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Xác nhận thông tin',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}