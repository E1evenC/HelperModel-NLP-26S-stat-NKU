#!/bin/bash

# 遇到错误立即停止执行
set -e

echo "Starting environment configuration..."

echo "Upgrading pip..."
python -m pip install --upgrade pip -i https://mirrors.aliyun.com/pypi/simple

# 1. 安装 Unsloth 核心库
echo "Installing unsloth..."
python -m pip install unsloth -i https://mirrors.aliyun.com/pypi/simple

# 2. 安装相关依赖
echo "Installing dependencies (xformers, trl, peft, accelerate, bitsandbytes)..."
python -m pip install --no-deps xformers trl peft accelerate bitsandbytes -i https://mirrors.aliyun.com/pypi/simple

# 3. 安装 ModelScope 用于高速下载模型
echo "Installing modelscope..."
python -m pip install modelscope -i https://mirrors.aliyun.com/pypi/simple

# 4. 升级 transformers 保证模型兼容性
echo "Upgrading transformers..."
python -m pip install --upgrade transformers -i https://mirrors.aliyun.com/pypi/simple

echo "Environment configuration completed successfully."
