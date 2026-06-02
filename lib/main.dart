import 'package:flutter/material.dart'; //
import 'package:firebase_core/firebase_core.dart'; //
import 'firebase_options.dart'; //
import 'user_input_widget.dart'; //

void main() async { //
  // Đảm bảo các dịch vụ nền tảng được khởi tạo trước
  WidgetsFlutterBinding.ensureInitialized(); //

  try { //
    // Khởi tạo Firebase kết nối với dự án trên Web
    await Firebase.initializeApp( //
      options: DefaultFirebaseOptions.currentPlatform, //
    ); //
    debugPrint('Khởi tạo Firebase thành công! 🎉'); // Thay thế print thành debugPrint
  } catch (e) { //
    debugPrint('Lỗi khởi tạo Firebase: $e ❌'); // Thay thế print thành debugPrint
  } //

  runApp(const MyApp()); //
} //

class MyApp extends StatelessWidget { //
  const MyApp({super.key}); //

  @override
  Widget build(BuildContext context) { //
    return MaterialApp( //
      title: 'User Input', //
      debugShowCheckedModeBanner: false, // Tắt nhãn "Debug" màu đỏ ở góc màn hình
      theme: ThemeData( //
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo), //
        useMaterial3: true, //
      ), //
      home: const UserInputWidget(), //
    ); //
  } //
} //