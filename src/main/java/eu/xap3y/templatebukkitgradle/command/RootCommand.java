package eu.xap3y.templatebukkitgradle.command;

import eu.xap3y.templatebukkitgradle.TemplateBukkitGradle;
import eu.xap3y.templatebukkitgradle.util.ConfigDb;
import org.incendo.cloud.annotations.Command;
import org.incendo.cloud.annotations.Permission;
import org.incendo.cloud.paper.util.sender.Source;

public class RootCommand {

    @Command(ConfigDb.COMMAND_BASE + " version")
    @Permission(ConfigDb.PERMISSION_NODE + "version")
    public void versionCommand(
            Source ctx
    ) {
        TemplateBukkitGradle.getInstance().getTexter().response(ctx.source(), "Plugin version: " + ConfigDb.VERSION + " (git: " + ConfigDb.GIT_HASH + ")");
    }
}
