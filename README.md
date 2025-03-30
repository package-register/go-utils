# 📦 Go 项目工具库

![Go Version](https://img.shields.io/badge/go-%3E%3D1.20-blue)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

🔧 提供基础开发工具链的 Go 模块集合

## 🧩 功能模块

### 📦 构建工具 (`build/`)

- 基础编译框架
- 测试覆盖率统计
- 版本号自动生成

### 🗂️ 缓存组件 (`cache/`)

- 内存缓存实现
- 并发安全访问
- 基础失效策略

### 🐳 Docker 工具 (`docker/`)

- 镜像构建辅助
- 容器生命周期管理
- 基础健康检查

### 🔄 发布流程 (`gitops/`)

- 版本标签管理
- 自动化发布流水线
- GitHub Actions 集成

## 🚀 快速开始

### 环境要求

- Go 1.20+
- Git 2.30+

### 安装使用

```bash
go get github.com/package-register/go-utils
```

### 常用命令

```bash
# 查看所有可用命令
make help

# 提交代码变更（交互式）
make commit

# 运行单元测试
make test

# 创建新版本并发布
make push
```

## 📋 Makefile 指令

```bash
# 添加/更新远程仓库
make add-remote [repo-url]

# 清理构建产物
make clean

# 生成新版本标签
make bump-version
```

## 🤝 贡献指南

### 复刻项目

```bash
git clone https://github.com/package-register/go-utils.git
cd go-utils
```

### 步骤

1. Fork 项目仓库
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交修改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

## 📄 许可证

本项目采用 [MIT 许可证](LICENSE)

---

🦄 Made with ❤️ by oAo Team | 📧 hnkong666@gmail.com
