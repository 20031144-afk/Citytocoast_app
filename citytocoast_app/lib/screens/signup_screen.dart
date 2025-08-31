import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const route = '/signup';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _userType = "Client";
  bool _agree = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background
          Image.asset('assets/images/background1.jpg', fit: BoxFit.cover),
          Container(
            color: Colors.black.withOpacity(0.4), // Dark overlay
          ),
          // Form
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 80),
                const Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Sign up to find trusted care or offer your services",
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                // User Type Toggle
                ToggleButtons(
                  borderRadius: BorderRadius.circular(12),
                  selectedColor: Colors.white,
                  fillColor: Colors.purple,
                  color: Colors.white70,
                  isSelected: [_userType == "Client", _userType == "Provider"],
                  onPressed: (index) {
                    setState(
                      () => _userType = index == 0 ? "Client" : "Provider",
                    );
                  },
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("I am a Client"),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("I am a Service Provider"),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Input Fields
                _buildTextField(
                  "Full Name",
                  _fullNameController,
                  icon: Icons.person,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  "Email",
                  _emailController,
                  icon: Icons.email,
                  keyboard: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  "Phone",
                  _phoneController,
                  icon: Icons.phone,
                  keyboard: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  "Password",
                  _passwordController,
                  icon: Icons.lock,
                  obscure: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  "Confirm Password",
                  _confirmController,
                  icon: Icons.lock,
                  obscure: _obscureConfirm,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirm ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _obscureConfirm = !_obscureConfirm),
                  ),
                ),
                const SizedBox(height: 16),
                // Agree Terms
                Row(
                  children: [
                    Checkbox(
                      value: _agree,
                      onChanged: (val) => setState(() => _agree = val!),
                    ),
                    const Expanded(
                      child: Text(
                        "I agree to Terms & Privacy Policy",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      backgroundColor: Colors.purpleAccent,
                    ),
                    onPressed: _agree
                        ? () => Navigator.pushNamed(context, '/verify')
                        : null,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: const Text(
                    "Already have an account? Log In",
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    IconData? icon,
    bool obscure = false,
    Widget? suffixIcon,
    TextInputType? keyboard,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white70) : null,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
