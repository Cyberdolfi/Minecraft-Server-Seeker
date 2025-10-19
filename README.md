# 🌐 Server Seeker

> [!NOTE]
> Languages:  
> **[[🇩🇪] Deutsch](./README_de.md)**  
> **[[🇬🇧] *English*](./README.md)**

[![GitHub Dowloads](https://shields.io/github/downloads/Dolfirobots/OnlyProxy/total?label=Downloads&logoColor=Green&color=Blue&style=flat)](https://github.com/Dolfirobots/OnlyProxy/releases)
[![GitHub Release](https://img.shields.io/github/v/release/Dolfirobots/OnlyProxy?color=Green)](https://github.com/Dolfirobots/OnlyProxy/releases "OnlyProxy Releases")
[![Discord](https://img.shields.io/discord/1079052573845241877.svg?logo=discord&logoColor=Green&color=Blue&labelColor=Green&label=Discord)](https://discord.gg/dxZTGpPbkd "Discord")

> [!NOTE]
> This Project is currently under alpha versions!
> The first beta release coming up very soon...

The **Server Seeker** by Cyberdolfi is an Minecraft server scanner,  
that tries to find as much servers as he can.

---

## ✨ Features
- ✅ Scan in a good time a lot of servers
- ✅ Uses all ping protocols
- ✅ You can controll the server seeker with a Discord bot
- ✅ Easy to install and configure
- ✅ Saves data in a MySQL or MariaDB database
- ⏳ Coming soon: Proxy support 


### 📑 What data does it save?
- Players online
- Players max
- Motd
- Server version
- Server software
- Mods
- Plugins
- Online Mode
- Whitelist (Not in all cases)

---

## 📥 Installation
For installation, go to our [WIKI]()

---

## 🛡️ Permissions

There is one permission for commands like `/onlyproxy reload|version`:

```
onlyproxy.commands
```

---

## 📑 Logs

The plugin automatically creates log entries when someone tries to join without a proxy (or in general).  
You can find the logs here:

```
/plugins/OnlyProxy/logs/
```

### Example log
> [!NOTE]  
> The IPs in this example are randomly generated

```
log_2025-08-25.log:

[12:03:12] [PASSED] Playername: TestPlayer | Player IP: 12.122.12.12 | Proxy IP: 132.13.12.21  
[15:09:32] [BLOCKED] Playername: HackerPlayer | Player IP: 32.223.23.23 | Proxy IP: 300.30.300.30
```
---

## 📜 License

This project is licensed under the [MIT License](./LICENSE).

---

## 🤝 Contributing

* Found a bug? → [Create an issue](https://github.com/Dolfirobots/OnlyProxy/issues)  
* Have ideas or suggestions? → Join my [Discord](https://discord.gg/dxZTGpPbkd "Discord")

---

[![](https://bstats.org/signatures/bukkit/OnlyProxy.svg)](https://bstats.org/plugin/bukkit/OnlyProxy)
