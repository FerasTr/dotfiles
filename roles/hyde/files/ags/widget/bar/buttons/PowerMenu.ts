import icons from "lib/icons"
import PanelButton from "../PanelButton"
import options from "options"

const { monochrome, action } = options.bar.powermenu

export default () => PanelButton({
    window: "powermenu",
    onPrimaryClick: () => {
        Utils.exec("wlogout");
    },
    child: Widget.Icon(icons.powermenu.shutdown)
})
