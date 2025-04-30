#!/bin/bash
# 输入参数检查
if [ $# -ne 1 ]; then
    echo "用法: $0 <输入文件.docx>"
    exit 1
fi
input_file="$1"
# 验证文件格式
if [[ ! "$input_file" =~ \.docx$ ]]; then
    echo "错误：仅支持 .docx 格式文件！"
    exit 1
fi
if [ ! -f "$input_file" ]; then
    echo "错误：文件 '$input_file' 不存在！"
    exit 1
fi
# 创建临时解压目录
temp_dir=$(mktemp -d)
echo "解压文件到临时目录: $temp_dir"
# 解压.docx文件
unzip -q "$input_file" -d "$temp_dir"
# 检查是否存在图片目录
media_dir="$temp_dir/word/media"
if [ ! -d "$media_dir" ]; then
    echo "未找到图片目录，文件中可能不含图片。"
    rm -rf "$temp_dir"
    exit 0
fi
# 提取图片到当前目录
echo "提取图片中..."
image_count=0
for image in "$media_dir"/*; do
    filename=$(basename "$image")
    cp "$image" "./$filename"
    ((image_count++))
done
# 清理临时目录
rm -rf "$temp_dir"
echo "完成！提取到 $image_count 张图片。"
