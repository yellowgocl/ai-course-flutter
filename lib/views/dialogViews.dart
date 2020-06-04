

import 'package:course/component/button.dart';
import 'package:course/models/remote/components/button_data.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:flutter/material.dart';

class DialogViews {
  Future<bool> continueShow(BuildContext context) async{
    ButtonData _replayButton = CommonUtil.getWidgetAssetTemplate("replay_button");
    ButtonData _continueButton = CommonUtil.getWidgetAssetTemplate("continue_button");
    var status = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            width: 350,
            height: 245,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 350,
                    height: 200,
                    padding: EdgeInsets.fromLTRB(40, 45, 40, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("检测到您的学习记录！是否继续上次退出的进度？",
                              style: TextStyle(fontSize: 18, color: Colors.black, decoration: TextDecoration.none, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          
                          children: <Widget>[
                            Expanded(
                              flex: 0,
                              child: ButtonWrapper(data: _replayButton, onTapUp: (TapUpDetails details) {
                                Navigator.of(context).pop(false);
                              },)
                            ),
                            Expanded(
                              flex: 0,
                              child: ButtonWrapper(data: _continueButton, onTapUp: (TapUpDetails details) {
                                Navigator.of(context).pop(true);
                              },)
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ),
                Positioned(
                  top: 0,
                  child: Image.asset("assets/images/course_record_icon.png", width: 90, height: 90, fit: BoxFit.cover),
                )
              ],
            )
          )
        );
      }
    );
    return Future.value(status);
  }
  Future<bool> retryShow(BuildContext context) async{
    ButtonData _retryButton = CommonUtil.getWidgetAssetTemplate("retry_button");
    var status = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Container(
            width: 230,
            height: 220,
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 230,
                    height: 175,
                    padding: EdgeInsets.fromLTRB(40, 45, 40, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text("网络无法连接",
                              style: TextStyle(fontSize: 18, color: Colors.black, decoration: TextDecoration.none, fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center,
                        ),
                        Expanded(
                          flex: 0,
                          child: ButtonWrapper(data: _retryButton, onTapUp: (TapUpDetails details) {
                            Navigator.of(context).pop(true);
                          },)
                        ),
                      ],
                    ),
                  )
                ),
                Positioned(
                  top: 0,
                  child: Image.asset("assets/images/network_error_icon.png", width: 90, height: 90, fit: BoxFit.cover),
                )
              ],
            )
          )
        );
      }
    );
    return Future.value(status);
  }
}