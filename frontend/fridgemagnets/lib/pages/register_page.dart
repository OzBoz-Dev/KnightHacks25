import 'package:flutter/material.dart';
import 'package:fridgemagnets/providers/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Whether form is valid
  bool _isFormValid = false;

  // Whether to obscure pass
  bool _obscurePassword = true;

  // Text controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Updates validity of the form
  void _updateFormValidity() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (isValid != _isFormValid) {
      setState(() => _isFormValid = isValid);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Access provider
    final auth = Provider.of<AuthProvider>(context);
    
    return Scaffold(
      appBar: AppBar(title: Text("Login"),),
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 200),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Sign Up with FridgeMagnets",
                  style: GoogleFonts.outfit(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10,),
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
                    if(value == null || value.isEmpty) {
                      return "Username is required";
                    }
                    return null;
                  },
                  onChanged: (_) => _updateFormValidity(),
                  decoration: InputDecoration(
                    hintText: "Knightro",
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue[500]!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
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
                    if(value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if(!RegExp(r'^(?=.*[A-Z])(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$').hasMatch(value)) {
                      return "Password requirements:\n- Must have an uppercase letter\n- Must have a special character\n- Must be at least 8 characters";
                    }
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
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility)
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue[500]!,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (!_isFormValid || auth.isLoading) ? null : () async {
                      FocusScope.of(context).unfocus();
                      await auth.register(
                        _usernameController.text,
                        _passwordController.text,
                      );

                      if (context.mounted) {
                        if (auth.errorMessage != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(auth.errorMessage!),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Account created successfully!"),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      }
                    },
                    child: auth.isLoading ? CircularProgressIndicator() : Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}