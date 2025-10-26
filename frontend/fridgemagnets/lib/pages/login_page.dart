import 'package:flutter/material.dart';
import 'package:fridgemagnets/pages/register_page.dart';
import 'package:fridgemagnets/providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Whether form is valid
  bool _isFormValid = false;

  // Whether to obscure pass
  bool _obscurePassword = true;

  // Text controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Controls register now styles
  bool _isHovering = false;

  void _setHovering(bool hovering) {
    setState(() {
      _isHovering = hovering;
    });
  }

  // Updates validity of the form
  void _updateFormValidity() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: SafeArea(
        child: Consumer<AuthProvider>(
          builder: (context, auth, child) {
            if (auth.token != null && auth.username != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome, ${auth.username ?? 'User'}!",
                      style: GoogleFonts.outfit(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: auth.logout,
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.red)
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            else {
              return Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome to FridgeMagnets",
                        style: GoogleFonts.outfit(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Username:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Username is required";
                          }
                          return null;
                        },
                        onChanged: (_) => _updateFormValidity(),
                        decoration: InputDecoration(
                          hintText: "Knightro",
                          filled: true,
                          fillColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue[500]!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Password:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        validator: (value) {
                          return null;
                        },
                        obscureText: _obscurePassword,
                        onChanged: (_) => _updateFormValidity(),
                        decoration: InputDecoration(
                          hintText: "Abc123!",
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          labelStyle: TextStyle(color: Colors.grey),
                          hintStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue[500]!),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (!_isFormValid || auth.isLoading) ? null : () async {
                            String username = _usernameController.text;
                            String password = _passwordController.text;
                            FocusScope.of(context).unfocus();
                            await auth.login(
                              username,
                              password
                            );
                            if (context.mounted) {
                              if (auth.errorMessage != null) {
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(
                                  SnackBar(
                                    content: Text(auth.errorMessage!),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context,).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Logged in successfully",
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          },
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      MouseRegion(
                        onEnter: (_) => _setHovering(true),
                        onExit: (_) => _setHovering(false),
                        child: GestureDetector(
                          onTap: (auth.isLoading)
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RegisterPage(),
                                    ),
                                  );
                                },
                          child: Text(
                            "Don't have an account? Register now!",
                            style: GoogleFonts.outfit(
                              color: Colors.grey,
                              decoration: _isHovering
                                  ? TextDecoration.underline
                                  : null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
