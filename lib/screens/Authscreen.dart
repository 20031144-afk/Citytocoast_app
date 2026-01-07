import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:citytocoast_app/services/auth_service.dart';
import 'package:citytocoast_app/services/firestore_service.dart';
import 'package:citytocoast_app/widgets/auth_widgets.dart';

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
  bool _isLoading = false;

  // Services
  final AuthService _authService = AuthService();
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

  final RegExp _emailRegex = RegExp(
    r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
  ); // simple email check

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  const AuthHeader(
                    title: "Welcome back",
                    subtitle: "Sign in to continue or create a new account",
                  ),
                  const SizedBox(height: 20),
                  AuthCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _tabButton("Log in", showLogin, () {
                              setState(() => showLogin = true);
                            }),
                            const SizedBox(width: 24),
                            _tabButton("Sign up", !showLogin, () {
                              setState(() => showLogin = false);
                            }),
                          ],
                        ),
                        const SizedBox(height: 20),
                        showLogin ? _buildLoginForm() : _buildSignupForm(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // LOADING OVERLAY
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  // ---------------- TABS ----------------
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
              color: active
                  ? Theme.of(context).colorScheme.onBackground
                  : Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 60,
            color: active ? const Color(0xFF6A5AE0) : Colors.transparent,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // LOGIN FORM
  // ------------------------------------------------------------

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Sign in",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 6),
        Text(
          "Access your account with your email and password.",
          style: TextStyle(
            color: const Color.fromARGB(255, 145, 136, 136),
            fontSize: 13,
          ),
        ),

        const SizedBox(height: 20),
        TextFormField(
          controller: _loginEmail,
          decoration: _inputDecoration(
            hint: "Enter your email",
            label: "Your Email",
            icon: Icons.email_outlined,
          ),
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 16),
        TextFormField(
          controller: _loginPassword,
          obscureText: _obscurePassword,
          decoration: _inputDecoration(
            hint: "Enter your password",
            label: "Password",
            icon: Icons.lock_outline,
            suffix: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),

        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _promptPasswordReset,
            child: const Text(
              "Forgot password?",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),

        const SizedBox(height: 20),
        PrimaryButton(
          text: "Log In",
          onPressed: _loginUser,
          loading: _isLoading,
        ),

        const SizedBox(height: 25),
        _dividerWithText("Or continue with"),
        const SizedBox(height: 20),

        Column(
          children: [
            _socialButton(
              "Continue with Apple",
              const FaIcon(FontAwesomeIcons.apple, color: Colors.black),
              _comingSoon,
            ),
            const SizedBox(height: 12),
            _socialButton(
              "Continue with Google",
              const FaIcon(FontAwesomeIcons.google, color: Colors.red),
              _comingSoon,
            ),
          ],
        ),
      ],
    );
  }

  Widget _socialButton(String text, Widget icon, VoidCallback onTap) {
    return SocialButton(text: text, icon: icon, onPressed: onTap);
  }

  // ------------------------------------------------------------
  // SIGNUP FORM
  // ------------------------------------------------------------

  Widget _buildSignupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "Create account",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 6),
        Text(
          "Fill in your details to get started.",
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),

        const SizedBox(height: 16),
        // Role Selection
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: const Text("Parent"),
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
              child: TextFormField(
                controller: _firstName,
                decoration: _inputDecoration(
                  label: "First Name",
                  hint: "First name",
                  icon: Icons.person_outline,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _lastName,
                decoration: _inputDecoration(
                  label: "Last Name",
                  hint: "Last name",
                  icon: Icons.person_outline,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        TextFormField(
          controller: _phone,
          decoration: _inputDecoration(
            label: "Phone Number",
            hint: "Enter your phone",
            icon: Icons.phone_outlined,
          ),
          keyboardType: TextInputType.phone,
        ),

        const SizedBox(height: 16),
        TextFormField(
          controller: _signupEmail,
          decoration: _inputDecoration(
            label: "Your Email",
            hint: "Enter your email",
            icon: Icons.email_outlined,
          ),
          keyboardType: TextInputType.emailAddress,
        ),

        const SizedBox(height: 16),
        TextFormField(
          controller: _signupPassword,
          obscureText: _obscurePassword,
          decoration: _inputDecoration(
            label: "Password",
            hint: "Enter your password",
            icon: Icons.lock_outline,
            suffix: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),

        const SizedBox(height: 16),
        TextFormField(
          controller: _signupConfirm,
          obscureText: _obscureConfirm,
          decoration: _inputDecoration(
            label: "Confirm Password",
            hint: "Re-enter your password",
            icon: Icons.lock_outline,
            suffix: IconButton(
              icon: Icon(
                _obscureConfirm ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () =>
                  setState(() => _obscureConfirm = !_obscureConfirm),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Terms Checkbox
        Row(
          children: [
            Checkbox(
              value: _isAgreed,
              onChanged: (v) => setState(() => _isAgreed = v ?? false),
            ),
            const Expanded(
              child: Text.rich(
                TextSpan(
                  text: "I agree to the ",
                  children: [
                    TextSpan(
                      text: "Terms of Service",
                      style: TextStyle(color: Colors.blue),
                    ),
                    TextSpan(text: " and "),
                    TextSpan(
                      text: "Privacy Policy",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),
        PrimaryButton(
          text: "Sign Up",
          onPressed: _signupUser,
          loading: _isLoading,
        ),
      ],
    );
  }

  Widget _dividerWithText(String text) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.grey.shade300)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(text, style: const TextStyle(color: Colors.grey)),
        ),
        Expanded(child: Divider(color: Colors.grey.shade300)),
      ],
    );
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _promptPasswordReset() async {
    final controller = TextEditingController(text: _loginEmail.text.trim());
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Reset password"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Email",
            hintText: "Enter your account email",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
          onPressed: () async {
            final email = controller.text.trim();
            if (email.isEmpty || !_emailRegex.hasMatch(email)) {
              _showSnack("Please enter a valid email.");
              return;
            }
            Navigator.of(ctx).pop();
            try {
              await FirebaseAuth.instance.sendPasswordResetEmail(
                email: email,
              );
              if (!mounted) return;
              _showSnack("Password reset email sent.");
            } on FirebaseAuthException catch (e) {
              if (!mounted) return;
              final msg = switch (e.code) {
                "invalid-email" => "Please enter a valid email address.",
                "user-not-found" => "No account found for that email.",
                "network-request-failed" =>
                  "Network error. Check your connection.",
                  _ => "Couldn't send reset email. Please try again.",
                };
              _showSnack(msg);
            } catch (_) {
              if (!mounted) return;
              _showSnack("Couldn't send reset email. Please try again.");
            }
          },
          child: const Text("Send"),
        ),
        ],
      ),
    );
  }

  void _comingSoon() {
    _showSnack("Coming soon");
  }

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.withOpacity(0.08),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF6A5AE0)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  // ------------------------------------------------------------
  // LOGIN FUNCTION
  // ------------------------------------------------------------

  Future<void> _loginUser() async {
    final email = _loginEmail.text.trim();
    final password = _loginPassword.text;

    if (email.isEmpty || password.isEmpty || !_emailRegex.hasMatch(email)) {
      _showSnack("Please fill in email and password.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _authService.login(email, password);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/clientHome');
    } on FirebaseAuthException catch (e) {
      final message = switch (e.code) {
        "invalid-email" => "Please enter a valid email address.",
        "user-not-found" => "No account found for that email.",
        "wrong-password" => "Incorrect password. Please try again.",
        "too-many-requests" => "Too many attempts. Try again in a few minutes.",
        "network-request-failed" =>
          "Network error. Check your connection and try again.",
        _ => "Login failed. Please try again.",
      };
      _showSnack(message);
    } catch (_) {
      _showSnack("Login failed. Please try again.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ------------------------------------------------------------
  // SIGNUP FUNCTION
  // ------------------------------------------------------------

  Future<void> _signupUser() async {
    if (_firstName.text.trim().isEmpty ||
        _lastName.text.trim().isEmpty ||
        _phone.text.trim().isEmpty ||
        _signupEmail.text.trim().isEmpty ||
        _signupPassword.text.isEmpty ||
        _signupConfirm.text.isEmpty) {
      _showSnack("Please fill in all required fields.");
      return;
    }

    if (_signupPassword.text != _signupConfirm.text) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Passwords do not match")));
      return;
    }

    if (!_isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You must agree to the Terms & Privacy Policy"),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userCredential = await _authService.signup(
        _signupEmail.text.trim(),
        _signupPassword.text.trim(),
      );

      final String uid = userCredential.user!.uid;

      // Save user to Firestore with full required fields
      await _firestoreService.createUser(uid, {
        "firstName": _firstName.text.trim(),
        "lastName": _lastName.text.trim(),
        "email": _signupEmail.text.trim(),
        "phoneNumber": _phone.text.trim(),
        "role": role, // Make sure 'role' is defined
        "termsAccepted": _isAgreed, // store as boolean
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Signup Successful!")));

      setState(() => showLogin = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Signup Failed: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
