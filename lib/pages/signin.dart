import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firestore_demo/pages/forgot_password.dart';
import 'package:firestore_demo/pages/home_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firestore_demo/pages/signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String email = "", password = "";
  bool _isPasswordVisible = false;

  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAnalytics.instance.logEvent(
        name: "login",
        parameters: {
          "email": email,
        },
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text(
          "Đăng nhập thành công!",
          style: TextStyle(fontSize: 20.0),
        ),
      ));
    } on FirebaseAuthException catch (e) {
      String errorMessage = "";

      Navigator.pop(context);

      switch (e.code) {
        case 'invalid-credential':
          errorMessage = "Sai thông tin tài khoản hoặc mật khẩu";
          break;
        case 'invalid-email':
          errorMessage = "Email không hợp lệ. Vui lòng kiểm tra định dạng.";
          break;
        case 'user-disabled':
          errorMessage =
              "Tài khoản đã bị vô hiệu hóa. Hãy liên hệ với quản trị viên.";
          break;
        case 'too-many-requests':
          errorMessage =
              "Quá nhiều yêu cầu đăng nhập. Vui lòng thử lại sau vài phút.";
          break;
        case 'operation-not-allowed':
          errorMessage =
              "Chức năng đăng nhập bằng email và mật khẩu chưa được bật.";
          break;
        default:
          errorMessage = "Đã xảy ra lỗi không xác định: ${e.message}";
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orangeAccent,
        content: Text(
          errorMessage,
          style: const TextStyle(fontSize: 20.0),
        ),
      ));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Đã xảy ra lỗi: $e",
          style: const TextStyle(fontSize: 20.0),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(top: 30.0),
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color.fromARGB(255, 73, 49, 228),
          Color.fromARGB(255, 130, 45, 241),
          Color.fromARGB(255, 221, 52, 251)
        ], begin: Alignment.topLeft, end: Alignment.topRight)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                "Hello\nPlease Login",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 35.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0))),
                child: Form(
                  key: _formkey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(
                            color: Color.fromARGB(255, 36, 208, 231),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Email';
                          }
                          return null;
                        },
                        controller: emailcontroller,
                        decoration: const InputDecoration(
                            hintText: "Enter your Email",
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              size: 35.0,
                            )),
                      ),
                      const SizedBox(height: 20.0),
                      const Text(
                        "Password",
                        style: TextStyle(
                            color: Color.fromARGB(255, 36, 208, 231),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Passsword';
                          }
                          return null;
                        },
                        controller: passwordcontroller,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Enter your Password",
                          prefixIcon: const Icon(
                            Icons.password_outlined,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPassword()));
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 184, 13, 56),
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: GestureDetector(
                          onTap: () async {
                            if (_formkey.currentState!.validate()) {
                              email = emailcontroller.text;
                              password = passwordcontroller.text;
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              );
                              await userLogin();
                            }
                          },
                          child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 35, 14, 220),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: Text(
                                "SIGN IN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUp()));
                                },
                                child: const Text(
                                  "You don't have account?Register now",
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
