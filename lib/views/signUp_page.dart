import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_appchat318/providers/auth_service.dart';
import 'package:flutter_appchat318/unti/validate.dart';
import 'package:flutter_appchat318/views/signIn_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordComfirm = TextEditingController();
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
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Container(
              width: 360.w,
              height: 790.h,
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.fromRGBO(116, 176, 243, 1),
                      Color.fromRGBO(51, 132, 224, 1),
                    ]),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 20.h),
                    baseText(
                      text: "Sign Up",
                      sizeText: 28.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    nameInput(),
                    phoneInput(),
                    emailInput(),
                    passInput(),
                    confirmPassInput(),
                    SizedBox(height: 20.h),
                    btnRegister(),
                    SizedBox(height: 20.h),
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
    return MaterialButton(
      minWidth: 340.w,
      height: 50.h,
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
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
        child: baseText(
            text: "REGISTER",
            sizeText: 22.sp,
            color: Colors.lightBlue,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget label() {
    return baseText(
      text: "Sign Up",
      sizeText: 28.sp,
      fontWeight: FontWeight.bold,
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
        }
        return "";
      },
    );
  }

  Widget signInText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        baseText(text: "Have an Ancount ? ", sizeText: 20.sp),
        baseText(
            text: "Sign In",
            sizeText: 20.sp,
            fontWeight: FontWeight.bold,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignInPage()),
              );
            })
      ],
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
    FormFieldValidator<String> validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),
        baseText(text: labelText, sizeText: 16.sp),
        SizedBox(height: 4.h),
        TextFormField(
          // onFieldSubmitted: onSubmitted,

          controller: controller,
          obscureText: isShowText,
          validator: validator,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
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
    );
  }
}
