package eu.xap3y.templatebukkitgradle.command;

import eu.xap3y.templatebukkitgradle.TemplateBukkitGradle;
import eu.xap3y.templatebukkitgradle.util.ConfigDb;
import net.kyori.adventure.text.Component;
import net.kyori.adventure.text.TextComponent;
import net.kyori.adventure.text.event.ClickEvent;
import net.kyori.adventure.text.event.HoverEvent;
import org.bukkit.entity.Player;
import org.incendo.cloud.annotations.Command;
import org.incendo.cloud.annotations.Permission;
import org.incendo.cloud.paper.util.sender.Source;

public class RootCommand {

    @Command(ConfigDb.COMMAND_BASE + " version")
    @Permission(ConfigDb.PERMISSION_NODE + "version")
    public void versionCommand(
            Source ctx
    ) {
        if (ctx.source() instanceof Player && (ctx.source().hasPermission("egghunt.*") || ctx.source().isOp())) {
            TextComponent msg = Component.text("§fRunning McGeocaching v" + ConfigDb.VERSION);
            TextComponent git = Component
                    .text(" §8(" + ConfigDb.GIT_HASH + "§8)")
                    .clickEvent(ClickEvent.clickEvent(ClickEvent.Action.OPEN_URL, ClickEvent.Payload.string(ConfigDb.GIT_URL + "/commit/" + ConfigDb.GIT_HASH)))
                    .hoverEvent(HoverEvent.showText(Component.text("§7Klikni pro otevření")));
            TemplateBukkitGradle.getInstance().getTexter().response(ctx.source(), msg, git);
        } else {
            TemplateBukkitGradle.getInstance().getTexter().response(ctx.source(), "&fRunning McGeocaching v" + ConfigDb.VERSION + " &8(" + ConfigDb.GIT_HASH + ")");
        }
    }
}
