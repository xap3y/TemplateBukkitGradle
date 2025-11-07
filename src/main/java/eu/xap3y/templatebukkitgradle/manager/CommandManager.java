package eu.xap3y.templatebukkitgradle.manager;

import eu.xap3y.templatebukkitgradle.TemplateBukkitGradle;
import org.bukkit.command.CommandSender;
import org.incendo.cloud.SenderMapper;
import org.incendo.cloud.annotations.AnnotationParser;
import org.incendo.cloud.bukkit.BukkitCommandManager;
import org.incendo.cloud.bukkit.CloudBukkitCapabilities;
import org.incendo.cloud.execution.ExecutionCoordinator;
import org.incendo.cloud.paper.LegacyPaperCommandManager;
import org.incendo.cloud.paper.PaperCommandManager;
import org.incendo.cloud.paper.util.sender.PaperSimpleSenderMapper;
import org.incendo.cloud.paper.util.sender.Source;
import org.jetbrains.annotations.NotNull;

public class CommandManager {

    private static AnnotationParser<CommandSender> legacyParser;
    private static AnnotationParser<Source> parser;

    public CommandManager() {
        legacyParser = null;
        parser = createParser();
    }

    public CommandManager(boolean legacy) {
        if (legacy) {
            legacyParser = createLegacyParser();
        } else {
            parser = createParser();
        }
    }

    public void parseLegacy(@NotNull Object... instances) {
        legacyParser.parse(instances);
    }

    public void parse(@NotNull Object... instances) {
        parser.parse(instances);
    }

    // LEGACY
    private BukkitCommandManager<CommandSender> createCommandManagerLegacy() {
        ExecutionCoordinator<CommandSender> coordinator = ExecutionCoordinator.asyncCoordinator();
        LegacyPaperCommandManager<CommandSender> manager = new LegacyPaperCommandManager<CommandSender>(
                TemplateBukkitGradle.getInstance(),
                coordinator,
                SenderMapper.identity()
        );
        if (manager.hasCapability(CloudBukkitCapabilities.NATIVE_BRIGADIER)) {
            manager.registerBrigadier();
            manager.brigadierManager().setNativeNumberSuggestions(false);
        }
        return manager;
    }

    // OLD
    private PaperCommandManager<Source> createCommandManager() {
        PaperCommandManager<Source> paperManager = PaperCommandManager
                .builder(PaperSimpleSenderMapper.simpleSenderMapper())
                .executionCoordinator(ExecutionCoordinator.simpleCoordinator())
                .buildOnEnable(TemplateBukkitGradle.getInstance());
        if (paperManager.hasCapability(CloudBukkitCapabilities.NATIVE_BRIGADIER)) {
            paperManager.brigadierManager().setNativeNumberSuggestions(false);
        }
        return paperManager;
    }

    private AnnotationParser<Source> createParser() {
        return new AnnotationParser<>(createCommandManager(), Source.class);
    }

    private AnnotationParser<CommandSender> createLegacyParser() {
        return new AnnotationParser<>(createCommandManagerLegacy(), CommandSender.class);
    }
}

