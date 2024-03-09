import 'package:country_picker/country_picker.dart';
import 'package:flag/flag_widget.dart';
import 'package:flutter/cupertino.dart';

/// 象徵旗幟
class SymbolicFlag extends StatelessWidget {
  String countryCode;
  String languageCode;
  double? height;

  SymbolicFlag(this.countryCode, this.languageCode, {this.height, super.key}) {
    if (languageCode.toLowerCase() == 'ja') {
      countryCode = 'JP';
      languageCode = 'jp';
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget flag = Flag.fromString(
      countryCode,
      height: height,
      borderRadius: 8,
    );

    if (countryCode.isEmpty) {
      flag = Flag.fromString(
        languageCode,
        height: height,
        borderRadius: 8,
      );
    }

    // if (countryCode == 'TW') {
    //   flag = Image.asset('assets/images/background/Meihua_ROC.png');
    // }

    return flag;
  }

  String get countryName {
    return Country.tryParse(countryCode)?.name ?? '';
  }
}
