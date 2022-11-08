import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../models/login_model.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';

  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();
  final _forgotPasswordFocusNode = FocusNode();
  final _loginFocusNode = FocusNode();

  var _loginDetails = LoginModel(loginId: '', password: '');

  final _form = GlobalKey<FormState>();

  void _saveForm() {
    print ('Save form');

    final isFormValid = _form.currentState?.validate();

    if (isFormValid != null ) {
      _form.currentState?.save();
      print('Login Entered ${_loginDetails.loginId}');
      print('Password Entered ${_loginDetails.password}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: _form,
          child: ListView(
            children: [
              Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: const Text(
                    'COMPANY NAME',
                    style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 30,
                        fontWeight: FontWeight.w500),
                  )),
              const SizedBox(
                height: 40,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextFormField(
                  controller: _userNameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                  ),
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  onSaved: (value) {
                    _loginDetails = LoginModel(
                        loginId: value!,
                        password: _loginDetails.password);
                  },
                  validator: MultiValidator([
                  EmailValidator(errorText: 'Enter valid E-mail Id'),
                  MinLengthValidator(3, errorText: 'Enter valid E-mail Id'),
                  ]),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: TextFormField(
                  obscureText: true,
                  // to hide the text entered
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9_\-=@,\.;]+')),
                  ],
                  focusNode: _passwordFocusNode,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context)
                        .requestFocus(_forgotPasswordFocusNode);
                  },
                  onSaved: (value) {
                    _loginDetails = LoginModel(
                        loginId: _loginDetails.loginId, password: value!);
                  },
                  validator: MultiValidator([
                    MinLengthValidator(6,errorText: "Password should be atleast 6 characters"),
                    MaxLengthValidator(15,errorText: "Password should not be greater than 15 characters")
                  ]),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () {
                  },
                  focusNode: _forgotPasswordFocusNode,
                  onFocusChange: (_) {
                    FocusScope.of(context).requestFocus(_loginFocusNode);
                  },
                  child: const Text(
                    'Forgot Password',
                    style: TextStyle(color: Colors.blue, fontSize: 20),
                  )),
              Container(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {
                    _saveForm();

                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                    child: Text('Does not have account?'),
                  ),
                  TextButton(
                    onPressed: () {
                      //signup screen
                    },
                    child: const Text(
                      'Sign in',
                      style: TextStyle(fontSize: 20),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
