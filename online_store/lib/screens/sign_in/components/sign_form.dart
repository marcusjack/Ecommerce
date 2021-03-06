import 'package:flutter/material.dart';
import 'package:online_store/components/custom_suffix_icon.dart';
import 'package:online_store/components/default_button.dart';
import 'package:online_store/components/form_error.dart';
import 'package:online_store/constants.dart';
import 'package:online_store/screens/forgot_password/forgot_password_screen.dart';
import 'package:online_store/screens/login_success/login_success_screen.dart';
import 'package:online_store/size_config.dart';

class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  // GlobalKey This uniquely identifies the Form , and allows validation of the form in a later step.
  final _formKey = GlobalKey<FormState>();
  String email, password;
  bool remember = false;
  final List<String> errors = [];

// func with named parameter
  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // TextFormField - Creates a [FormField] that contains a [TextField].
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Remember me"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: 'Login',
            press: () {
              print(_formKey.currentState.validate());
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();

                // if all are valid then go to success screen
                Navigator.pushReplacementNamed(
                    context, LoginSuccessScreen.routeName);
              }
            },
          )
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      // obscure visibility of the password
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kPassNullError)) {
          removeError(error: kPassNullError);
        } else if (value.length >= 8) {
          removeError(error: kShortPassError);
        }
        // In case a user removed some characters below the threshold, show alert
        else if (value.length < 8 && value.isNotEmpty) {
          addError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          removeError(error: kShortPassError);
          return "";
        } else if (value.length < 8 && value.isNotEmpty) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        // uses the InputDecorationTheme defined in my theme.dart file
        labelText: "Password",
        hintText: "Enter your password",
        // When [FloatingLabelBehavior.always] the label will always float at the top of the field above the content.
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Lock.svg",
        ),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      // Requests a keyboard with ready access to the "@" and "." keys.
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty && errors.contains(kEmailNullError)) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        } else if (value.isNotEmpty && !emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return null;
        }
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kEmailNullError);
          removeError(error: kInvalidEmailError);
          return "";
        } else if (value.isNotEmpty && !emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        // uses the InputDecorationTheme defined in my theme.dart file
        labelText: "Email",
        hintText: "Enter your email",
        // When [FloatingLabelBehavior.always] the label will always float at the top of the field above the content.
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSuffixIcon(
          svgIcon: "assets/icons/Mail.svg",
        ),
      ),
    );
  }
}
