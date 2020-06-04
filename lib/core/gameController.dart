import 'dart:async';
import 'dart:math';

import 'package:course/component/videoPlayer.dart';
import 'package:course/config/config.dart';
import 'package:course/models/base_data.dart';
import 'package:course/api/api.dart';
import 'package:course/models/enum/enums.dart';
import 'package:course/models/event/native_event.dart';
import 'package:course/models/factory/widget_builder.dart' as Lib;
import 'package:course/models/remote/block_data.dart';
import 'package:course/models/remote/common/answer_data.dart';
import 'package:course/models/remote/common/course_response_data.dart';
import 'package:course/models/remote/common/score_data.dart';
import 'package:course/models/remote/common/score_response_data.dart';
import 'package:course/models/remote/common/token_data.dart';
import 'package:course/models/remote/components/widget_data.dart';
import 'package:course/models/remote/course_data.dart';
import 'package:course/models/remote/response_data.dart';
import 'package:course/utils/audioPlayerUtil.dart';
import 'package:course/utils/collectionUtil.dart';
import 'package:course/utils/commonUtil.dart';
import 'package:course/utils/eventUtil.dart';
import 'package:course/utils/platformUtil.dart';
import 'package:course/utils/recorderUtil.dart';
import 'package:course/utils/sharedPreferencesUtil.dart';
import 'package:course/views/dialogViews.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class _AppInfo extends BaseData {
  _AppInfo.fromJson(Map<String, dynamic> json): super.fromJson(json);
}

class GameController with ChangeNotifier {
  static final _instance = GameController._internal();
  factory GameController () {
    return _instance;
  }
  GameController._internal();
  static GameController get instance {
    return new GameController();
  }

  final _flareAssets = [
    "assets/res/nodata.flr",
    "assets/res/star.flr",
    "assets/res/mic.flr",
    "assets/res/actor_girl_0.flr",
    "assets/res/course_loading.flr",
    "assets/res/course_actor.flr",
    "assets/res/course_answer_rating.flr",
    "assets/res/course_speech_rating.flr",
  ];


  final _sourceAudio = [
    ["media/feedback_star_0_0.mp3","media/feedback_star_0_0.mp3","media/feedback_star_0_0.mp3"],
    ["media/feedback_star_1_0.mp3","media/feedback_star_1_0.mp3","media/feedback_star_1_0.mp3"],
    ["media/feedback_star_2_0.mp3","media/feedback_star_2_0.mp3","media/feedback_star_2_0.mp3"],
    ["media/feedback_star_3_0.mp3","media/feedback_star_3_0.mp3","media/feedback_star_3_0.mp3"]
  ];

  String appId;
  String accessToken;
  String deviceId;
  String courseId;
  String userId;
  String token;
  int learnRecordId;
  BuildContext context;
  bool showControls = false;
  bool showRating = false;
  bool _showLoading = false;
  ScoreData _scoreData;
  GameState _gameState = GameState.prepareing;
  int _skip = 0;
  Map courseSharedData;

  StreamSubscription _eventListener;
  
  CourseData _course;
  BlockData _currentBlock;
  Duration currentStartPoint;

  void updateState() {
    if (accessToken == null) {
      state = GameState.invaildAccessToken;
    } else if (courseId == null || courseId.length == 0 || _course == null) {
      state = GameState.invaildCourse;
    }
  }

  ScoreData get score{
    return _scoreData;
  }
  set score(ScoreData val){
    _scoreData = val;
    notifyListeners();
  }

  GameState get state{
    return _gameState;
  }
  set state(GameState val) {
    _gameState = val;
    if (val == GameState.interrupting) {
      showControls = false;
    }
    notifyListeners();
  } 

  set showLoading(bool val) {
    _showLoading = val;
    notifyListeners();
  }
  get showLoading {
    return _showLoading;
  }

  CourseData get course{
    return _course;
  }
  set course(CourseData data) {
    _course = data;
    notifyListeners();
  }

  BlockData get currentBlock{
    return _currentBlock;
  }
  set currentBlock(BlockData data) {
    _currentBlock = data;
    notifyListeners();
  }

  AnswerData getAnswerData([int index = 0]) {
    return currentBlock?.answers?.elementAt(index)?? null;
  }

  Map<String, WidgetData> templateAssets= {};

  BlockData nextBlock({contextId}) {
    if (currentBlock == null) {
      currentBlock = course?.blocks?.first;
      currentStartPoint = CommonUtil.getDuration(0);

      // 播放一个空文件防止IOS视频无声
      if (platformUtil.platformData.platform == PlatformType.IOS) {
        AudioPlayerUtil("", isLocal: false)..play();
      }
    } else {
      // currentStartPoint = currentBlock?.start;
      BlockData temp = course.nextBlock(currentBlock, contextId);
      // debugPrint(temp?.toString());
      if (temp == null) {
        state = GameState.complete;
      } else {
        currentBlock = temp;
        state = GameState.playing;
      }
    }
    _skip = currentBlock.skip;
    // print(currentBlock?.name);
    notifyListeners();
    // if (courseEnd) {
    //  state = GameState.complete;
    // }
    return currentBlock;
  }
  Future<bool> initialized({BuildContext context}) async {
    this.context = context;
    await platformUtil.initialized();
    await sharedPreferences.initialized();
    Map<String, dynamic> componentData = await CommonUtil.loadAssetsJson('assets/data/config/template.json');
    componentData.forEach((String k, dynamic v) {
      WidgetData d = Lib.WidgetBuilder.build(v);
      if (d != null) {
        templateAssets[k] = d;
      }
    });
    for(final flrAssetName in _flareAssets) {
      await cachedActor(AssetFlare(bundle: rootBundle, name: flrAssetName));
    }

    _eventListener = EventUtil.listen<NativeEvent>(_onReceiveNativeEvent);

    // flutter -> native 请求发送accesstoken等应用相关信息
    bool flag = await queryNativeAppInfo();

    if (!flag) {
      // 游戏初始化失败 1、网络问题，数据无法获取 2、accessToken失效课程数据无法获取
      NativeEvent event = NativeEvent(event: Events.CALL_GAME_INIT_ERROR);
      platformUtil.invokeMethod(event);
    } else {
      bool hasCourse = await queryCourse();
      if (!hasCourse)
        return hasCourse;
    }
    // 创建成绩单
    await queryLearnRecord();
    // 获取本地数据
    await querySharedData();

    //判断版本适配兼容
    
    return flag;
  }

  Future<bool> isVaildAccess() async{
    return Future.value(accessToken != null);
  }
  Future<bool> queryNativeAppInfo() async {
    NativeEvent event = NativeEvent(event: Events.CALL_ON_GAME_INIT);
    
    var result = Environment.env == Env.dev ? {} : await platformUtil.invokeMethod(event);
    accessToken = CollectionUtil.get(result,key: "accessToken", defaultValue: Environment.config.accessToken );
    appId = CollectionUtil.get(result,key: "appId", defaultValue: Environment.config.appId);
    deviceId = CollectionUtil.get(result,key: "deviceId", defaultValue: Environment.config.deviceId);
    courseId = CollectionUtil.get(result,key: "courseId", defaultValue: Environment.config.courseId);
    userId = CollectionUtil.get(result,key: "userId", defaultValue: Environment.config.userId);
    
    notifyListeners();
    
    return Future.value(result != null);
  }
  
  Future<bool> queryToken() async {
    token = "";
    notifyListeners();
    TokenData tokenData = await Api.fetchToken();
    if (tokenData.code == 200) {
      token = tokenData.token.value;
      notifyListeners();
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<bool> queryCourse({int retryTime = 0}) async {
    // if (retryTime == 3) {
    //   return Future.value(false);
    // }
    showLoading = true;
    CourseResponseData courseResponseData =  await Api.fetchCourse(courseId: courseId);
    showLoading = false;

    if (courseResponseData.flag) {
      gameController.course = courseResponseData.course;
      gameController.nextBlock();
      return Future.value(true);
    } 
    // else if (courseResponseData.code == 401) {
    //   await queryToken();
    //   return Future.value(await queryCourse(retryTime: retryTime + 1));
    // } else if (courseResponseData.code == 4010 || courseResponseData.code == 4012) {
    //   queryAccessToken();
    //   showDialog(context: context, builder: (context) {
    //     return Center(child: Text("无数据."),);
    //   }).then((v) {
    //     print('dialog dimiss, $v');
    //   });
    // }

    return Future.value(false);
  }
  
  Future<bool> queryLearnRecord() async {
    ResponseData recordData = await Api.fetchLearnRecord(courseId: courseId);
    if (recordData.code == 200) {
      learnRecordId = recordData.data.get("id", 0);
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<bool> updateLearnRecord() async {
    Map<String, dynamic> data = {"course": courseSharedData};
    double score = 0.0;

    for (var item in courseSharedData["list"]) {
      print("upload score: ${item["score"]}");
      score += item["score"];
    }

    ResponseData tokenData = await Api.updateLearnRecord(id: learnRecordId, unitId: courseId, score: score, data: data);

    if (tokenData.code == 200) {
      await sharedPreferences.clearProcess(courseId, userId);
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<bool> querySharedData() async {
    // 获取本地数据
    courseSharedData = await sharedPreferences.getProcess(courseId, userId);

    // 本地数据获取失败，初始化本地数据
    if (courseSharedData == null || courseSharedData["list"].length == 0 || gameController.course.updateDate != courseSharedData["updateDate"]) {
      debugPrint("未有记录 创建本地数据");
      List courseList = List();
      for (var block in course?.courseBlocks) {
        Map data = {
          "id": block.id,
          "mode": QuestionType.values.indexOf(block.mode),
          "answers": block.answers.elementAt(0).value,
          "keywords": block.answers.elementAt(0).secondary,
          "score": 0.0,
          "audioId": ""
        };
        courseList.add(data);
      }
      courseSharedData = {"currentPoint": 0, "currentBlockId": currentBlock?.id, "updateDate": gameController.course.updateDate, "list": courseList};
      await sharedPreferences.refreshProcess(courseId, userId, courseSharedData);
    } else {
      debugPrint("已有记录 跳转上次交互点");
      if (courseSharedData["currentPoint"] != 0) {
        int contextId = courseSharedData["currentBlockId"];
        var status = await DialogViews().continueShow(context);
        if (status){
          currentStartPoint = Duration(seconds: courseSharedData["currentPoint"]);
          VideoPlayer(position: currentStartPoint);
          nextBlock(contextId: contextId);
        }
      }
    }
    return Future.value(true);
  }

  Future<bool> updateSharedData(int blockId, int startTime, double score, String audioId) async {
    List courseList = courseSharedData["list"];
    for (var index = 0 ; index < courseList.length; index ++) {
      if (courseList[index]['id'] == blockId) {
        courseList[index]['score'] = score;
        courseList[index]['audioId'] = audioId;

        if (index == (courseList.length - 1)) {
          updateLearnRecord();
        }
        break;
      }
    }
    courseSharedData["currentPoint"] = startTime;
    courseSharedData["currentBlockId"] = currentBlock?.id;
    courseSharedData["list"] = courseList;
    await sharedPreferences.refreshProcess(courseId, userId, courseSharedData);
    return Future.value(true);
  }

  Future<dynamic> queryAccessToken() {
    // _eventListener = EventUtil.listen<NativeEvent>(_onReceiveNativeEvent);
    accessToken = null;
    notifyListeners();
    NativeEvent event = NativeEvent(event: Events.CALL_ON_ACCESSTOKEN);
    return platformUtil.invokeMethod(event);
  }

  void _onReceiveNativeEvent(NativeEvent e) {
    if (e.event == Events.CALL_UPDATE_ACCESSTOKEN) {
      accessToken = e.params.get("accessToken", null);
      notifyListeners();
    }
  }

  WidgetData getAssetsTemplate(String name) {
    if (name == null) {
      return null;
    }
    return templateAssets.containsKey(name) ? templateAssets[name] : null;
  }
  
  Future queryNext(Future<AnswerData> future) async {
    bool result = false;
    switch(currentBlock?.mode) {
      case QuestionType.speech:
          print("query next");
        showLoading = true;
        // await Future.delayed(Duration(seconds: 4));
        future.then((AnswerData data) async {
          if (data.isVaild) {
            // print(data.answer);
            ScoreResponseData scoreResponseData = await Api.evaluating(text: data.value.elementAt(0), audio: data.answer);
            // nextBlock();
            RecorderUtil.delete();
            if (await apiError(scoreResponseData)) {
              calcScore(data, scoreResponseData, 3);
            }
          }
        });
        break;
      case QuestionType.answer:
        showLoading = true;
        future.then((AnswerData data) async {
          if (data.isVaild) {
            ScoreResponseData scoreResponseData = await Api.qanda(audio: data.answer, type: "answer", answers: List<String>.from(data.value), keywords: List<String>.from(data.secondary));
            RecorderUtil.delete();
            if (await apiError(scoreResponseData)) {
              calcScore(data, scoreResponseData, 2);
            }
          }
        });
        break;
    }
    showLoading = false;
    return result;
  }

  Future<bool> apiError(ScoreResponseData scoreResponseData) {
    if (scoreResponseData.code == 401) {
      queryToken();
      showApiDialog();
      return Future.value(false);
    }else if (scoreResponseData.code == 4010 || scoreResponseData.code == 4012) {
      queryAccessToken();
      showApiDialog();
      return Future.value(false);
    }
    return Future.value(true);
  }

  void showApiDialog({String title, Function onPositive, Function onNegative}) {
    // DialogData dialogData = DialogData(gameController.getAssetsTemplate('network_error').toJson());
    // dialogData.show(context).then((onValue) {
    print(title);
    // });
    // showDialog(
    //   context: context,
    //   builder: (context) {
    //     return AlertDialog(
    //       content: TextWidget.Text(data: TextOptionData(title, style: ThemeUtil.getTextStyle(name: 'dialog_title')),),
    //       actions: <Widget>[
    //         FlatButton(onPressed: onPositive, child: TextWidget.Text(data: TextOptionData('重试', style: ThemeUtil.getTextStyle(name: 'button')),)),
    //         FlatButton(onPressed: onNegative, child: TextWidget.Text(data: TextOptionData('取消', style: ThemeUtil.getTextStyle(name: 'button')),))
    //       ],
    //     );
    //   }
    // );
    // ButtonData _quitButton = CommonUtil.getWidgetAssetTemplate('button_video_quit');
    // showDialog(context: context, builder: (context) {
    //   return CustomDialog(
    //     cancelable: true,
    //     visible: true,
    //     child: Container(
    //       child: Row(
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         mainAxisSize: MainAxisSize.min,
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Expanded(
    //             flex: 0,
    //             child: ButtonWrapper(data: _quitButton, onTapUp: (() {}),)
    //           ),
    //         ],
    //       )
    //     ),
    //   );
    // }).then((v) {
    //   print('dialog dimiss, $v');
    // });
    DialogViews().retryShow(context);
  }

  Future<void> calcScore(AnswerData answer, ScoreResponseData scoreResponseData, int maxLevel) {

    String prefix = 'star_';
    int level = 0;
    for (var index = currentBlock.conditions.length - 1; index >= 0; index --) {
      var condition = currentBlock?.conditions[index];
      if (CommonUtil.getDouble(condition.express) > scoreResponseData.finalScore) {
        break;
      }
      level ++;
      if (level >= maxLevel) {break;}
    }

    // 音频对应矫正
    var achievLevel = level >= _sourceAudio.length - 1 ? _sourceAudio.length - 1 : level;
    var audioLevel = achievLevel == maxLevel ? _sourceAudio.length - 1 : achievLevel;

    // 动画对应矫正
    var starLevel = (achievLevel / maxLevel * (_sourceAudio.length - 1)).ceil();

    print("level: $prefix$starLevel");
    ScoreData scoreData = ScoreData(id: scoreResponseData.audioId, score: "${scoreResponseData.finalScore}", playId: '$prefix$starLevel', pass: starLevel > 0);
    score = scoreData;
    int randomNumber = Random().nextInt(3);
    print("random number: $randomNumber");
    
    var audioPath = _sourceAudio[audioLevel][randomNumber];
    print('audioPath:$audioPath');
    AudioPlayerUtil aplayer = AudioPlayerUtil(audioPath, isLocal: true)..play();
    return Future.wait({aplayer.completer.future, Future.delayed(Duration(seconds: 5))}).whenComplete(() {
      if (level != 0 || (-- _skip) == 0){
        int blockId = currentBlock?.id;
        int currentStartTime = currentBlock?.start?.inSeconds;
        // 进入下一关
        nextBlock();
        // 过关记录分数
        updateSharedData(blockId, currentStartTime, scoreResponseData.finalScore, scoreResponseData.audioId);
      }
      score = null;
    });
    // return Future.value(true);
  }
}
final GameController gameController = GameController.instance;