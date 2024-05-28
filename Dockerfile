# 第一阶段: 构建 Next.js 应用
FROM node:18-alpine AS builder

# 设置工作目录
WORKDIR /app

# 复制 package.json 和 package-lock.json
COPY package.json package-lock.json ./

# 安装依赖
RUN npm install

# 复制应用的其余代码
COPY . .
# 用 Docker 版本的配置文件覆盖 next.config.js
COPY ./next.config.docker.mjs ./next.config.mjs

# 构建 Next.js 应用
RUN npm run build 


# 第二阶段: 使用 distroless 镜像运行应用
#FROM node:18-alpine 
FROM gcr.io/distroless/nodejs18-debian12	

# 设置工作目录
WORKDIR /app

# 从构建阶段复制构建好的应用和 node_modules
COPY --from=builder /app/.next/standalone ./
# 这些资源可以挂载到CDN
COPY --from=builder /app/.next/static  ./.next/static
# 这些资源可以挂载到CDN
COPY --from=builder /app/public  ./public

# 暴露应用运行的端口
EXPOSE 3000

# 运行应用的命令
CMD ["/app/server.js"]
