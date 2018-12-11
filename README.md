# nacos swarm 阿里云 搭建
# nacos 暂时不支持 swarm集群搭建
##方法如下
#通过dockerfile 创建镜像
#在阿里云swarm / k8s 创建应用，容器节点固定为1个，设置主机名,集群列表
#aliyun.scale: '1'
#hostname: nacos-node1
#NODE_LIST: 'nacos-node1:8848 nacos-node2:8848 nacos-node3:8848'
#导入初始化表

#https://nacos.io/zh-cn/docs/cluster-mode-quick-start.html
