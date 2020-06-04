enum AssetType{
  network, assets, file, memory
}

enum TransformConversionType{
  relative, absolute, viewport
}

enum QuestionType{
  speech, answer, radio, checkbox, report
}

enum PlatformType{
  IOS, ANDROID, WINDOWS, MACOS, LINUX, FUCHSIA
}

enum RectBuildType{
  center, circle, ltrb, ltwh
}

/**
 * interrupting: 交互中
 * playing: 视频课程播放中，和interrupting互斥
 * complete: 课程完成
 * invaildAccessToken: 身份验证不通过，不合法
 * invaildCourse: 非法课程
 * prepareing
 */
enum GameState {
  interrupting, prepareing, playing, complete, invaildAccessToken, invaildCourse, 
}