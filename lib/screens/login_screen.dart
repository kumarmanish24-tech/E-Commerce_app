
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const Color primaryColor = Color(0xFF4C9C52);
  static const Color darkColor = Color(0xFF172017);

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 700));

    if (!mounted) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email == 'demo@gmail.com' && password == '123456') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const MainScreen(),
        ),
      );
    } else {
      setState(() {
        _isLoading = false;
      });

      _showMessage('Invalid email or password');
    }
  }

  void _continueAsGuest() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScreen(),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: darkColor,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: isPassword && !_isPasswordVisible,
          keyboardType: keyboardType,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: darkColor,
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter ${label.toLowerCase()}';
            }

            if (label == 'Email Address' &&
                !RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                    .hasMatch(value.trim())) {
              return 'Please enter a valid email';
            }

            if (isPassword && value.length < 6) {
              return 'Password must be at least 6 characters';
            }

            return null;
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
            prefixIcon: Icon(
              icon,
              color: Colors.grey.shade600,
              size: 21,
            ),
            suffixIcon: isPassword
                ? IconButton(
              onPressed: () {
                setState(() {
                  _isPasswordVisible =
                  !_isPasswordVisible;
                });
              },
              icon: Icon(
                _isPasswordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey.shade600,
              ),
            )
                : null,
            filled: true,
            fillColor: const Color(0xFFF7F8F5),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 19,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFFE9EDE5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 1.7,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.redAccent,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Colors.redAccent,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  children: [
                    // Lottie Animation Area
                    SizedBox(
                      height: 215,
                      width: double.infinity,
                      child: Center(
                        child: Lottie.asset(
                          'assets/shopping.json',
                          height: 190,
                          width: 230,
                          fit: BoxFit.contain,
                          repeat: true,
                          animate: true,
                        ),
                      ),
                    ),

                    // Login Form
                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight - 215,
                      ),
                      padding: const EdgeInsets.fromLTRB(
                        26,
                        32,
                        26,
                        28,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome Back!',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: darkColor,
                                letterSpacing: -0.8,
                              ),
                            ),

                            const SizedBox(height: 9),

                            Text(
                              'Sign in to continue your shopping journey.',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade600,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 30),

                            _buildTextField(
                              label: 'Email Address',
                              hint: 'Enter your email address',
                              controller: _emailController,
                              icon: Icons.email_outlined,
                              keyboardType:
                              TextInputType.emailAddress,
                            ),

                            const SizedBox(height: 22),

                            _buildTextField(
                              label: 'Password',
                              hint: 'Enter your password',
                              controller: _passwordController,
                              icon: Icons.lock_outline_rounded,
                              isPassword: true,
                            ),

                            const SizedBox(height: 12),

                            // Remember Me and Forgot Password
                            Row(
                              children: [
                                SizedBox(
                                  height: 35,
                                  child: Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        activeColor: primaryColor,
                                        checkColor: darkColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(5),
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe =
                                                value ?? false;
                                          });
                                        },
                                      ),
                                      const Text(
                                        'Remember me',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight:
                                          FontWeight.w500,
                                          color: darkColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    _showMessage(
                                      'Forgot password feature coming soon!',
                                    );
                                  },
                                  child: const Text(
                                    'Forgot Password?',
                                    style: TextStyle(
                                      color: darkColor,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Login Button
                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: ElevatedButton(
                                onPressed:
                                _isLoading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  disabledBackgroundColor:
                                  primaryColor.withValues(
                                    alpha: 0.6,
                                  ),
                                  foregroundColor: darkColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(16),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                  height: 23,
                                  width: 23,
                                  child:
                                  CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: darkColor,
                                  ),
                                )
                                    : const Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight:
                                        FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 21,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 25),

                            // Divider
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                Padding(
                                  padding:
                                  const EdgeInsets.symmetric(
                                    horizontal: 15,
                                  ),
                                  child: Text(
                                    'OR CONTINUE WITH',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 22),

                            // Google Login Demo
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: OutlinedButton(
                                onPressed: () {
                                  _showMessage(
                                    'Google sign-in integration coming soon!',
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: darkColor,
                                  side: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(15),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.g_mobiledata_rounded,
                                      size: 30,
                                      color: Colors.blue,
                                    ),
                                    const SizedBox(width: 9),
                                    const Text(
                                      'Continue with Google',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(height: 22),

                            // Guest Login
                            Center(
                              child: TextButton(
                                onPressed: _continueAsGuest,
                                child: const Text(
                                  'Continue as Guest',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: darkColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 8),

                            Center(
                              child: Text(
                                'Your shopping experience starts here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
