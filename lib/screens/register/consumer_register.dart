import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../farmer_login/consumer_login.dart';
import '../../services/firebase_auth_service.dart';
import '../otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_api_service.dart';

class RegisterPage extends StatefulWidget {
  final String userType;
  const RegisterPage({
    super.key,
    required this.userType,
});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuthService firebaseAuth = FirebaseAuthService();
  final AuthApiService api = AuthApiService();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final villageController = TextEditingController();
  final talukController = TextEditingController();
  final districtController = TextEditingController();
  final pincodeController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  late String userType;
  String phoneNumber = "";
  @override
  void initState()
  {
    super.initState();
    userType =widget.userType;
  }


  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Agri Registration",
          style: TextStyle(
            color: Colors.white,
          ),
        ),

        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/farm_bg.jpg"),
            fit: BoxFit.cover,

          ),
        ),
        child: Stack(
          children: [
            Container(
              color: Colors.black.withOpacity(0.35),
            ),

// Background Agriculture Icon
            Positioned(
              top: 150,
              left: -30,
              child: Opacity(
                opacity: 0.08,
                child: Icon(
                  Icons.agriculture,
                  size: 300,
                  color: Colors.green,
                ),
              ),
            ),

            Positioned(
              bottom: 100,
              right: -30,
              child: Opacity(
                opacity: 0.08,
                child: Icon(
                  Icons.eco,
                  size: 250,
                  color: Colors.green,
                ),
              ),
            ),

            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Column(
                        children: [
                          Icon(
                            Icons.agriculture,
                            size: 70,
                            color: Colors.green,
                          ),
                          SizedBox(height: 10),
                          Text(
                            "AgriConnect",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),

                    const Text(
                      "Farmer & Consumer Registration",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 25),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Register As",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                userType = "Farmer";
                              });
                            },
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: userType == "Farmer"
                                    ? Colors.green.shade50
                                    : Colors.white,
                                border: Border.all(
                                  color: userType == "Farmer"
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  const Icon(
                                    Icons.agriculture,
                                    color: Colors.green,
                                    size: 35,
                                  ),

                                  const SizedBox(width: 10),

                                  Flexible(
                                    child: Text(
                                    "Farmer",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: userType == "Farmer"
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ),
                                  ),

                                  const SizedBox(width: 10),

                                  Icon(
                                    userType == "Farmer"
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                userType = "Consumer";
                              });
                            },
                            child: Container(
                              height: 90,
                              decoration: BoxDecoration(
                                color: userType == "Consumer"
                                    ? Colors.green.shade50
                                    : Colors.white,
                                border: Border.all(
                                  color: userType == "Consumer"
                                      ? Colors.green
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  const Icon(
                                    Icons.store,
                                    color: Colors.green,
                                    size: 30,
                                  ),

                                  const SizedBox(width: 8),

                                  Text(
                                    "Consumer",
                                    overflow: TextOverflow.ellipsis,

                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: userType == "Consumer"
                                          ? Colors.green
                                          : Colors.black,
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  Icon(
                                    userType == "Consumer"
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: Colors.green,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 5, bottom: 5),
                          child: Text(
                            "Full Name",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),
                            prefixIcon: const Icon(Icons.person),
                            hintText: "Enter Full Name",
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Phone Number",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 5),

                    IntlPhoneField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white.withOpacity(0.9),

                        hintText: "Enter Phone Number",

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Colors.green,
                            width: 2,
                          ),
                        ),
                      ),

                      initialCountryCode: 'IN',

                      onChanged: (phone) {
                        phoneNumber = phone.completeNumber;
                      },
                    ),

                    const SizedBox(height: 15),


                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Village",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 5),

                              buildTextField(
                                controller: villageController,
                                label: "Enter Village",
                                icon: Icons.home_work_outlined,


                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Taluk",

                                style: TextStyle(

                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              buildTextField(
                                controller: talukController,
                                label: "Enter taluk",
                                icon: Icons.location_city_outlined,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "District",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              buildTextField(
                                controller: districtController,
                                label: "Enter District",
                                icon: Icons.location_on_outlined,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pincode",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              buildTextField(
                                controller: pincodeController,
                                label: "Enter Pincode",
                                icon: Icons.pin_drop_outlined,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        TextFormField(
                          controller: passwordController,
                          obscureText: _isPasswordHidden,
                          decoration: InputDecoration(
                            hintText: "Enter Password",
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),

                            prefixIcon: const Icon(Icons.lock_outline),

                            suffixIcon: IconButton(
                              icon: Icon(
                                _isPasswordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordHidden = !_isPasswordHidden;
                                });
                              },
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),


                    const SizedBox(height: 5),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Confirm Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: _isConfirmPasswordHidden,

                          decoration: InputDecoration(
                            hintText: "Enter Confirm Password",
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.9),

                            prefixIcon: const Icon(Icons.lock_reset),

                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordHidden =
                                  !_isConfirmPasswordHidden;
                                });
                              },
                            ),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Confirm Password is required";
                            }

                            if (value != passwordController.text) {
                              return "Passwords do not match";
                            }

                            return null;
                          },
                        ),
                      ],
                    ),


                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),

                        onPressed: () async {

                          await firebaseAuth.sendOtp(

                            phoneNumber: phoneNumber,

                            codeSent: (String verificationId) async {

                              bool? verified = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => OTPScreen(
                                    verificationId: verificationId,
                                  ),
                                ),
                              );

                              if (verified == true) {

                                String token = (await FirebaseAuth.instance.currentUser!.getIdToken())!;

                                await api.register(

                                  token: token,

                                  name: nameController.text,

                                  role: "consumer",

                                );

                                if (!mounted) return;

                                ScaffoldMessenger.of(context).showSnackBar(

                                  const SnackBar(

                                    content: Text("Registration Successful"),

                                  ),

                                );

                              }

                            },

                            failed: (message) {

                              ScaffoldMessenger.of(context).showSnackBar(

                                SnackBar(content: Text(message)),

                              );

                            },

                          );

                        },
                        child: const Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ConsumerLoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,

                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,

        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label is required";
          }

          if (label == "Password" && value.length < 6) {
            return "Password must be at least 6 characters";
          }

          if (label == "Confirm Password" &&
              value != passwordController.text) {
            return "Passwords do not match";
          }

          return null;
        },
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white.withOpacity(0.9),

          prefixIcon: Icon(
            icon,
            color: Colors.green,
          ),

          hintText: label,

          labelStyle: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(
              color: Colors.green.shade300,
              width: 2,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              color: Colors.green,
              width: 3,
            ),
          ),
        ),
      ),
    );
  }
}
