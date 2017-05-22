#!/usr/bin/env bash

#  Created by mopellet
#  GitHub:https://github.com/MoPellet/MPConfuse
#  Other tools to see https://github.com/MoPellet/MPConfuse



#需要混淆的方法前缀(根据实际情况去修改需要混淆的指定方法)
#注意：
#1.方法前缀最好是小写
#2.区分大小写
#一般仅需修改该参数
FUNC_PREFIX="mp_"

#####################General config begin############################
#以下配置可以按需更改
#保存的数据表名称
TABLENAME=symbols
#保存的数据表路径
SYMBOL_DB_FILE="$PROJECT_DIR/MPConfuseClasses/symbols"
#混淆的方法名称列表
STRING_SYMBOL_FILE="$PROJECT_DIR/MPConfuseClasses/func.list"
#混淆的项目目录
CONFUSE_FILE="$PROJECT_DIR/"
#生成代码混淆的结果宏定义文件
HEAD_FILE="$PROJECT_DIR/MPConfuseClasses/codeObfuscation.h"
#####################General config end##############################


################codeObfuscation.h config begin################
#生成编译的codeObfuscation.h文件配置一般可不作更改
#def前缀 mp_
CODEOBFUSCATION_PREFIX=$FUNC_PREFIX
#def后缀_codeObfuscation_h
CODEOBFUSCATION_SUFFIX="_codeObfuscation_h"
#完整def mp__codeObfuscation_h
FULL_CODEOBFUSCATION=$FUNC_PREFIX$CODEOBFUSCATION_SUFFIX
################codeObfuscation.h config end##################

export LC_CTYPE=C

#取以.m或.h结尾的文件以+号或-号开头的行
#去掉所有+号或－号
#用空格代替符号
#n个空格跟着<号 替换成 <号
#开头不能是IBAction
#用空格split字串取第二部分
#排序
#去重复
#删除空行
#删掉以init开头的行>写进STRING_SYMBOL_FILE
grep -h -r -I  "^[-+]" $CONFUSE_FILE  --include '*.[mh]' |sed "s/[+-]//g"|sed "s/[();,: *\^\/\{]/ /g"|sed "s/[ ]*</</"| sed "/^[ ]*IBAction/d"|awk '{split($0,b," "); print b[2]; }'| sort|uniq |sed "/^$/d"|sed -n "/^$FUNC_PREFIX/p" >$STRING_SYMBOL_FILE

#数据表相关方便作排重
createTable()
{
echo "create table $TABLENAME(src text, des text);" | sqlite3 $SYMBOL_DB_FILE
}

insertValue()
{
echo "insert into $TABLENAME values('$1' ,'$2');" | sqlite3 $SYMBOL_DB_FILE
}

query()
{
echo "select * from $TABLENAME where src='$1';" | sqlite3 $SYMBOL_DB_FILE
}

ramdomString()
{
openssl rand -base64 64 | tr -cd 'a-zA-Z' |head -c 16

}

rm -f $SYMBOL_DB_FILE
rm -f $HEAD_FILE
createTable

touch $HEAD_FILE
echo -e "#ifndef $FULL_CODEOBFUSCATION \n#define $FULL_CODEOBFUSCATION" >> $HEAD_FILE
echo "//confuse string at `date`" >> $HEAD_FILE
cat "$STRING_SYMBOL_FILE" | while read -ra line; do
if [[ ! -z "$line" ]]; then
ramdom=`ramdomString`
echo $line $ramdom
insertValue $line $ramdom
echo "#define $line $ramdom" >> $HEAD_FILE
fi
done
echo "#endif" >> $HEAD_FILE

sqlite3 $SYMBOL_DB_FILE .dump

