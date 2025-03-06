import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.navigate_before_rounded, size: 35),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Wrap(
          runSpacing: 10,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Image.asset("assets/images/logo.png", width: 170)],
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                "🍳​ ลงทะเบียน",
                style: Theme.of(context).textTheme.headlineLarge,
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isObsecurePassword = true;
  bool _isObsecureConfirmPassword = true;
  bool _isAcceptedTheConditions = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(128),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
      child: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Wrap(
              runSpacing: 10,
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains("@")) {
                      return "กรุณาระบุอีเมลล์";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    hintText: "อีเมลล์",
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
                    prefixIcon: Icon(Icons.email_rounded),
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
                    prefixIcon: Icon(Icons.lock_rounded),
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
                    prefixIcon: Icon(Icons.lock_rounded),
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
                      ),
                    ),
                  ),
                ),
                CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: RichText(
                    text: TextSpan(
                      text: "ข้าพเจ้าได้อ่านและรับทราบ ",
                      style: Theme.of(context).textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: "นโยบายความเป็นส่วนตัว",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                        TextSpan(
                          text: " และ ",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextSpan(
                          text: "ข้อกำหนดการใช้บริการ",
                          style: TextStyle(color: Colors.deepPurple),
                        ),
                        TextSpan(
                          text: " ทั้งหมดเรียบร้อยแล้ว",
                          style: Theme.of(context).textTheme.bodySmall,
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
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _isAcceptedTheConditions) {
                          print("Register Sucessfully!");
                        }
                      },
                      child: Text("ยืนยันการลงทะเบียน"),
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
