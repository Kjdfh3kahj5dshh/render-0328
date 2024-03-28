#!/bin/bash

check_file_and_download() {
    local file_name=$1
    local url=$2
    local extract_cmd=$3
    local clean_cmd=$4

    if [ ! -f "${file_name}" ]; then
        wget -t 2 -T 10 -N "${url}" -o /dev/null
        eval "${extract_cmd}"
        eval "${clean_cmd}"
    fi
}

make_executable_and_export() {
    local file_name=$1
    chmod +x "${file_name}"
}

# 设置环境变量
setup_environment_variables() {
    export TRANSPORT="http2"
    export TOKEN=""
    export CLIENT_ID="3a74d0f8-294d-4a5e-aad5-400c90b9e2e8"
    export MONITOR_SERVER="nezha.ovdlyvi.eu.org"
    export MONITOR_PORT="443"
    export MONITOR_KEY="rueUyUyl1694Loo2ee"
    export USE_TLS="1"
}

# 定义软件下载地址
AGENT_URL="https://github.com/nezhahq/agent/releases/latest/download/nezha-agent_linux_amd64.zip"
GOST_URL="https://github.com/go-gost/gost/releases/download/v3.0.0-rc8/gost_3.0.0-rc8_linux_amd64v3.tar.gz"
NODE_URL="https://cdn.jsdelivr.net/npm/@3kmfi6hp/nodejs-proxy@latest/dist/nodejs-proxy-linux"

# 检查并下载文件
check_file_and_download "agent" "${AGENT_URL}" "unzip -qod ./ nezha-agent_linux_amd64.zip &> /dev/null; mv nezha-agent agent" "rm -f nezha-agent_linux_amd64.zip"
check_file_and_download "cloudflared" "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64" "" ""
check_file_and_download "gost" "${GOST_URL}" "tar -xzvf gost_3.0.0-rc8_linux_amd64v3.tar.gz &> /dev/null; mv gost_3.0.0-rc8_linux_amd64v3/gost ." "rm -rf gost_3.0.0-rc8_linux_amd64v3.tar.gz gost_3.0.0-rc8_linux_amd64v3 README* LICENSE"
check_file_and_download "node" "${NODE_URL}" "" ""

# 赋予执行权限
make_executable_and_export "agent"
make_executable_and_export "cloudflared"
make_executable_and_export "gost"
make_executable_and_export "node"

# 设置环境变量
setup_environment_variables

# 启动相关应用程序
echo "[INFO] Starting services..."
./agent -s "${MONITOR_SERVER}:${MONITOR_PORT}" -p "${MONITOR_KEY}" --tls &

# 其他服务可以根据上述模式启动

# 保持进程活跃
while true; do sleep 60; done
