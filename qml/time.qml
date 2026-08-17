import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import RinUI
import ClassWidgets.Theme

Widget {
    id: root

    // 时间数据，由 backend.getTime() 返回
    property var timeData: {
        "year": 1900,
        "month": 1,
        "day": 1,
        "weekday": 1,
        "hour": "00",
        "minute": "00",
        "second": "00"
    }
    // 交替模式下当前是否显示星期
    property bool showWeekdayLine: false
    // 交替淡入淡出时长（关闭动画时为 0）
    property int fadeDuration: settings.alternate_animation ? 300 : 0

    // 按设置筛选年月日后拼接日期字符串
    function dateString() {
        var parts = []
        if (settings.show_year) parts.push(timeData.year + "年")
        if (settings.show_month) parts.push(timeData.month + "月")
        if (settings.show_day) parts.push(timeData.day + "日")
        return parts.join("")
    }

    function weekdayString() {
        return "星期" + ["一", "二", "三", "四", "五", "六", "日"][timeData.weekday - 1]
    }

    // 日期总开关开启且至少展示一个日期部分
    function hasDate() {
        return settings.show_date && root.dateString() !== ""
    }

    // 自定义标题区：并排模式单行展示；交替模式锁定宽度（取两者较宽），居中轮流切换
    subtitle: [
        Subtitle {
            id: combinedText
            visible: settings.title_mode === "side_by_side"
            text: {
                if (root.hasDate() && settings.show_weekday)
                    return root.dateString() + "  " + root.weekdayString()
                if (root.hasDate()) return root.dateString()
                if (settings.show_weekday) return root.weekdayString()
                return ""
            }
        },
        Item {
            visible: settings.title_mode === "alternate"
            implicitWidth: Math.max(dateText.implicitWidth, weekText.implicitWidth)
            implicitHeight: Math.max(dateText.implicitHeight, weekText.implicitHeight)

            Subtitle {
                id: dateText
                anchors.centerIn: parent
                text: root.dateString()
                visible: root.hasDate()
                opacity: (!root.hasDate() || !settings.show_weekday)
                         ? 1
                         : (root.showWeekdayLine ? 0 : 1)
                Behavior on opacity {
                    NumberAnimation { duration: root.fadeDuration; easing.type: Easing.OutQuad }
                }
            }
            Subtitle {
                id: weekText
                anchors.centerIn: parent
                text: root.weekdayString()
                visible: settings.show_weekday
                opacity: (!root.hasDate() || !settings.show_weekday)
                         ? 1
                         : (root.showWeekdayLine ? 1 : 0)
                Behavior on opacity {
                    NumberAnimation { duration: root.fadeDuration; easing.type: Easing.OutQuad }
                }
            }
        }
    ]

    // 交替展示定时器
    Timer {
        id: alternateTimer
        interval: Math.max(500, settings.alternate_interval)
        running: root.hasDate() && settings.show_weekday && settings.title_mode === "alternate"
        repeat: true
        onTriggered: root.showWeekdayLine = !root.showWeekdayLine
    }

    RowLayout {
        anchors.centerIn: parent
        spacing: 0

        AnimatedDigits {
            id: hour
            value: timeData.hour || "00"
            duration: settings.clock_animation ? 700 : 0  // 时钟滚动动画开关
        }
        Title {
            Layout.bottomMargin: font.pixelSize * 0.1
            text: ":"
        }
        AnimatedDigits {
            id: minute
            value: timeData.minute || "00"
            duration: settings.clock_animation ? 700 : 0  // 时钟滚动动画开关
        }
        Title {
            Layout.bottomMargin: font.pixelSize * 0.1
            text: ":"
            visible: settings.show_seconds
        }
        AnimatedDigits {
            id: second
            value: timeData.second || "00"
            visible: settings.show_seconds
            duration: settings.clock_animation ? 700 : 0  // 时钟滚动动画开关
        }

        Timer {
            interval: 500
            running: true
            repeat: true
            onTriggered: {
                if (backend) {
                    timeData = backend.getTime()
                }
            }
        }
    }

    Component.onCompleted: {
        Qt.callLater(function() {
            if (backend) {
                timeData = backend.getTime()
            }
        })
    }
}
