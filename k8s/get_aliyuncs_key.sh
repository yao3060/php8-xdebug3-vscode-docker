kubectl create secret docker-registry blue-yyy-regcred \
    --docker-server=registry.cn-hangzhou.aliyuncs.com \
    --docker-username=****@aliyun.com \
    --docker-password=**** \
    --docker-email=****@aliyun.com

kubectl get secret blue-yyy-regcred --output="jsonpath={.data.\.dockerconfigjson}" | base64 --decode
