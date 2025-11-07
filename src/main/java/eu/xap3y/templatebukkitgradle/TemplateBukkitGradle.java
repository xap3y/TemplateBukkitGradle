package eu.xap3y.templatebukkitgradle;

import eu.xap3y.templatebukkitgradle.command.RootCommand;
import eu.xap3y.templatebukkitgradle.manager.CommandManager;
import eu.xap3y.templatebukkitgradle.manager.ConfigManager;
import eu.xap3y.templatebukkitgradle.service.Texter;
import lombok.Getter;
import org.bukkit.Bukkit;
import org.bukkit.permissions.Permission;
import org.bukkit.plugin.java.JavaPlugin;

@Getter
public final class TemplateBukkitGradle extends JavaPlugin {

    @Getter
    private static TemplateBukkitGradle instance;

    private Texter texter;

    //public static XaGui xagui;

    @Override
    public void onEnable() {
        instance = this;

        //  Initializing XaGUI  \\
        //xagui = new XaGui(this);

        //  Creating parser & Parsing command classes below  \\
        CommandManager cmdManager = new CommandManager(false);
        cmdManager.parse(new RootCommand());


        //  Saving if not exists & Reloading config file  \\
        ConfigManager.reloadConfig();

        //  Setting up texter  \\
        String prefix = getConfig().getString("prefix");
        if (prefix == null) prefix = "&7[&bserver&7] &r";
        texter = new Texter(prefix, false, null);

        //   Registering listeners  \\

        /*PluginManager manager = getServer().getPluginManager();
        registerListeners(manager);*/

        //  Setting up bStats  \\
        /* int pluginId = 1234; // <-- Replace with the id of your plugin!
        Metrics metrics = new Metrics(this, pluginId);*/

        //  Registering PlaceholderAPI  \\
        //registerPapi();
    }

    private void registerPermission(String permission) {
        Bukkit.getPluginManager().addPermission(new Permission(permission));
    }

    /*private static void registerListeners(PluginManager manager) {
        //  Registering listeners  \\
        Listener[] listeners = new Listener[]{

        };

        for (Listener listener : listeners) {
            manager.registerEvents(listener, INSTANCE);
        }
    }*/

    /*private void registerPapi() {
        if (Bukkit.getPluginManager().getPlugin("PlaceholderAPI") != null) {
            *//*
             * We register the EventListener here, when PlaceholderAPI is installed.
             * Since all events are in the main class (this class), we simply use "this"
             *//*
            //Bukkit.getPluginManager().registerEvents(new MyListener(), this);
        } else {
            *//*
             * We inform about the fact that PlaceholderAPI isn't installed and then
             * disable this plugin to prevent issues.
             *//*
            //Bukkit.getPluginManager().disablePlugin(this);
        }
    }*/
}
