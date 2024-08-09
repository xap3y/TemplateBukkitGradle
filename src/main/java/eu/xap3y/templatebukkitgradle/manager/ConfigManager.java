package eu.xap3y.templatebukkitgradle.manager;

import eu.xap3y.templatebukkitgradle.TemplateBukkitGradle;

public class ConfigManager {

    public static void reloadConfig() {
        if (!TemplateBukkitGradle.INSTANCE.getDataFolder().exists()) {
            TemplateBukkitGradle.INSTANCE.getDataFolder().mkdir();
        }

        TemplateBukkitGradle.INSTANCE.saveDefaultConfig();
        TemplateBukkitGradle.INSTANCE.reloadConfig();
    }

}
