# Keep your main class
-keep public class eu.xap3y.templatebukkitgradle.TemplateBukkitGradle {
    public static void onEnable();
    public static void onDisable();
}

# Keep event handlers
-keep,allowobfuscation class * extends org.bukkit.event.Listener {
    @org.bukkit.event.EventHandler <methods>;
}

# Some attributes that you'll need to keep (to be honest I'm not sure which ones really need to be kept here, but this is what works for me)
-keepattributes !LocalVariableTable,!LocalVariableTypeTable,Exceptions,InnerClasses,Signature,Deprecated,LineNumberTable,*Annotation*,EnclosingMethod

-dontwarn *.**
-allowaccessmodification
-dontoptimize
-dontshrink