import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Widgets

import qs.Services.UI

Rectangle {
    id: root

    // Plugin API (injected by PluginService)
    property var pluginApi: null

    // Required properties for bar widgets
    property ShellScreen screen
    property string widgetId: "bunnipom"
    property string section: "center"

    implicitWidth: row.implicitWidth + Style.marginM * 2
    implicitHeight: Style.barHeight

    color: Style.capsuleColor
    radius: Style.radiusM

    property int count: pluginApi?.pluginSettings?.count || 0

    RowLayout {
        id: row
        anchors.centerIn: parent
        spacing: Style.marginS

        NIcon {
            icon: "apple"
            color: Color.mPrimary
        }

        NText {
            text: "My plugin"
            color: Color.mOnSurface
            pointSize: Style.fontSizeS
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: function (mouse) {
            if (mouse.button === Qt.LeftButton) {
                root.count++;
                pluginApi.pluginSettings.count = root.count;
                pluginApi.saveSettings();
                ToastService.showNotice("Count: " + root.count);
            } else if (mouse.button === Qt.RightButton) {
                root.count--;
                pluginApi.pluginSettings.count = root.count;
                pluginApi.saveSettings();
                ToastService.showNotice("Count: " + root.count);
            }
        }
    }
}
