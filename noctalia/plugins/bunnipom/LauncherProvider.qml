import QtQuick
import Quickshell
import qs.Commons
import qs.Services.UI

Item {
    id: root

    property var pluginApi: null
    property var launcher: null
    property string name: "My Provider"

    function handleCommand(searchText) {
        return searchText.startsWith(">bunnipom");
    }

    function commands() {
        return [
            {
                "name": ">bunnipom",
                "description": "Starts a pomodoro work session",
                "icon": "apple",
                "isTablerIcon": true,
                "onActivate": function () {
                    launcher.setSearchText(">bunnipom ");
                }
            }
        ];
    }

    function getResults(searchText) {
        if (!searchText.startsWith(">bunnipom"))
            return [];

        return [
            {
                "name": "Start a pomodoro work session",
                "description": "Starts a pomodoro work session",
                "icon": "apple",
                "isTablerIcon": true,
                "onActivate": function () {
                    // Ejecutar pom en kitty con zsh interactivo (para cargar funciones de zsh)
                    Quickshell.execDetached(["kitty", "-e", "zsh", "-i", "-c", "pom"]);
                    launcher.close();
                    ToastService.showNotice("Opening pomodoro session...");
                }
            }
        ];
    }
}
