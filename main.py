"""
时间小组件
A Class Widgets 2 plugin to display the current time.
"""

from ClassWidgets.SDK import CW2Plugin, PluginAPI
from PySide6.QtCore import Slot


class Plugin(CW2Plugin):
    def __init__(self, api: PluginAPI):
        super().__init__(api)
        # 请在此导入第三方库 / Import third-party libraries here

    @Slot(result=dict)
    def getTime(self) -> dict:
        """
        返回当前时间的各字段，供 QML 组件调用。

        Returns:
            dict: 包含 year / month / day / weekday / hour / minute / second 的字典。
        """
        current_time = self.api.runtime.current_time
        return {
            "hour": f"{current_time.hour:02d}",
            "minute": f"{current_time.minute:02d}",
            "second": f"{current_time.second:02d}",
            "year": current_time.year,
            "month": current_time.month,
            "day": current_time.day,
            "weekday": current_time.isoweekday(),
        }

    def on_load(self):
        super().on_load()
        self.api.widgets.register(
            widget_id="com.time.model",
            name="时间 / Time",
            qml_path="qml/time.qml",
            backend_obj=self,
            settings_qml="qml/time-settings.qml",
            default_settings={
                "show_seconds": True,     # 是否显示秒
                "show_date": True,        # 是否显示日期（总开关）
                "show_year": True,        # 日期是否显示年
                "show_month": True,       # 日期是否显示月
                "show_day": True,         # 日期是否显示日
                "show_weekday": True,     # 是否显示星期
                "title_mode": "side_by_side",  # 日期与星期布局：side_by_side 并排 / alternate 交替
                "alternate_interval": 3000,    # 交替间隔（毫秒）
                "alternate_animation": False,  # 交替切换时是否淡入淡出
                "clock_animation": False,      # 时钟数字更新时是否滚动动画
            },
        )
        print("Time plugin loaded")

    def on_unload(self):
        print("Time plugin unloaded")
