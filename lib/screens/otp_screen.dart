import 'package:flutter/material.dart';
import '../../services/firebase_auth_service.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;

  const OTPScreen({
    super.key,
    required this.verificationId,
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController otpController = TextEditingController();

  final FirebaseAuthService auth = FirebaseAuthService();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            TextField(
              controller: otpController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Enter OTP",
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(

              onPressed: () async {

                setState(() {
                  loading = true;
                });

                bool success = await auth.verifyOtp(
                  verificationId: widget.verificationId,
                  otp: otpController.text.trim(),
                );

                setState(() {
                  loading = false;
                });

                if (!mounted) return;

                if (success) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Invalid OTP"),
                    ),
                  );
                }
              },

              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Verify"),
            )
          ],
        ),
      ),
    );
  }
}