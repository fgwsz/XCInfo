#!/bin/bash
set -e  # 遇到错误立即终止脚本
# 获取当前日期（格式：20250327）
today_dir=$(date +"%Y%m%d")
# 定义需要创建的子目录数组
sub_dirs=("图片" "初稿" "发布")
# 检查并创建今日主目录
if [ ! -d "$today_dir" ]; then
    echo "创建主目录: $today_dir"
    mkdir -p "$today_dir"
else
    echo "目录已存在: $today_dir"
fi
# 强制创建子目录（无论主目录新旧）
(
    echo "正在初始化子目录..."
    cd "$today_dir" || { echo "无法进入目录: $today_dir" >&2; exit 1; }
    mkdir -p "${sub_dirs[@]}"  # -p参数自动忽略已存在目录
)
# 验证目录结构
if ! [ -d "$today_dir/图片" ] || ! [ -d "$today_dir/初稿" ] || ! [ -d "$today_dir/发布" ]; then
    echo "子目录创建失败！" >&2
    exit 1
fi
# 文件拷贝逻辑（带路径校验）
copy_with_check() {
    local src=$1
    local dest=$2
    if [ ! -e "$dest" ]; then
        echo "拷贝: $src → ${dest##*/}"
        cp "$src" "$dest"
    else
        echo "跳过: ${dest##*/} 已存在"
    fi
}
copy_with_check "webp2png.sh" "$today_dir/图片/webp2png.sh"
copy_with_check "template.doc" "$today_dir/初稿/初稿.doc"
copy_with_check "input.txt" "$today_dir/初稿/投喂.txt"
copy_with_check "docx2img.sh" "$today_dir/发布/docx2img.sh"
echo -e "\n当前目录结构:"
tree -f "$today_dir"
