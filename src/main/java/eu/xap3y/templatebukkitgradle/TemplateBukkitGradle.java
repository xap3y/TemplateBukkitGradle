package eu.xap3y.templatebukkitgradle;

import eu.xap3y.templatebukkitgradle.manager.CommandManager;
import eu.xap3y.templatebukkitgradle.manager.ConfigManager;
import eu.xap3y.xagui.XaGui;
import eu.xap3y.xalib.managers.Texter;
import eu.xap3y.xalib.objects.TexterObj;
import org.bukkit.plugin.java.JavaPlugin;

public final class TemplateBukkitGradle extends JavaPlugin {

    public static TemplateBukkitGradle INSTANCE;

    public static Texter texter;

    public static XaGui xagui;

    @Override
    public void onEnable() {
        INSTANCE = this;


        //  Initializing XaGUI  \\
        xagui = new XaGui(this);

        //  Creating parser & Parsing command classes below  \\
        CommandManager cmdManager = new CommandManager();

        // cmdManager.parse(new RootCommand());


        //  Saving if not exists & Reloading config file  \\
        ConfigManager.reloadConfig();

        //  Setting up texter  \\
        String prefix = getConfig().getString("prefix");
        if (prefix == null) prefix = "&7[&bserver&7] &r";
        texter = new Texter(new TexterObj(prefix, false, null));

        //   Registering listeners  \\

        /*PluginManager manager = getServer().getPluginManager();
        registerListeners(manager);*/

        //  Setting up bStats  \\
        /*int pluginId = 1234; // <-- Replace with the id of your plugin!
        Metrics metrics = new Metrics(this, pluginId);*/

        //  Registering PlaceholderAPI  \\
        //registerPapi();

        // Get current mc version as x.x.x

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
