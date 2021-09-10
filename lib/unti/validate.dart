class Validate {
  bool emailValidate(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  // bool isValidEmail(String email) {
  //   return RegExp(
  //           r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
  //       .hasMatch(email);
  // }

  String phoneNumberValidate(String phone) {
    Pattern pattern = r'/^\(?(\d{3})\)?[- ]?(\d{3})[- ]?(\d{4})$/';
    RegExp regex = new RegExp(pattern);
    if (phone.isEmpty)
      return 'Please enter some text!';
    else if (!regex.hasMatch(phone))
      return 'Check your phone number!';
    else
      return null;
  }

  String passwordValidate(String pass) {
    if (pass.isEmpty) {
      return 'Please enter some text!';
    } else if (pass.length <= 6) {
      return "password must be at least 6 characters";
    } else if (pass.length >= 12)
      return "password must be more 12 characters";
    else
      return null;
  }

  String nameValidate(String name) {
    RegExp regex = RegExp('[a-zA-Z]');
    if (name.isEmpty) {
      return 'Please enter some text!';
    } else if (!regex.hasMatch(name)) {
      return 'Check your name!';
    } else
      return null;
  }

  String passwordcComfirmValidate(String passComfirm, String pass) {
    if (passComfirm.isEmpty) {
      return 'Please enter some text!';
    } else if (pass != passComfirm) {
      return 'Check your password !';
    } else
      return null;
  }
}
