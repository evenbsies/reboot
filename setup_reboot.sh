#!/bin/bash

# 设置脚本文件路径
SCRIPT_PATH="/usr/local/bin/restart_server.sh"

# 创建重启脚本
echo "创建重启脚本..."
echo "#!/bin/bash" > $SCRIPT_PATH
echo "/sbin/shutdown -r now" >> $SCRIPT_PATH

# 赋予重启脚本执行权限
echo "为重启脚本赋予执行权限..."
chmod +x $SCRIPT_PATH

# 设置 cron 任务，每天凌晨3点重启
echo "设置定时任务..."
(crontab -l 2>/dev/null; echo "0 3 * * * $SCRIPT_PATH") | crontab -

# 验证是否成功添加了定时任务
echo "当前的定时任务列表："
crontab -l

# 检查 cron 服务状态
echo "检查 cron 服务状态..."
if systemctl is-active --quiet cron; then
    echo "cron 服务正在运行。"
else
    echo "cron 服务未运行，正在启动..."
    systemctl start cron
    echo "cron 服务已启动。"
fi

echo "设置完成，每天凌晨3点服务器将自动重启。"
