# MPConfuse
A support code obfuscation for iOS or macOS

## Description 描述
* 支持指定的方法的混淆达到混淆加密效果
* 暂时适用于指定前缀方法的混淆
* 不入侵代码

## Usage 使用方法
### 第一步 
* 将子文件夹MPConfuseClasses拖入到项目根目录中（Pods同级目录）。

### 第二步 
* 将MPConfuseClasses拖拽到项目中,
* 取消勾选Copy items if needed（否则会有路径错误）。

### 第三步 添加PCH文件
* 点击Projiect->TARGETS->Build Settings 搜索"Prefix Header"
* 找到Prefix Header输入"$PROJECT_DIR/MPConfuseClasses/PrefixHeader.pch"（不包含引号）
* 将Precompile Prefix Header 设置为YES （提高编译速度）
* 如果自带PCH文件 可以将 codeObfuscation.h导入到PCH文件即可
### 第四步 添加Run Script
* 点击Projiect->TARGETS->Build Phases 
* 点击左上角"+"选择New Run Script Phase
* 添加"$PROJECT_DIR/MPConfuseClasses/confuse.sh"到空白区域（不包含引号）
### 第五步 编译
* COMMAND+B 编译 查看codeObfuscation.h内容是否发生变化 

## Test 测试方法
* 安装 Class-dump[下载地址](http://stevenygard.com/projects/class-dump/)
* class-dump -H /projict.app -o /heads
* /projict.app是app的路径 
* /heads是存放dump出来头文件的文件夹路径
* 查看/heads目录的指定头文件的方法名即可

## 联系方式:
* WeChat : wzw351420450
* Email : mopellet@foxmail.com
* Resume : [个人简历](https://github.com/MoPellet/Resume)
