import 'package:flutter/material.dart';
import 'package:my_recipe/services/auth_service.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 15, right: 15),
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
                "ลืมรหัสผ่าน?",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Column(
                children: [
                  Text('กรอกอีเมลของคุณแล้วเราจะส่งข้อความ'),
                  Text('ช่วยรีเซ็ทรหัสผ่านของคุณ'),
                ],
              ),
            ),
            ResetForm(),
          ],
        ),
      ),
    );
  }
}

class ResetForm extends StatefulWidget {
  const ResetForm({super.key});
  @override
  State<ResetForm> createState() => _ResetFormState();
}

class _ResetFormState extends State<ResetForm> {
  final _auth = AuthServices();
  final _email = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isSending = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(128),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.symmetric(vertical: 50, horizontal: 25),
      child: Column(
        children: [
          Form(
            key: _formKey,
            child: TextFormField(
              controller: _email,
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
                prefixIcon: Icon(Icons.email_rounded),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains("@")) {
                  return "กรุณาระบุอีเมลล์";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed:
                isSending
                    ? null
                    : () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          isSending = true;
                        });
                        try {
                          await _auth.sendPasswordResetLink(_email.text);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("ส่งอีเมลรีเซ็ทรหัสผ่านเสร็จสิ้น"),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("เกิดข้อผิดพลาด กรุณาลองใหม่")),
                          );
                        } finally {
                          setState(() {
                            isSending = false; 
                          });
                          }
                      }
                    },
            child: isSending
                  ? CircularProgressIndicator(strokeWidth: 3,)
                  : Text('ยืนยัน'),
          ),
        ],
      ),
    );
  }
}
