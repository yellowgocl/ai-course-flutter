# AI-Course(AI智能课件)

zib ai-course module by flutter module, include to zib-app

## Getting Started

For help getting started with Flutter, view online
[documentation](https://flutter.dev/).

## **<font color=#f00>important</font>**
1. 需要确保开发环境内包含flutter sdk，如果未安装请按照 ** Getting Started ** 提供的联结进行安装
2. dart v2.3.0


## global
### methodChannel
> ios
#### host to client 
> `fromHostToClient`
#### client to host 
> `fromHostToClient`


## Android
### 嵌入到现有项目


## ios
### 嵌入到现有项目

1、命令行进入原生目录
2、git init
    已有git可不运行
3、git submodule add -b [分支] http://gitlab.zib.com/web/ai-course.git
4、git submodule update
    命令运行后目录中添加Flutter项目文件夹（ai-course）
5、添加Podfile

//--------------------------- podfile begin ----------------------------------
platform :ios, '10.0'

#添加如下两行代码，路径修改为我们的fluter module的路径
flutter_application_path = './ai-course'
load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')

target 'AiCourse' do

  use_frameworks!
 
  install_all_flutter_pods(flutter_application_path)
  
end

post_install do |installer|
  # 1. 遍历项目中所有target
  installer.pods_project.targets.each do |target|
    # 2. 遍历build_configurations
    target.build_configurations.each do |config|
      # 3. 修改build_settings中的ENABLE_BITCODE
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
//--------------------------- podfile end ----------------------------------

6、命令行进入flutter目录
7、flutter packages get
8、返回原生目录
9、pod install
10、原生项目中 bitcode = NO

11、编译出现 flutter.framework 无权限，修改 flutter 框架目录/packages/flutter-tools/bin/xcode_backend.sh
    144行
    原代码块
    RunCommand find "${derived_dir}/engine/Flutter.framework" -type f -exec chmod a-w "{}" \;
    修改代码块
    RunCommand find "${derived_dir}/engine/Flutter.framework" -type f \( -name '*.h' -o -name '*.modulemap' -o -name '*.plist' \) -exec chmod a-w "{}" \;
  
    148行
    原代码块
    RunCommand find "${derived_dir}/Flutter.framework" -type f -exec chmod a-w "{}" \;
    修改代码块
    RunCommand find "${derived_dir}/Flutter.framework" -type f \( -name '*.h' -o -name '*.modulemap' -o -name '*.plist' \) -exec chmod a-w "{}" \;