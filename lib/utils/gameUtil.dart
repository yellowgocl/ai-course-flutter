// import 'package:course/beans/blockData.dart';
// import 'package:course/beans/conditionData.dart';
// import 'package:course/beans/courseData.dart';
// import 'package:course/beans/mapDataImpl.dart';
// import 'package:course/utils/commonUtil.dart';

// /**
//  * 游戏业务逻辑主控工具
//  */

// class GameUtil {
  
//   CourseData data;
//   initialized(CourseData data){
//     this.data = data;
//   }
//   bool get vaild{
//     return true;
//   }
//   String get accessToken{
//     // 用户角色，原生传入，app内维护
//     return null;
//   }
//   set accessToken(v){

//   }
//   String get appToken{
//     return null;
//   }

//   // 分数
//   // Future<BlockData> nextAction(BlockData blockData){
//   Future<BlockData> nextAction(BlockData blockData, MapDataImpl scoreData){
//     int skip = blockData.skip;
//     List<ConditionData> conditions = blockData.conditions;
//     int score = int.parse(scoreData.get("final_score", 0).toString());
//     // int score = (78.96).toInt();
//     ConditionData matchCondition;
    
//     // 分数级别
//     for (ConditionData condition in conditions) {
//       int express = condition.express;
//       if (score >= express) {
//         matchCondition = condition;
//         break;
//       }
//     }

//     // 分数不足不做操作
//     if (matchCondition == null) {
//       return Future.error("GameUtil/next::error");
//     }

//     // 判断是否过关
//     // if (!blockData.canSkip && blockData.skip < matchCondition.skipValue) {
//     //   return Future.value(blockData);
//     // }

//     // 进入下一关
//     if (matchCondition.contextId == null) {
//       return Future.value(this.data.nextBlock(blockData));
//     }

//     return Future.value(this.data.blockByContextId(matchCondition.contextId));
    
//   }

//   // set

// }


// GameUtil gameController = GameUtil();