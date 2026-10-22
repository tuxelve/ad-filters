#!/bin/bash

#进入目录
cd $(cd "$(dirname "$0")";pwd)

# 定义要下载的 URL
urls=(
    "https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt"
    "https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/apple-cn.txt"
    "https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/google-cn.txt"
)

for url in "${urls[@]}"; do
    curl -sS "$url" >> urls.txt
done

# 处理下载的文本文件
ls urls.txt | grep -vE '.*proxy.*' | xargs sed "s/^full://g;/^regexp:.*$/d;s/^/[\//g;s/$/\/]https:\/\/dns.alidns.com\/\dns-query/g" -i

# 合并处理过的文本文件和 df.txt 文件
cat ../rules/df.txt $(ls -1tr urls.txt) > upstream_dns.txt

#移动规则
mv upstream_dns.txt ../rules/upstream_dns.txt

# 清理下载的文本文件
rm -rf ./*.txt
