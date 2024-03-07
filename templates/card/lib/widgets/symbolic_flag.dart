import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';

/// 象徵旗幟
class SymbolicFlag extends StatelessWidget {
  final String countryCode;
  final String languageCode;

  const SymbolicFlag(this.countryCode, this.languageCode, {super.key});

  @override
  Widget build(BuildContext context) {
    Widget flag = Flag.fromString(
      countryCode,
      borderRadius: 8,
    );

    if (countryCode.isEmpty) {
      flag = Flag.fromString(
        languageCode,
        borderRadius: 8,
      );
    }

    if (countryCode == 'TW') {
      flag = Image.asset('assets/images/background/Meihua_ROC.png');
    }

    return flag;
  }
}