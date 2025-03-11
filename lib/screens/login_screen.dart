import 'package:flutter/material.dart';
import 'package:my_recipe/screens/register_screen.dart';
import 'package:my_recipe/services/auth_services.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.only(top: 115, left: 15, right: 15),
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
                "🍳​ เข้าสู่ระบบ",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            _LoginForm(),
          ],
        ),
      ),
    );
  }
}

class _LoginForm extends StatefulWidget {
  const _LoginForm();

  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  // Global Key for Form
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // TextFormField Controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Obsecured the Passwords: (Default) invisible passwords
  bool _isObsecureText = true;

  final AuthServices _authServices = AuthServices();

  @override
  void dispose() {
    // Remove the controllers from memory if not use anymore.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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
                  obscureText: _isObsecureText,
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
                        setState(() => _isObsecureText = !_isObsecureText);
                      },
                      icon: Icon(
                        _isObsecureText
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "ยังไม่มีบัญชีใช่หรือไม่?",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "กดเพื่อสมัครบัญชี",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.deepPurple,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.deepPurple,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          AuthServices().signInWithManual(
                            _emailController.text,
                            _passwordController.text,
                          );
                        }
                      },
                      child: Text("เข้าสู่ระบบ"),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text("หรือ", style: Theme.of(context).textTheme.bodyMedium),
          // Firebase Google & Facebook LoginButton //
          _SignInButton(
            title: "เข้าสู่ระบบด้วย Google",
            titleColor: Colors.black,
            backgroundColor: Colors.white,
            onSignIn: () {
              _authServices.signInWithGoogle();
            },
          ),
          _SignInButton(
            title: "เข้าสู่ระบบด้วย Apple",
            titleColor: Colors.white,
            backgroundColor: Colors.black,
            onSignIn: () {},
          ),
          _SignInButton(
            title: "เข้าสู่ระบบด้วย Facebook",
            titleColor: Colors.white,
            backgroundColor: Colors.lightBlue,
            onSignIn: () {},
          ),
        ],
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    required String title,
    required Color titleColor,
    required Color backgroundColor,
    required void Function() onSignIn,
  }) : _title = title,
       _titleColor = titleColor,
       _backgroundColor = backgroundColor,
       _onSignIn = onSignIn;

  final String _title;
  final Color _titleColor;
  final Color _backgroundColor;
  final void Function() _onSignIn;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _onSignIn,
      style: ElevatedButton.styleFrom(backgroundColor: _backgroundColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Icon(Icons.abc, size: 30),
            SizedBox(width: 10),
            Text(_title, style: TextStyle(color: _titleColor)),
          ],
        ),
      ),
    );
  }
}
