import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appchat318/providers/auth_service.dart';
import 'package:flutter_appchat318/unti/validate.dart';
import 'package:flutter_appchat318/views/signIn_page.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController(text: "");
  TextEditingController name = TextEditingController(text: "");
  TextEditingController phone = TextEditingController(text: "");
  TextEditingController password = TextEditingController(text: "");
  TextEditingController passwordComfirm = TextEditingController(text: "");
  Validate validate = Validate();

  final formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
            create: (_) => AuthService(FirebaseAuth.instance)),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: Form(
        key: formKey,
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.blue.shade600,
            body: SingleChildScrollView(
              reverse: false,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(116, 176, 243, 1),
                        Color.fromRGBO(51, 132, 224, 1),
                      ]),
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    // label(),
                    nameInput(),
                    phoneInput(),
                    emailInput(),
                    passInput(),
                    confirmPassInput(),
                    btnRegister(),
                    signInText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget btnRegister() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 28, 18, 0),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          if (formKey.currentState.validate()) {}

          context
              .read<AuthService>()
              .register(
                  email: email.text,
                  password: password.text,
                  name: name.text,
                  phone: phone.text)
              .then((value) => {
                    {
                      if (value == "Fail")
                        {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Register Fail")))
                        }
                      else
                        {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignInPage(),
                            ),
                          )
                        }
                    },
                  });
        },
        shape: const StadiumBorder(),
        color: Colors.white,
        splashColor: Colors.blue[900],
        disabledColor: Colors.grey,
        disabledTextColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: baseText(
              text: "REGISTER",
              sizeText: 22,
              color: Colors.lightBlue,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget label() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: baseText(
        text: "Sign Up",
        sizeText: 28,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget passInput() {
    return baseInput(
        isShowText: true,
        labelText: "Password",
        controller: password,
        text: "******",
        icon: Icon(Icons.vpn_key),
        validator: (val) {
          print(val);
          return validate.passwordValidate(val);
        });
  }

  Widget confirmPassInput() {
    return baseInput(
        isShowText: true,
        labelText: "Password",
        controller: passwordComfirm,
        text: "******",
        icon: Icon(Icons.vpn_key),
        validator: (val) {
          return validate.passwordcComfirmValidate(val, password.text);
        });
  }

  Widget nameInput() {
    return baseInput(
        isShowText: false,
        labelText: "Full Name",
        controller: name,
        text: "Enter your name",
        icon: Icon(Icons.person),
        validator: (val) {
          return validate.nameValidate(val);
        });
  }

  Widget phoneInput() {
    return baseInput(
        isShowText: false,
        labelText: "Phone No",
        controller: phone,
        text: "Enter your phone",
        icon: Icon(Icons.phone),
        validator: (val) {
          return validate.phoneNumberValidate(val);
        });
  }

  Widget emailInput() {
    return baseInput(
      isShowText: false,
      labelText: "Email",
      controller: email,
      text: "Enter your email",
      icon: Icon(Icons.mail),
      validator: (val) {
        if (val.isEmpty) {
          return 'Please enter some text!';
        } else if (!validate.emailValidate(val)) {
          return "Check your email!";
        } else
          return null;
      },
    );
  }

  Widget signInText() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          baseText(text: "Have an Ancount ? ", sizeText: 20),
          baseText(
              text: "Sign In",
              sizeText: 20,
              fontWeight: FontWeight.bold,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              })
        ],
      ),
    );
  }

  Widget baseText({
    String text,
    double sizeText,
    void Function() onTap,
    Color color = Colors.white,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        "$text",
        style: TextStyle(
          color: color,
          fontSize: sizeText,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  Widget baseInput({
    TextEditingController controller,
    String labelText,
    String text,
    Icon icon,
    bool isShowText = false,
    // String Function(String) validator
    FormFieldValidator<String> validator,
    //  void Function(String) onSubmitted,
    //  void Function() onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: baseText(text: labelText, sizeText: 18),
            ),
          ),
          TextFormField(
            // onFieldSubmitted: onSubmitted,

            controller: controller,
            obscureText: isShowText,
            validator: validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              filled: true,
              fillColor: Colors.blue.shade300,
              prefixIcon: InkWell(
                // onTap: onTap,

                child: icon,
              ),
              hintText: "$text",
              hintStyle: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
