DEFAULT_SCREEN[transform]="270"
DEFAULT_SCREEN[name]="HDMI-A-1"

WESTONSECTION[WESTONOUTPUT3]="output"

WESTONOUTPUT3[transform]="0"
WESTONOUTPUT3[name]="HDMI-A-2"

WESTONSECTION[WESTONOUTPUT4]="output"

WESTONOUTPUT4[name]="VGA-1"

python () {
    if "salvator-x-h3-xt" in d.getVar("MACHINEOVERRIDES", expand=True):
        d.setVarFlag("WESTONOUTPUT4", "mode", "off")
}

python () {
    if "salvator-x-m3-xt" in d.getVar("MACHINEOVERRIDES", expand=True):
        d.setVarFlag("DEFAULT_SCREEN", "transform", "0")
}

