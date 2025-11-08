# Bukkit project template

### Installation:

1. Clone this repository
```shell
git clone https://github.com/xap3y/TemplateBukkitGradle.git
cd TemplateBukkitGradle
```
2. Modify gradle.properties 
3. Refactor the project \
    2.1 change the `group`, `baseCoordinates` and `version` in the `gradle.properties` file. \
    2.2 change the `main` and `name` in the `src/main/resources/plugin.yml` file.

#### Fast installation (Linux only):

This will create the project in the active directory

```shell
curl -fsSL https://static.xap3y.space/install.sh | bash
```

<br>
<details>
<summary> <b>List of features implemented in this project: </b></summary>

- [x] [Paper API 1.21.10](https://jd.papermc.io/paper/1.21.10/)
- [x] [XaGUI](https://xagui.xap3y.space)
- [x] [Cloud V2](https://cloud.incendo.org/minecraft/paper/)
- [x] [Blossom](https://blossom.kyori.net)
- [x] [Lombok](https://projectlombok.org/)
- [x] [ParticleNativeAPI](https://github.com/Fierioziy/ParticleNativeAPI)
- [x] [XSeries](https://www.spigotmc.org/threads/xseries-xmaterial-xparticle-xsound-xpotion-titles-actionbar-etc.378136/)
- [x] [bStats](https://bstats.org/)
- [x] [AnvilGUI](https://github.com/WesJD/AnvilGUI)
- [x] [PlaceholderAPI](https://wiki.placeholderapi.com/developers/using-placeholderapi/)
- [x] [SkriptAPI](https://docs.skriptlang.org/javadocs/)
- [x] [TownyAdvanced](https://github.com/TownyAdvanced/Towny)
- [x] [WorldGuardAPI](https://worldguard.enginehub.org/en/latest/developer/)
- [x] [SlimeFun4API](https://slimefun.github.io/javadocs/Slimefun4/docs/)
- [x] [Item-NBT-API](https://github.com/tr7zw/Item-NBT-API)
- [x] [log4j-core](https://mvnrepository.com/artifact/org.apache.logging.log4j/log4j-core)
- [x] [MariaDB Java Client](https://mariadb.com/kb/en/about-mariadb-connector-j/)
- [x] [LuckPerms API](https://luckperms.net/wiki/Developer-API#gradle)
- [x] [GriefPrevention](https://github.com/GriefPrevention/GriefPrevention/)
- [x] [JUnit](https://junit.org/junit5/) and [MockBukkit](https://github.com/MockBukkit/MockBukkit/tree/v1.20)

</details>
<br>

<details>
<summary><b>Instruction for permanent installation: </b></summary>

1. OPTIONALLY Install [gum](https://github.com/charmbracelet/gum?tab=readme-ov-file#installation) (For better prompts in terminal)
2. Create `/usr/bin/newplugin`
3. Copy content of `newplugin.sh` into newly created `/usr/bin/newplugin`
4. Make it executable: `chmod +x /usr/bin/newplugin`
5. Now you can create a new plugin project by running `newplugin` in terminal

It will ask you for:
- Project name
- Destination folder

After that, script will automatically rename project packages, refactor java classes and main class in plugin.yml.

</details>

> [!WARNING]  
> Not all of the features above are enabled by default! \
> To enable them, you need to uncomment the corresponding lines in the `build.gradle` file.


### Building:

`./gradlew build` - automatically shades all dependencies and creates a single jar file in the `build/libs` directory.
