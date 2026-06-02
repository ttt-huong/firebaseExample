import 'package:flutter/material.dart';
import 'UserInput.dart'; // Import file model ở Bước 1 vào đây

class UserInputWidget extends StatefulWidget {
  const UserInputWidget({super.key});

  @override
  State<UserInputWidget> createState() => _UserInputWidgetState();
}

class _UserInputWidgetState extends State<UserInputWidget> {
  // Tạo các bộ điều khiển để lấy dữ liệu từ TextField
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _ageController = TextEditingController();
  
  // Key để quản lý trạng thái và validate Form
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Hủy các controller khi không sử dụng để tránh rò rỉ bộ nhớ
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _submitData() {
    if (_formKey.currentState!.validate()) {
      // Thu thập dữ liệu từ giao diện và khởi tạo đối tượng UserInput
      final newUser = UserInput(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        age: int.parse(_ageController.text.trim()),
      );

      // Tạm thời in ra màn hình console để kiểm tra dữ liệu ở Bước 2
      print('User created: ${newUser.name}, ${newUser.email}, ${newUser.age}');
      
      // TODO: Ở Bước 3 chúng ta sẽ gọi hàm lưu vào Firebase tại đây
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nhập thông tin người dùng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Ô nhập tên
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              // Ô nhập Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập Email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              
              // Ô nhập tuổi
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Tuổi'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tuổi';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Tuổi phải là một số hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              
              // Nút nhấn để gửi dữ liệu
              ElevatedButton(
                onPressed: _submitData,
                child: const Text('Xác nhận thông tin'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}