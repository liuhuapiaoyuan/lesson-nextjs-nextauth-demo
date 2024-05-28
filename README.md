## 项目初始化

```shell
npx create-next-app@latest lesson-nextjs-nextauth-demo

√ Would you like to use TypeScript? ... No / Yes
√ Would you like to use ESLint? ... No / Yes
√ Would you like to use Tailwind CSS? ... No / Yes
√ Would you like to use `src/` directory? ... No / Yes
√ Would you like to use App Router? (recommended) ... No / Yes
√ Would you like to customize the default import alias (@/*)? ... No / Yes
√ What import alias would you like configured? ... @/*
```


### 安装`next-auth`

```shell
npm i -S next-auth
```

### 初始化环境变量
这是一个工具用于帮我们初始化加密密钥，然后在`.env`文件中添加AUTH_SECRET

```shell
npx auth secret
```


### 初始化`src/auth.ts`文件

```typescript
import NextAuth from "next-auth"
import Credentials from "next-auth/providers/credentials"
 
export const { signIn, signOut, auth } = NextAuth({
  providers: [
    Credentials({
      credentials: {
        username: { label: "账号" },
        password: { label: "密码", type: "password" },
      },
      async authorize({ request }) {
        const response = await fetch(request)
        if (!response.ok) return null
        return (await response.json()) ?? null
      },
    }),
  ],
})
```

### 使用`handlers`导入到Api路由中

创建  `/src/app/api/auth/[...nextauth]/route.ts` 文件

```typescript
import { handlers } from "@/auth" // Referring to the auth.ts we just created
export const { GET, POST } = handlers
```

### 使用中间件 `middleware.ts`

```typescript
export { auth as middleware } from "@/auth"
```


### 如何使用组件

1. 在`ReactComponentServer`中使用 `auth`获得账号信息
2. 如何在`use client`的客户端组件中使用

2.1 现在服务端组件获取，然后再填充
2.2 使用 SessionProvider包裹后，子组件可以使用 `useSession`获取用户信息



### 二、 理解第三方登录(user/account) 使用gitee比较方便


### 三、 使用prisma-adapter进行数据库集成

```shell
npm install @prisma/client @auth/prisma-adapter
npm install prisma --save-dev
```


### 四 与`TypeScript`兼容


```typescript
// 扩展session类型
import NextAuth, { type DefaultSession } from "next-auth"
 
declare module "next-auth" {
  /**
   * Returned by `auth`, `useSession`, `getSession` and received as a prop on the `SessionProvider` React Context
   */
  interface Session {
    user: {
      /** The user's postal address. */
      address: string
      /**
       * By default, TypeScript merges new interface properties and overwrites existing ones.
       * In this case, the default session user properties will be overwritten,
       * with the new ones defined above. To keep the default session user properties,
       * you need to add them back into the newly declared interface.
       */
    } & DefaultSession["user"]
  }
}
```

然后我们可以`auth.js`中去查看