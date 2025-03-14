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
                "ลืมรหัสผ่านใช่หรือไม่?",
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Column(
                children: [
                  Text(
                    'ระบุอีเมลของคุณแล้วเราจะส่งข้อความ\nช่วยรีเซ็ทรหัสผ่านของคุณ',
                    textAlign: TextAlign.center,
                  ),
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
                  return "กรุณาระบุอีเมล";
                }
                return null;
              },
              keyboardType: TextInputType.emailAddress,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 230,
            child: ElevatedButton(
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
                                content: Text(
                                  "✅ ส่งอีเมลรีเซ็ทรหัสผ่านเสร็จสิ้น",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                  ),
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                              ),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "❌ เกิดข้อผิดพลาด กรุณาลองใหม่",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                                backgroundColor:
                                    Theme.of(context).colorScheme.onError,
                              ),
                            );
                          } finally {
                            setState(() {
                              isSending = false;
                            });
                          }
                        }
                      },
              child:
                  isSending
                      ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          Text("กำลังดำเนินการ..."),
                        ],
                      )
                      : Text('ยืนยันการรีเซ็ท'),
            ),
          ),
        ],
      ),
    );
  }
}
