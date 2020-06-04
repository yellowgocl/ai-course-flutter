import 'dart:convert';
import 'dart:io';

import 'package:course/api/api.dart';
import 'package:course/models/remote/response_data.dart';
import 'package:flutter/widgets.dart';
import 'package:recorder_wav/recorder_wav.dart';

/**
 * 统一录音封装和操控的工具类
 */
class RecorderUtil {
  static bool isRecording = false;
  static String filePath;

  static bool start() {
    if (!isRecording) {
      RecorderWav.startRecorder();
      isRecording = true;
    }
    return isRecording;
  }
  static Future<String> stop() async {
    isRecording = false;
    filePath = await RecorderWav.StopRecorder();
    return filePath;
  }

  static delete({ fp }) {
    if (filePath == null || filePath == '') return;
    if (fp == null || fp == '') {
      fp = filePath;
    }
    if (isRecording) {
      stop().then((p) {
        RecorderWav.removeRecorderFile(p);  
      });
    } else {
      RecorderWav.removeRecorderFile(fp);
    }
    print('delete file from $filePath');
    filePath = null;
  }

  /**
   * 获取最后一次录音的字节列
   */
  static Future<List<int>> getBytes() async {
    File file = new File(filePath);
    bool isExists = await file.exists();
    List<int> result;
    if (isExists) {
      result = await file.readAsBytes();
    }
    return result;
  }
  /**
   * 获取最后一次录音的字节流base64字符
   */
  static Future<String> getBase64() async {
    List<int> bytes = await getBytes();
    String result;
    if (bytes !=  null) {
      result = base64Encode(bytes);
    }
    return result;
  }

  /**
   * 提交
   */
  static Future<ResponseData> evaluating({String text}) async {
    await stop();
    String audio = await getBase64();
    if (audio == null) {
      return Future.error('no audio data');
    }
    ResponseData r = await Api.evaluating(text: text, audio: audio);
    await delete();
    debugPrint(r?.toString());
    return r;
  }

}