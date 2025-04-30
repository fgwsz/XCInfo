#!/bin/bash
# 检测依赖命令是否存在
if ! command -v dwebp &> /dev/null; then
    echo "错误：未找到 dwebp 命令，请先安装 libwebp 工具包" >&2
    echo "Ubuntu安装：sudo apt install webp"
    echo "MacOS安装：brew install webp"
    exit 1
fi
# 获取当前目录下所有.webp文件（包括含空格的文件名）
mapfile -d '' webp_files < <(find . -maxdepth 1 -name "*.webp" -print0)

if [ ${#webp_files[@]} -eq 0 ]; then
    echo "当前目录未找到.webp文件"
    exit 
fi
success_count=0
fail_count=0
for input_file in "${webp_files[@]}"; do
    output_file="${input_file%.webp}.png"
    # 存在性校验
    if [ -f "$output_file" ]; then
        echo -e "跳过: \e[33m${input_file#./}\e[0m → ${output_file#./} 已存在"
        continue
    fi
    echo -n "转换: ${input_file#./} → ${output_file#./} ... "
    if dwebp "$input_file" -o "$output_file" >/dev/null 2>&1; then
        echo "✓"
        ((success_count++))
    else
        echo "✗"
        ((fail_count++))
        echo "[$(date +%FT%T)] 失败: $input_file" >> webp_convert.log
    fi
done
# 生成统计报告
echo -e "\n转换完成 | 成功: \e[32m$success_count\e[0m 失败: \e[31m$fail_count\e[0m"
[ -f webp_convert.log ] && echo "失败记录已保存到: webp_convert.log"
