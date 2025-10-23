import 'package:dfine_todo/features/authentication/presentation/screens/forgot_password_screen.dart';
import 'package:dfine_todo/screens/home_screen.dart';
import 'package:dfine_todo/features/authentication/presentation/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../widgets/custom_button_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100),
                Align(
                    alignment: Alignment.center,
                    child: Text(
                      'mimo',
                      style: TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic),
                    )),
                Card(
                    child: TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none)))),
                SizedBox(
                  height: 10,
                ),
                Card(
                    child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(borderSide: BorderSide.none)),
                  obscureText: true,
                )),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => ForgotPasswordScreen()));
                    },
                    child: Text('Forgot Password?')),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  onTap: () {
                    BlocProvider.of<AuthBloc>(context).add(SignInRequested(
                      email: emailController.text,
                      password: passwordController.text,
                    ));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => SignupScreen()));
                        },
                        child: Text(
                          'Register',
                          style:
                              TextStyle(decoration: TextDecoration.underline),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
