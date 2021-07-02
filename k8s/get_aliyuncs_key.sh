kubectl create secret docker-registry blue-yyy-regcred \
    --docker-server=registry.cn-hongkong.aliyuncs.com \
    --docker-username=yao3060@aliyun.com \
    --docker-password=Yf2pQhuvPUn6j1mx \
    --docker-email=yao3060@aliyun.com

kubectl get secret blue-yyy-regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
