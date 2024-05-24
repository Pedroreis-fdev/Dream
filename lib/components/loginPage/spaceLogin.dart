import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../buttons/iconButton.dart';
import '../buttons/rectangleButton.dart';
import "../buttons/textButton.dart";

class LoginSpace extends StatefulWidget {
  const LoginSpace({super.key});

  @override
  State<LoginSpace> createState() => _LoginSpaceState();
}

class _LoginSpaceState extends State<LoginSpace> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(120),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            _logoLogin(),
            _form(emailController, passwordController),
            RectangleButton(
              onTap: () => _login(emailController, passwordController, context),
              color: Color.fromARGB(255, 0, 0, 255), 
              title: "Entrar"
            ),
            _googleAndFace(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

Widget _form(TextEditingController email, TextEditingController senha) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
      children: [
        _textInfo(
          "Username",
          Icon(
            Icons.account_circle_outlined,
            color: Colors.blue[900],
          )
        ),
        TextField(
          controller: email,
          decoration: InputDecoration(
            labelText: 'Digite seu nome de Usuário',
            hoverColor: Colors.blue.shade900,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue)
            ),
          ),
        ),
        SizedBox(height: 10),
        _textInfo(
          "Password",
          Icon(
            Icons.lock_open_sharp,
            color: Colors.blue[900],
          )
        ),
        TextField(
          controller: senha,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Digite sua senha',
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.blue
              )
            ),
            hoverColor: Colors.blue[900],
            iconColor: Colors.blue,
          ),
        ),
      ],
    ),
  );
}

Widget _textInfo(String text, Widget anyIcon) {
  return Padding(
    padding: EdgeInsets.all(15),
    child: Row(
      children: [
        anyIcon,
        SizedBox(width: 10),
        Text(
          text,
          style: TextStyle(fontSize: 15),
        ),
      ],
    ),
  );
}

Widget _googleAndFace() {
  return Padding(
    padding: EdgeInsets.only(top: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BoxButton(
          child: Image(image: AssetImage("assets/googleLogo.png")),
          onTap: () {}
        ),
        SizedBox(width: 10),
        BoxButton(
          child: Image(image: AssetImage("assets/FaceLogo.png")),
          onTap: () {}
        ),
      ],
    ),
  );
}

Widget _logoLogin() {
  return Padding(
    padding: const EdgeInsets.only(top: 20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 100,
          child: Image(
            image: AssetImage("assets/logo.png"),
          ),
        ),
      ],
    ),
  );
}

Future<void> _login(TextEditingController emailController, TextEditingController passwordController, BuildContext context) async {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  try {
    UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    );
    Navigator.pushNamed(context, "/MainPage");
  } on FirebaseAuthException catch (e) {
    String message;
    if (e.code == 'user-not-found' || e.code == 'wrong-password') {
      message = "Usuário ou senha incorretos";
    } else {
      message = "Erro ao fazer login: ${e.message}";
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Erro ao fazer login: $e"), backgroundColor: Colors.red),
    );
  }
}
