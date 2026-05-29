# RuoYi 本地 Docker 部署

这个目录是一套独立的本地部署方案，用 Docker 在本机同时跑起：

- `nginx`：提供前端静态资源，并把 `/prod-api/*` 转发到后端
- `ruoyi-admin.jar`：后端服务
- `mysql`：业务数据库，首次启动时自动执行 `mysql/init/*.sql`
- `redis`：缓存服务

## 目录说明

- `docker-compose.yml`：容器编排入口
- `nginx/default.conf`：前端站点和 `/prod-api` 反向代理配置
- `scripts/prepare-artifacts.sh`：复制前端 `dist`、后端 `jar`、SQL 文件到部署目录
- `scripts/up.sh`：一键准备并启动
- `scripts/down.sh`：停止容器
- `scripts/logs.sh`：查看日志
- `.env.example`：部署变量示例

## 前提

你当前仓库里已经有这些构建产物：

- 前端包：`ruoyi-ui/RuoYi-Vue3/dist`
- 后端包：`ruoyi-admin/target/ruoyi-admin.jar`

当前仓库里也已经有数据库初始化脚本：

- `sql/ry_20260321.sql`
- `sql/quartz.sql`

## 一键启动

在仓库根目录执行：

```bash
chmod +x deploy/local-docker/scripts/*.sh
./deploy/local-docker/scripts/up.sh
```

脚本会自动做这些事：

1. 复制前端 `dist` 到 `deploy/local-docker/artifacts/frontend`
2. 复制后端 `jar` 到 `deploy/local-docker/artifacts/backend/ruoyi-admin.jar`
3. 复制 `sql/*.sql` 到 `deploy/local-docker/mysql/init`
4. 若不存在 `.env`，自动从 `.env.example` 生成
5. 执行 `docker compose up -d`

## 访问地址

- 前端首页：`http://localhost`
- 前端代理后的后端接口根路径：`http://localhost/prod-api`
- 后端直连：`http://localhost:8080`
- Swagger 代理访问：`http://localhost/prod-api/swagger-ui/index.html`
- Druid 代理访问：`http://localhost/prod-api/druid/login.html`

## 停止与日志

停止：

```bash
./deploy/local-docker/scripts/down.sh
```

查看全部日志：

```bash
./deploy/local-docker/scripts/logs.sh
```

查看单个服务日志：

```bash
./deploy/local-docker/scripts/logs.sh backend
./deploy/local-docker/scripts/logs.sh nginx
./deploy/local-docker/scripts/logs.sh mysql
./deploy/local-docker/scripts/logs.sh redis
```

## 接口关联方式

前端生产包里 `VITE_APP_BASE_API=/prod-api`，因此浏览器会请求：

- `/prod-api/login`
- `/prod-api/getInfo`
- `/prod-api/system/user/list`

Nginx 会把 `/prod-api/*` 代理到后端容器 `backend:8080/*`，同时去掉 `/prod-api` 前缀。

例如：

- 浏览器请求 `http://localhost/prod-api/login`
- Nginx 转发到 `http://backend:8080/login`

## 数据持久化

这些目录会在本地保存数据：

- `data/mysql`：MySQL 数据文件
- `data/redis`：Redis 持久化数据
- `data/profile`：若依上传文件目录
- `logs/nginx`：Nginx 日志

## 重要说明

1. `mysql/init/*.sql` 只会在 MySQL 数据目录为空时自动导入一次。
如果你已经启动过 MySQL，再修改 SQL 脚本不会自动重放；这时需要清理 `data/mysql` 后重建。

2. 后端容器里通过环境变量覆盖了默认配置：
- 数据库地址改成 `mysql:3306`
- Redis 地址改成 `redis:6379`
- 上传目录改成 `/data/profile`

3. 如果本机的 `80`、`8080`、`3306`、`6379` 端口已被占用，可以修改 `.env` 后重新启动。

4. 如果 MySQL 启动日志里出现下面这类错误：
- `unknown variable 'default-authentication-plugin=mysql_native_password'`
- `The designated data directory /var/lib/mysql/ is unusable`
- `Table 'mysql.plugin' doesn't exist`

通常说明之前一次失败启动把 `data/mysql` 初始化坏了。处理方式是先停容器，再删除 `deploy/local-docker/data/mysql`，然后重新执行 `up.sh`。

5. Docker 初始化目录里的 SQL 现在会在复制时自动补上 `SET NAMES utf8mb4;`，并先执行数据库字符集声明，避免中文初始化数据被错误导入成乱码。

## 常见重置

完全重置这套本地环境：

```bash
./deploy/local-docker/scripts/down.sh
rm -rf deploy/local-docker/data/mysql
rm -rf deploy/local-docker/data/redis
./deploy/local-docker/scripts/up.sh
```

仅重置 MySQL 数据：

```bash
./deploy/local-docker/scripts/down.sh
rm -rf deploy/local-docker/data/mysql
./deploy/local-docker/scripts/up.sh
```

如果你已经遇到“侧边菜单中文乱码”，推荐按下面步骤完整重建 MySQL：

```bash
./deploy/local-docker/scripts/down.sh
rm -rf deploy/local-docker/data/mysql
./deploy/local-docker/scripts/prepare-artifacts.sh
./deploy/local-docker/scripts/up.sh
./deploy/local-docker/scripts/logs.sh mysql backend
```

重建后请使用全新初始化的数据重新登录；如果页面仍然显示旧菜单数据，强制刷新浏览器缓存后再试一次。
