# Caddy + V2ray
> 完整配置 ：以railway为例

> 镜像部署：
> 
> 开放端口：caddy:80,v2ray:1080
> 
> 环境变量： DOMAIN（80端口的域名）；UUID（不填时使用默认值）

## 使用Cloudflare 进行反代
> 创建Workers
> 添加自定义域名或路由  
```
export default {
    async fetch(request, env) {
        let url = new URL(request.url);
        if (url.pathname.startsWith('/')) {
            var arrStr = [
                '****.up.railway.app', // 此处单引号里填写你的railway容器的公开域名
            ];
            url.protocol = 'https:'
            url.hostname = getRandomArray(arrStr)
            let new_request = new Request(url, request);
            return fetch(new_request);
        }
        return env.ASSETS.fetch(request);
    },
};
function getRandomArray(array) {
  const randomIndex = Math.floor(Math.random() * array.length);
  return array[randomIndex];
}
```
