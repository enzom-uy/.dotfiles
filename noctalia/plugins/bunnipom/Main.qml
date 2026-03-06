import QtQuick
import Quickshell
import Quickshell.Io

import qs.Commons
import qs.Services.UI

Item {
    property var pluginApi: null

    IpcHandler {
        target: "plugin:bunnipom"

        function testPom() {
            if (pluginApi === null) return;
            ToastService.showNotice("Hello from pom triggered from terminal!");
            pluginApi.saveSettings();
            pluginApi.withCurrentScreen(screen => {
                pluginApi.toggleLauncher(screen);
            })
        }
    }
}
