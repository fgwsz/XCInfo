#!/bin/bash
echo "you can input exit to abort git push."
read -p "input commit info: " commit_info
if [ "$commit_info" = "exit" ]; then
    echo "git push exit!"
else
    git add ./create.sh
    git add ./docx2img.sh
    git add ./webp2png.sh
    git add ./README.md
    git add ./git_push.sh
    git add ./input.txt
    git add ./template.doc
    git commit -m "$commit_info"
    git push
fi
