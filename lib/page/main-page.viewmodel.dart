import 'package:intl/intl.dart';

class MainPageViewModel {

  MainPageViewModel() {
    _volumes = [250,40 ,150, 320, 100, 500, 440, 100 ,150, 320,
      100, 500, 250,40 ,150, 320, 100, 500, 250,40 ,150, 320, 100, 500];
  }

  List<int> _volumes;

  String _getStrCurrencyFormat(dynamic price){
    return NumberFormat("#,##0").format(price);
  }

  String getRangeTitle(double min, double max) {
    return _getStrCurrencyFormat(min) + ' ~ ' + _getStrCurrencyFormat(max);
  }

  List<int> get volumes => _volumes;

  String get rangeTitle => 'Range Slider';

  double get minvalue => 10;

  double get maxvalue => 1000;
}