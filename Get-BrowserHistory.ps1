# 定义函数 ConvertFrom-Json20
function ConvertFrom-Json20([object] $item){
    # 引用 System.Web.Extensions 程序集
    Add-Type -AssemblyName System.Web.Extensions
    # 创建 JavaScriptSerializer 对象
    $ps_js = New-Object System.Web.Script.Serialization.JavaScriptSerializer
    # 反序列化 JSON 对象
    return ,$ps_js.DeserializeObject($item)
}

# 定义函数 Get-ChromeHistory
function Get-ChromeHistory {
    # 获取当前用户的用户名
    $UserName = $env:UserName
    # 检查是否存在 Chrome 历史记录文件
    $Path = "$Env:systemdrive\Users\$UserName\AppData\Local\Google\Chrome\User Data\Default\History"
    if (-not (Test-Path -Path $Path)) {
        Write-Verbose "[!] Could not find Chrome History for username: $UserName"
        return
    }
    # 定义正则表达式，匹配 URL
    $Regex = '(htt(p|s))://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?'
    # 读取 Chrome 历史记录文件，并匹配出 URL
    $Value = Get-Content -Path $Path | Select-String -AllMatches $regex | % {($_.Matches).Value} | Sort-Object -Unique
    # 遍历 URL，并输出到控制台
    foreach ($url in $Value) {
        Write-Output $url
    }
}

# 调用函数 Get-ChromeHistory 获取浏览记录，并输出到控制台
Get-ChromeHistory
