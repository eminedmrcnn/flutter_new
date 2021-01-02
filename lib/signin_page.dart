import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demoo/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';





class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş Yap"),
      ),
      body: _SignInBody(),
    );
  }
}

class _SignInBody extends StatefulWidget {
  @override
  __SignInBodyState createState() => __SignInBodyState();
}

class __SignInBodyState extends State<_SignInBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          //? Email / Şifre ile giriş
          _EmailPasswordForm(),
          //? Google ile giriş
          _SignInProvider(
            infoText: "Google ile giriş yap",
            buttonType: Buttons.Google,
            signInMethod: () async => _signInWithGoogle(), // TODO: Google ile giriş
          ),
          //? Anonim giriş
          _SignInProvider(
            infoText: "Anonim giriş yap",
            buttonType: Buttons.AppleDark,
            signInMethod: () async => _signInAnonymusly(), // TODO: Anonim giriş
          ),
        ],
      ),
    );
  }

  _signInWithGoogle() async {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => HomePage(),));
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final GoogleAuthCredential credential =
      GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User user = userCredential.user;

      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(
            "Hoşgeldin, ${user.displayName}",
          ))
      );
    } on FirebaseAuthException catch (e) {
      Scaffold.of(context).showSnackBar(
          SnackBar(content: Text(
            e.code,
          ))
      );
    } catch (e) {
      print(e.toString());
    }
  }

  _signInAnonymusly() async{
    await _auth.signInAnonymously();

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => HomePage(),));
  }
}

class _EmailPasswordForm extends StatefulWidget {
  @override
  __EmailPasswordFormState createState() => __EmailPasswordFormState();
}

class __EmailPasswordFormState extends State<_EmailPasswordForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //? Bilgi
              Container(
                child: Text(
                  "Email ve Şifre ile Giriş Yap",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
              ),
              //? E-Mail
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "E-Mail"),
                validator: (String mail) {
                  if (mail.trim().isEmpty) return "Lütfen bir mail yazın";
                  return null;
                },
              ),
              //? Şifre
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: "Şifre"),
                validator: (String password) {
                  if (password.isEmpty) return "Lütfen bir şifre yazın";
                  return null;
                },
                obscureText: true, //! Şifrenin görünmesini engeller.
              ),
              Container(
                padding: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.center,
                child: SignInButton(Buttons.Email, text: "Email ile giriş yap",
                    onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _signIn();
                    // TODO: Email ile giriş
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signIn() async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      final User user = userCredential.user;

      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Hoşgeldin, ${user.email}",
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
        ),
      );
    } catch (e) {
      //print(e.toString());
      debugPrint(e.toString());
    }
  }
}

class _SignInProvider extends StatefulWidget {
  final String infoText;
  final Buttons buttonType;
  final Function signInMethod;

  const _SignInProvider({
    Key key,
    @required this.infoText,
    @required this.buttonType,
    @required this.signInMethod,
  }) : super(key: key);

  @override
  __SignInProviderState createState() => __SignInProviderState();
}

class __SignInProviderState extends State<_SignInProvider> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                widget.infoText,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.center,
            ),
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              alignment: Alignment.center,
              child: SignInButton(
                widget.buttonType,
                text: widget.infoText,
                onPressed: () async => widget.signInMethod(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
