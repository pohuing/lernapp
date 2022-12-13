import 'dart:io';

import 'package:flutter/material.dart';

class AdaptiveYesNoOption extends StatelessWidget {
  final void Function(bool? newValue)? onChanged;
  final bool value;

  const AdaptiveYesNoOption({Key? key, this.onChanged, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(Platform.isMacOS || Platform.isIOS){
      return Switch.adaptive(value: value, onChanged: onChanged);
    }else{
      return Checkbox(value: value, onChanged: onChanged);
    }
  }
}
