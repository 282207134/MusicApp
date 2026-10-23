# Music Studio · Flutter 音乐 App

根据用户提供的 Pixso 音乐应用设计实现，包含 **9 个界面、浅色与深色两套主题**。封面来自设计稿，Poppins 字体随应用打包，界面与演示音频均可离线使用。

## 主要界面

下图为 iPhone 16e 模拟器中的实际运行截图。

| 探索音乐 | 搜索结果 |
| --- | --- |
| ![探索主页](docs/screenshots/01-home-light.png) | ![搜索结果](docs/screenshots/04-search-results-light.png) |

| 专辑详情 | 播放器 |
| --- | --- |
| ![专辑详情](docs/screenshots/06-album-light.png) | ![播放器](docs/screenshots/08-player-light.png) |

| 深色主页 | 深色设置 |
| --- | --- |
| ![深色主页](docs/screenshots/01-home-dark.png) | ![深色设置](docs/screenshots/09-settings-dark.png) |

[全部 18 张页面截图](docs/screenshots/README.md) · [项目结构与架构说明](docs/ARCHITECTURE.md) · [Pixso 对照记录](docs/design/REFERENCE.md)

## 已实现

| 页面 | 交互与内容 |
| --- | --- |
| Home / Explore | 推荐专辑、最近播放、新发行、歌手、曲风入口；横向滑动与纵向滚动 |
| Trending | 按曲风、年份筛选，歌曲播放、更多操作、热门专辑 |
| Search | 输入搜索、热门搜索词、示例搜索记录、歌手入口 |
| Search Result | 按歌曲名、歌手和曲风检索，结果列表及无结果状态 |
| Library | 专辑网格、收藏歌曲切换；收藏结果即时更新 |
| Album | 专辑信息、歌曲序号、整张播放、歌曲播放 |
| Artist | 歌手信息、本地关注状态、热门歌曲、专辑入口 |
| Player | 本地音频播放/暂停、上一首/下一首、拖动进度、封面滑动切歌、收藏、随机、单曲循环、队列 |
| Settings | 本地资料邮箱编辑、偏好设置、明暗主题切换 |

五个主导航页面保留各自的滚动和输入状态。迷你播放器与完整播放器共享状态。主题、收藏、关注、邮箱与设置偏好持久化到本地。

## 运行

开发与验证环境：Flutter 3.41.6 / Dart 3.11.4，iOS 26.0 的 iPhone 16e 模拟器。

```bash
flutter pub get
flutter run
```

可指定已启动的设备：

```bash
flutter devices
flutter run -d <device-id>
```

项目包含 iOS、Android、Web 工程。此次实际验证平台为 iOS 模拟器；Android 与浏览器未进行运行验收。

## 检查与截图

```bash
flutter analyze
flutter test
# 在 iOS 模拟器上运行完整流程，并重新生成 18 张截图
./scripts/capture_screenshots.sh <simulator-id>
```

截图脚本运行集成测试，会清空**本应用**的本地偏好，以获得可重复的初始画面。测试会验证真实音频进度、暂停、收藏、关注、随机、循环、队列、搜索和主题切换。

## 演示范围

这是可以运行和交互的 UI App，歌曲、专辑和歌手信息来自本地示例目录。所有歌曲播放同一段随项目附带的原创合成演示音频（约 3 分 36 秒），播放器底部明确标记 `Original demo audio`；并非封面所示商业歌曲的录音。

账户没有连接登录服务，不存储账户密码。Offline Mode、Music Quality 与 Audio Normalisation 保存的是本地 UI 偏好；没有实现网络下载、动态码率或响度分析。当前资源本身全部离线。Autoplay 控制曲目结束后是否继续下一首。背景播放、锁屏控制、真实曲库和服务端账户可在现有状态层继续接入。

## 代码与资源整理

运行代码仅保留 `lib/` 中的 11 个 Dart 文件，按核心状态、数据、页面和共享组件组织。已移除 Pixso 导出的重复定位代码、默认计数器示例、临时导出清单与无用原图；封面压缩为本地 JPEG，资源目录约 4.4 MB。字体许可证位于 `assets/fonts/OFL.txt`。

## 验证结果（2026-10-23）

`flutter analyze` 无问题，`flutter test` 的 5 项测试全部通过。iPhone 16e 模拟器完整集成流程通过，已验证原生音频进度并生成 18 张 1170×2532 页面截图，主要页面和两套主题已做视觉检查。
