import 'package:flutter/material.dart';
import 'package:pill_pal/theme.dart';

class CustomUnderLineInput extends StatelessWidget {
  const CustomUnderLineInput({Key? key, this.labelText , this.initialValue, this.suffixText, this.maxLines:1, this.keyboardType ,this.validator, this.onSaved}) : super(key: key);

  final String? labelText;
  final String? suffixText;
  final String? initialValue;
  final int? maxLines;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      autovalidateMode:AutovalidateMode.onUserInteraction,
      keyboardType: keyboardType,
      maxLines: maxLines,
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        suffixText: suffixText,
        labelText: labelText,
        errorStyle: TextStyle(color: MyColors.MiddleRed),
        // labelStyle: TextStyle(
        //     color: Colors.black54
        // ),
        //focusColor: Theme.of(context).primaryColor,
        // enabledBorder: UnderlineInputBorder(
        //   borderSide: BorderSide( color: Colors.grey,),
        // ),
        // focusedBorder:  UnderlineInputBorder(
        //   borderSide:  BorderSide( color: Theme.of(context).primaryColor),
        // ),

      ),
      // The validator receives the text that the user has entered.
      validator: validator,
      onSaved: onSaved ,
    );
  }
}
