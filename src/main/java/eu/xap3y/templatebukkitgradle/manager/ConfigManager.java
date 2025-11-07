package eu.xap3y.templatebukkitgradle.manager;

import eu.xap3y.templatebukkitgradle.TemplateBukkitGradle;

public class ConfigManager {

    public static void reloadConfig() {
        if (!TemplateBukkitGradle.getInstance().getDataFolder().exists()) {
            TemplateBukkitGradle.getInstance().getDataFolder().mkdir();
        }

        TemplateBukkitGradle.getInstance().saveDefaultConfig();
        TemplateBukkitGradle.getInstance().reloadConfig();
    }
}
