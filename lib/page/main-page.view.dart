import 'package:flutter/material.dart';
import 'package:flutter_app/page/main-page.viewmodel.dart';
import 'package:flutter_app/widget/range-slider.widget.dart';


class MainPageView extends StatelessWidget {

  MainPageViewModel _viewModel;

  @override
  Widget build(BuildContext context) {
    _viewModel ??= MainPageViewModel();

    return Scaffold(
      appBar: _getAppBar(),
      body: _getBody(),
    );
  }

  _getAppBar() {
    return AppBar(
      title: Text(
        'Range Slider Widget'
      ),
    );
  }

  _getBody() {
    return Container(
      child: RangeSliderWidget(
        minValue: _viewModel.minvalue,
        maxValue: _viewModel.maxvalue,
        volumes: _viewModel.volumes,
        rangeSliderLabelBuilder: (double startValue, double endValue) {
          return Container(
            child:Text(
              _viewModel.getRangeTitle(startValue, endValue),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black
              ),
            ),
          );
        },
      ),
    );
  }
}
