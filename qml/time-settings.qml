import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import RinUI
import ClassWidgets.Plugins

SettingsLayout {
    // 交替间隔当前值（毫秒），始终与显示同步
    property int intervalValue: 3000
    onIntervalValueChanged: settings.alternate_interval = intervalValue
    Component.onCompleted: intervalValue = settings.alternate_interval

    SettingCard {
        Layout.fillWidth: true
        title: "显示秒"
        description: "在小组件中显示秒数。"

        Switch {
            checked: settings.show_seconds
            onCheckedChanged: settings.show_seconds = checked
        }
    }

    SettingCard {
        Layout.fillWidth: true
        title: "显示日期"
        description: "在小组件标题栏显示日期。"

        Switch {
            checked: settings.show_date
            onCheckedChanged: settings.show_date = checked
        }
    }

    SettingCard {
        Layout.fillWidth: true
        title: "日期内容"
        description: "选择日期需要展示的部分。"

        RowLayout {
            spacing: 8
            Switch {
                text: "年"
                checked: settings.show_year
                onCheckedChanged: settings.show_year = checked
            }
            Switch {
                text: "月"
                checked: settings.show_month
                onCheckedChanged: settings.show_month = checked
            }
            Switch {
                text: "日"
                checked: settings.show_day
                onCheckedChanged: settings.show_day = checked
            }
        }
    }

    SettingCard {
        Layout.fillWidth: true
        title: "显示星期"
        description: "在小组件标题栏显示星期几。"

        Switch {
            checked: settings.show_weekday
            onCheckedChanged: settings.show_weekday = checked
        }
    }

    SettingCard {
        Layout.fillWidth: true
        title: "日期与星期布局"
        description: "并排显示在同一行，或按间隔时间交替展示。"

        Segmented {
            currentIndex: settings.title_mode === "alternate" ? 1 : 0
            onCurrentIndexChanged: settings.title_mode = currentIndex === 1 ? "alternate" : "side_by_side"
            SegmentedItem { text: "并排" }
            SegmentedItem { text: "交替" }
        }
    }

    SettingCard {
        Layout.fillWidth: true
        title: "交替间隔"
        description: "交替展示时，日期与星期各自停留的时间（毫秒），加减按钮以 100ms 调整。"
        enabled: settings.title_mode === "alternate"

        RowLayout {
            spacing: 8
            Button {
                text: "−"
                implicitWidth: 36
                onClicked: intervalValue = Math.max(500, intervalValue - 100)
            }
            Text {
                Layout.preferredWidth: 90
                horizontalAlignment: Text.AlignHCenter
                text: intervalValue + " ms"
            }
            Button {
                text: "+"
                implicitWidth: 36
                onClicked: intervalValue = Math.min(10000, intervalValue + 100)
            }
        }
    }

    SettingCard {
        Layout.fillWidth: true
        title: "交替动画"
        description: "交替展示时，日期与星期切换是否带淡入淡出效果。"
        enabled: settings.title_mode === "alternate"

        Switch {
            checked: settings.alternate_animation
            onCheckedChanged: settings.alternate_animation = checked
        }
    }

    SettingCard {
        Layout.fillWidth: true
        title: "时钟动画"
        description: "时钟数字更新时是否播放滚动动画。"

        Switch {
            checked: settings.clock_animation
            onCheckedChanged: settings.clock_animation = checked
        }
    }
}
