##获取jdk1.8镜像
FROM        java:8-jdk
##获取jdk 环境变量
ENV         JAVA_HOME         /usr/lib/jvm/java-8-openjdk-amd64
##修改时间区
RUN         rm /etc/localtime -rf &&\
            cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
##设置DNS
RUN         echo 'nameserver 10.200.0.6' >/etc/resolv.conf
##创建应用目录
RUN         mkdir -p /opt/applications
##获取nacos0.6版本
RUN         cd /opt/applications/ && wget https://github.com/alibaba/nacos/releases/download/0.6.0/nacos-server-0.6.0.tar.gz
##解压nacos
RUN         cd /opt/applications/ && tar xvf nacos-server-0.6.0.tar.gz
##设置nacos数据库配置文件(默认使用单个数据库)
RUN         echo 'db.num=1' >> /opt/applications/nacos/conf/application.properties &&\
            echo 'db.url.0=jdbc:mysql://${RDS_HOSTNAME}/${RDS_DB_NAME}?characterEncoding=utf8&connectTimeout=1000&socketTimeout=3000&autoReconnect=true' >> /opt/applications/nacos/conf/application.properties &&\
            echo 'db.user=${RDS_USERNAME}' >> /opt/applications/nacos/conf/application.properties &&\
            echo 'db.password=${RDS_PASSWORD}' >> /opt/applications/nacos/conf/application.properties
##设置启动命令
CMD         echo ''> /opt/applications/nacos/conf/cluster.conf &&\
            for i in $(echo $NODE_LIST); do echo $i >> /opt/applications/nacos/conf/cluster.conf ;done &&\
            java -server -Xms2g -Xmx2g -Xmn1g -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=320m -XX:-OmitStackTraceInFastThrow -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/applications/nacos/logs/java_heapdump.hprof -XX:-UseLargePages -Xloggc:/opt/applications/nacos/logs/nacos_gc.log -verbose:gc -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCTimeStamps -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=10 -XX:GCLogFileSize=100M -Dnacos.home=/opt/applications/nacos -jar -Duser.timezone=Asia/Shanghai /opt/applications/nacos/target/nacos-server.jar  --spring.config.location=classpath:/,classpath:/config/,file:./,file:./config/,file:/opt/applications/nacos/conf/ --logging.config=/opt/applications/nacos/conf/nacos-logback.xml 
