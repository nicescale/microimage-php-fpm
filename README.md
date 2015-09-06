![php-fpm](https://csphere.cn/assets/d7b34ab5-5bfe-4909-aba1-17dc23a570fc)

## 如何使用该镜像

php-fpm一般是配合nginx镜像一起使用

### 在项目下放一个Dockerfile
```
from index.csphere.cn/microimages/php
add . /app
```

注意非php的静态文件，应该add到nginx容器里

## 构建运行
```
docker build -t my-php-app .
docker run -d --name php -p 8080:80 my-php-app
docker run -d --name nginx --net=container:php index.csphere.cn/microimages/nginx
```

## 安装额外扩展
由于base镜像使用了alpine，用的是apk包管理工具，你可以进入alpine容器，来搜索对应的php扩展包

```
docker run -it --rm index.csphere.cn/microimages/alpine sh -c "apk search php-* | grep myextension"
```

找到对应的软件包php-myextension后，编写Dockerfile如下：

```
from index.csphere.cn/microimages/php-fpm:5.6
run apk add --update php-myextension
```

## 开发环境使用
在开发环境为了更加高效，避免每次代码更新都进入build流程，可以：

```
php_image=index.csphere.cn/microimages/php-fpm
nginx_image=index.csphere.cn/microimages/nginx
docker run -d -v /myapp:/app --name myphp -p 8080:80 --link mysql:mysql-master.example.com --link mysql:mysql-slave.example.com $php_image
docker run -d -v /myapp:/app --name mynginx --net=container:myphp $nginx_image
```

上面我们用了两个link，一个用于主库，一个用于从库。建议开发过程中，使用生产环境分配好的名字，这样镜像部署到生产环境时，就不需要重新修改代码打包了。
我们在连结mysql时：

```
// connect to master
mysql_connect("mysql-master.example.com", 3306)

// connect to slave
mysql_connect("mysql-slave.example.com", 3306)
```
然后只需要在/myapp目录下编辑自己的代码就可以了

另一种方法是使用环境变量，环境变量的好处是你在不同的部署环境下，可以赋予不同的名字或值。比如：

```
php_image=index.csphere.cn/microimages/php-fpm
docker run -d -p 8080:80 -v /myapp:/app -e MYSQL_MASTER_HOST=192.168.1.2 -e MYSQL_SLAVE_HOST=192.168.1.2 $php_image
```
如果我们使用docker-compose部署，在不同环境部署时，需要注意修改yml配置里对应环境变量的值。

使用名字和环境变量，各有优劣。

## 生产环境使用
通过Dockerfile构建出应用镜像之后，在生产环境部署时，需要注意：

- 后端服务的名字，如数据库dbhost，redis主机的host等。由于我们已经在前面规范好了名字，所以部署到生产环境 就比较容易了。
- 日志收集, php的错误日志和访问日志，可以通过syslog进行收集

```
docker run -d -p 80:80 --log-driver=syslog --log-opt address=udp://syslogserver:514 my-php-app
```
这个时候docker logs是没有日志输出的，日志都转存到syslog server了

## 授权和法律

该镜像由希云制造，未经允许，任何第三方企业和个人，不得重新分发。违者必究。

## 支持和反馈

该镜像由希云为企业客户提供技术支持和保障，任何问题都可以直接反馈到: `docker@csphere.cn`

