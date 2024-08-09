# Bukkit project template

### Installation:

1. Clone this repository
```shell
git clone https://github.com/xap3y/TemplateBukkitGradle.git
cd TemplateBukkitGradle
```
2. Refactor the project \
    2.1 change the `group`, `baseCoordinates` and `version` in the `build.gradle` file. \
    2.2 change the `main` and `name` in the `src/main/resources/plugin.yml` file.

### List of features implemented in this project:

- [x] [Paper API 1.20.4](https://jd.papermc.io/paper/1.20.4/)
- [x] [XaLib](https://xalib.xap3y.eu/)
- [x] [XaGUI](https://xagui.xap3y.eu/docs)
- [x] [SkullCreator](https://skullcreator.xap3y.eu)
- [x] [Cloud V2](https://cloud.incendo.org/minecraft/paper/)
- [x] [Blossom](https://blossom.kyori.net)
- [x] [Lombok](https://projectlombok.org/)
- [x] [ParticleNativeAPI](https://github.com/Fierioziy/ParticleNativeAPI)
- [x] [XSeries](https://www.spigotmc.org/threads/xseries-xmaterial-xparticle-xsound-xpotion-titles-actionbar-etc.378136/)
- [x] [bStats](https://bstats.org/)
- [x] [AnvilGUI](https://github.com/WesJD/AnvilGUI)
- [x] [PlaceholderAPI](https://wiki.placeholderapi.com/developers/using-placeholderapi/)
- [ ] [ProGuard](https://www.guardsquare.com/proguard) obfuscation

> [!WARNING]  
> Not all of the features above are enabled by default! \
> To enable them, you need to uncomment the corresponding lines in the `build.gradle` file.


### Building:

`./gradlew build` - automatically shades all dependencies and creates a single jar file in the `build/libs` directory.