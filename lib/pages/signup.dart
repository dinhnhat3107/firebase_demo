import 'package:firestore_demo/pages/signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool _isPasswordVisible = false;
  String email = "", password = "", name = "";
  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  registration() async {
    if (namecontroller.text.isNotEmpty && emailcontroller.text.isNotEmpty) {
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            )));

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const SignIn()));
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        Navigator.pop(context);
        switch (e.code) {
          case 'weak-password':
            errorMessage = "Mật khẩu quá yếu. Vui lòng nhập mật khẩu dài hơn.";
            break;
          case 'email-already-in-use':
            errorMessage = "Email đã tồn tại.";
            break;
          case 'invalid-email':
            errorMessage = "Email không hợp lệ.";
            break;
          case 'operation-not-allowed':
            errorMessage =
                "Chức năng đăng ký bằng email và mật khẩu chưa được bật.";
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
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text(
          "Vui lòng nhập đầy đủ thông tin.",
          style: TextStyle(fontSize: 20.0),
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
                "Hello\nCreate your account",
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
                        "Full Name",
                        style: TextStyle(
                            color: Color.fromARGB(255, 36, 208, 231),
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Name';
                          }
                          return null;
                        },
                        controller: namecontroller,
                        decoration: const InputDecoration(
                            hintText: "Enter your Name",
                            prefixIcon: Icon(
                              Icons.person_outlined,
                              size: 35.0,
                            )),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
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
                            return 'Please Enter Password';
                          }
                          return null;
                        },
                        controller: passwordcontroller,
                        obscureText:
                            !_isPasswordVisible, // Áp dụng tính năng ẩn/hiện
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
                      const SizedBox(height: 50.0),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0, right: 50.0),
                        child: GestureDetector(
                          onTap: () {
                            if (_formkey.currentState!.validate()) {
                              setState(() {
                                email = emailcontroller.text;
                                name = namecontroller.text;
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
                              });
                              registration();
                            }
                          },
                          child: Container(
                            height: 50.0,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [
                                    Color.fromARGB(255, 73, 49, 228),
                                    Color.fromARGB(255, 130, 45, 241),
                                    Color.fromARGB(255, 221, 52, 251)
                                  ],
                                  begin: Alignment.topRight,
                                  end: Alignment.topLeft),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: const Center(
                              child: Text(
                                "SIGN UP",
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const SignIn()));
                            },
                            child: const Text(
                              "Already have an account? Login now",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 13.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
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
