import 'package:flutter/material.dart';
import 'package:my_recipe/services/auth_service.dart';
import 'package:my_recipe/widgets/navigation_bar/top_navbar.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(title: "", action: []),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Wrap(
          runSpacing: 10, // Spaces in horizontal-axis
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset("assets/images/logo.png", width: 170)],
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                "🍳​ ลงทะเบียน",
                style: Theme.of(
                  context,
                ).textTheme.headlineLarge?.copyWith(color: Colors.black),
              ),
            ),
            _RegisterForm(),
          ],
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm();

  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  // Global Key for Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextFormField Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Obsecured the Passwords: (Default) invisible passwords
  bool _isObsecurePassword = true;
  bool _isObsecureConfirmPassword = true;

  // CheckBoxListTile: (Default) not checked the box
  bool _isAcceptedTheConditions = false;

  // AuthServices Instance
  final AuthServices _authServices = AuthServices();

  // Check if registering
  bool _isRegistering = false;

  @override
  void dispose() {
    // Remove the controllers from memory if not use anymore.
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(100),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Wrap(
              runSpacing: 10,
              children: <Widget>[
                TextFormField(
                  controller: _usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณาระบุชื่อผู้ใช้งาน";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "ชื่อผู้ใช้งาน",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 3,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    prefixIcon: Icon(
                      Icons.person_2_rounded,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains("@")) {
                      return "กรุณาระบุอีเมล";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "อีเมล",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 3,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    prefixIcon: Icon(Icons.email_rounded, color: Colors.black),
                  ),
                ),
                TextFormField(
                  obscureText: _isObsecurePassword,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณาระบุรหัสผ่าน";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "รหัสผ่าน",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 3,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock_rounded, color: Colors.black),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(
                          () => _isObsecurePassword = !_isObsecurePassword,
                        );
                      },
                      icon: Icon(
                        _isObsecurePassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  obscureText: _isObsecureConfirmPassword,
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณายืีนยันรหัสผ่าน";
                    }
                    if (value != _passwordController.text) {
                      return "รหัสผ่านไม่ตรงกัน";
                    }
                    return null;
                  },
                  style: TextStyle(color: Colors.black),
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "ยืนยันรหัสผ่าน",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        width: 3,
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock_rounded, color: Colors.black),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(
                          () =>
                              _isObsecureConfirmPassword =
                                  !_isObsecureConfirmPassword,
                        );
                      },
                      icon: Icon(
                        _isObsecureConfirmPassword
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: RichText(
                    text: TextSpan(
                      text: "ข้าพเจ้าได้อ่านและรับทราบ ",
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.black),
                      children: [
                        TextSpan(
                          text: "นโยบายความเป็นส่วนตัว",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                        TextSpan(
                          text: " และ ",
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.black),
                        ),
                        TextSpan(
                          text: "ข้อกำหนดการใช้บริการ",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                        TextSpan(
                          text: " ทั้งหมดเรียบร้อยแล้ว",
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall?.copyWith(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  value: _isAcceptedTheConditions,
                  onChanged:
                      (value) => setState(
                        () =>
                            _isAcceptedTheConditions =
                                !_isAcceptedTheConditions,
                      ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 270,
                      child: ElevatedButton(
                        onPressed:
                            _isRegistering
                                ? null
                                : () async {
                                  if (_formKey.currentState!.validate()) {
                                    ScaffoldMessenger.of(
                                      context,
                                    ).clearSnackBars();
                                    if (!_isAcceptedTheConditions) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "🖋️ กรุณายอมรับข้อกำหนดการใช้บริการ",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                        ),
                                      );
                                      return;
                                    }
                                    setState(() {
                                      _isRegistering = true;
                                    });

                                    final String? errorMessage =
                                        await _authServices.registerWithManual(
                                          _usernameController.text,
                                          _emailController.text,
                                          _passwordController.text,
                                        );

                                    setState(() {
                                      _isRegistering = false;
                                    });

                                    if (errorMessage != null) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            errorMessage,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          backgroundColor:
                                              Theme.of(
                                                context,
                                              ).colorScheme.error,
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "✅ ลงทะเบียนสำเร็จ เข้าสู่ระบบเพื่อใช้งานได้ทันที",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          backgroundColor: Colors.white,
                                        ),
                                      );
                                      _usernameController.clear();
                                      _emailController.clear();
                                      _passwordController.clear();
                                      _confirmPasswordController.clear();
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                        child:
                            _isRegistering
                                ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                      ),
                                    ),
                                    Text("กำลังลงทะเบียน..."),
                                  ],
                                )
                                : Text("ยืนยันการลงทะเบียน"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
