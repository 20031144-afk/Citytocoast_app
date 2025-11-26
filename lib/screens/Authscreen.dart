import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:citytocoast_app/services/firestore_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool showLogin = true;
  String role = "parent";
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isAgreed = false;

  // Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Login controllers
  final TextEditingController _loginEmail = TextEditingController();
  final TextEditingController _loginPassword = TextEditingController();

  // Signup controllers
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _signupEmail = TextEditingController();
  final TextEditingController _signupPassword = TextEditingController();
  final TextEditingController _signupConfirm = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Tabs
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _tabButton("Log in", showLogin, () {
                  setState(() => showLogin = true);
                }),
                const SizedBox(width: 40),
                _tabButton("Sign up", !showLogin, () {
                  setState(() => showLogin = false);
                }),
              ],
            ),
            const SizedBox(height: 20),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: showLogin ? _buildLoginForm() : _buildSignupForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tab
  Widget _tabButton(String text, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 60,
            color: active ? Colors.black : Colors.transparent,
          ),
        ],
      ),
    );
  }

  // ---------------- LOGIN FORM ----------------
  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Your Email", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        TextField(
          controller: _loginEmail,
          decoration: InputDecoration(
            hintText: "Enter your email",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),

        const Text("Password", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 16),
        TextField(
          controller: _loginPassword,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            hintText: "Enter your password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),

        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            child: const Text("Forgot password?"),
          ),
        ),

        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _loginUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A78FF),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Log In", style: TextStyle(color: Colors.white)),
        ),

        const SizedBox(height: 25),

        // OLD UI DIVIDER + SOCIAL BUTTONS
        _dividerWithText("Or continue with"),
        const SizedBox(height: 20),

        Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.apple, color: Colors.black),
                label: const Text("Continue with Apple"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const FaIcon(FontAwesomeIcons.google, color: Colors.red),
                label: const Text("Continue with Google"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------- SIGNUP FORM ----------------
  Widget _buildSignupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: const Text("Parent/Pet Owner"),
                value: "parent",
                groupValue: role,
                onChanged: (val) => setState(() => role = val.toString()),
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: const Text("Sitter"),
                value: "sitter",
                groupValue: role,
                onChanged: (val) => setState(() => role = val.toString()),
              ),
            ),
          ],
        ),

        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _firstName,
                decoration: InputDecoration(
                  labelText: "First Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _lastName,
                decoration: InputDecoration(
                  labelText: "Last Name",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _phone,
          decoration: InputDecoration(
            labelText: "Phone Number",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _signupEmail,
          decoration: InputDecoration(
            labelText: "Your Email",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _signupPassword,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: "Password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _signupConfirm,
          obscureText: _obscureConfirm,
          decoration: InputDecoration(
            labelText: "Confirm Password",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: IconButton(
              icon: Icon(_obscureConfirm ? Icons.visibility : Icons.visibility_off),
              onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Checkbox(
              value: _isAgreed,
              onChanged: (v) => setState(() => _isAgreed = v ?? false),
            ),
            const Expanded(
              child: Text.rich(
                TextSpan(text: "I agree to the ", children: [
                  TextSpan(text: "Terms of Service", style: TextStyle(color: Colors.blue)),
                  TextSpan(text: " and "),
                  TextSpan(text: "Privacy Policy", style: TextStyle(color: Colors.blue)),
                ]),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _signupUser,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5A78FF),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text("Sign Up", style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  Widget _dividerWithText(String text) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text, style: const TextStyle(color: Colors.grey)),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }

  // ---------------- FIREBASE LOGIC ----------------

  Future<void> _signupUser() async {
    if (_signupPassword.text != _signupConfirm.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _signupEmail.text.trim(),
        password: _signupPassword.text.trim(),
      );

      await _firestoreService.createUser(userCredential.user!.uid, {
        "firstName": _firstName.text.trim(),
        "lastName": _lastName.text.trim(),
        "phone": _phone.text.trim(),
        "email": _signupEmail.text.trim(),
        "role": role,
        "createdAt": FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Signup Successful!")),
      );

      Navigator.pushReplacementNamed(context, "/clientHome");

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Signup Failed: $e")),
      );
    }
  }

  Future<void> _loginUser() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _loginEmail.text.trim(),
        password: _loginPassword.text.trim(),
      );

      Navigator.pushReplacementNamed(context, '/clientHome');

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    }
  }
}
