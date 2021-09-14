import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appchat318/providers/auth_service.dart';
import 'package:flutter_appchat318/unti/validate.dart';
import 'package:flutter_appchat318/views/contacts_page.dart';
import 'package:flutter_appchat318/views/signUp_page.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController email = TextEditingController(text: "huan@gmail.com");
  TextEditingController password = TextEditingController(text: "12345678");
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
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        // backgroundColor: Colors.blue.shade600,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(116, 176, 243, 1),
                  Color.fromRGBO(51, 132, 224, 1),
                ],
              ),
            ),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  label(),
                  emailInput(),
                  passInput(),
                  forgotText(),
                  checkbox(),
                  btnLogin(),
                  orText(),
                  icon(),
                  signUpText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget emailInput() {
    return baseInput(
      labelText: "Email",
      controller: email,
      text: "Enter your Email",
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

  Widget checkbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Theme(
          data: Theme.of(context).copyWith(
            unselectedWidgetColor: Colors.white,
          ),
          child: Checkbox(
            checkColor: Colors.black,
            activeColor: Colors.white,
            hoverColor: Colors.white,
            value: false,
            onChanged: (newValue) {
              //  checkedValue = newValue;
            },
          ),
        ),
        baseText(text: "Remember me", sizeText: 20.sp)
      ],
    );
  }

  Widget label() {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: baseText(
        text: "Sign In",
        sizeText: 28.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget signUpText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        baseText(text: "Don't have an Ancount ", sizeText: 20.sp),
        baseText(
            text: "Sign Up",
            sizeText: 20.sp,
            fontWeight: FontWeight.bold,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpPage()),
              );
            })
      ],
    );
  }

  Widget btnLogin() {
    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
      // padding: EdgeInsets.all(10.w),

      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          // print(validate.emailValidate(String));
          if (formKey.currentState.validate()) {
            context.read<AuthService>().login(email.text, password.text).then(
                  (value) => {
                    if (value == "Fail")
                      {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text("Login Fail")))
                      }
                    else
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactsPage(),
                            settings: RouteSettings(
                              arguments: email.text,
                            ),
                          ),
                        )
                      }
                  },
                );
          }
        },
        shape: const StadiumBorder(),
        color: Colors.white,
        splashColor: Colors.blue[900],
        disabledColor: Colors.grey,
        disabledTextColor: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          child: baseText(
            text: "LOGIN",
            fontWeight: FontWeight.bold,
            sizeText: 28,
            color: Colors.lightBlue,
          ),
        ),
      ),
    );
  }

  Widget forgotText() {
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: Align(
        alignment: Alignment.centerRight,
        child: baseText(
          text: "Forgot Password",
          sizeText: 18.sp,
        ),
      ),
    );
  }

  Widget orText() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
          child: baseText(
            text: "- OR - ",
            sizeText: 20.sp,
          ),
        ),
        baseText(
          text: "Sign in with",
          sizeText: 18.sp,
        ),
      ],
    );
  }

  Widget icon() {
    return Padding(
      padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          baseIcon(assetImage: "assets/facebook.png"),
          baseIcon(assetImage: "assets/google.png"),
        ],
      ),
    );
  }

  Widget passInput() {
    return baseInput(
        isShowText: true,
        labelText: "Password",
        controller: password,
        text: "",
        icon: Icon(Icons.vpn_key),
        validator: (val) {
          return validate.passwordValidate(val);
        });
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

  Widget baseIcon({
    String assetImage,
  }) {
    return Container(
      margin: EdgeInsets.all(ScreenUtil().setHeight(8)),
      padding: EdgeInsets.all(ScreenUtil().setHeight(8)),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: Image(
        image: AssetImage(assetImage),
        width: ScreenUtil().setWidth(35),
        height: ScreenUtil().setHeight(35),
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
      padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Align(
              alignment: Alignment.centerLeft,
              child: baseText(text: labelText, sizeText: 18.sp),
            ),
          ),
          TextFormField(
            // onFieldSubmitted: onSubmitted,

            controller: controller,
            obscureText: isShowText,
            validator: validator,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
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
