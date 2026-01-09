#!/usr/bin/env python3
import os
import sys
import subprocess
from core.utils import gum_choose, COLORS


red = lambda txt: f"\033[91m{txt}\033[0m" 

BACK = red("Back")
EXIT = red("Exit")

def launch_prog(cmd):
    subprocess.run(cmd, shell=True)
    input("")
    sys.exit(0)

def main():
    os.system("tput civis")
    try:
        while True:
            os.system("clear")
            
            # MENU PRINCIPAL
            match gum_choose([
                "Status",
                "System",
                "Snapshots",
                "Power",
                EXIT
            ], header="Kanso Control Center"):
                case "Status":
                    match gum_choose([
                        "Information",
                        "Monitor",
                        "Network",
                        BACK,
                    ], header="Status"):
                        case "Information": launch_prog("fastfetch")
                        case "Monitor":     launch_prog("btop")
                        case "Network":     launch_prog("impala")

                case "System":
                    match gum_choose([
                        "Rebuild",
                        "Rollback",
                        "Hard Clean",
                        "Switch Environment",
                        BACK
                    ], header="System"):
                        case "Rebuild":    launch_prog("kanso rebuild class::clear")
                        case "Rollback":   launch_prog("kanso rollback class::clear")
                        case "Hard Clean": launch_prog("kanso hard-clean class::clear")
                        case "Switch Environment": launch_prog("kanso switch class::clear")

                case "Snapshots":
                    match gum_choose([
                        "Create Snapshot",
                        "Rewind Snapshot",
                        BACK
                    ], header="Snapshots"):
                        case "Create Snapshot": launch_prog("kanso snapshot class::clear")
                        case "Rewind Snapshot": launch_prog("kanso rewind class::clear")

                case "Power":
                    match gum_choose([
                        "Reboot",
                        "Shutdown",
                        "Logout",
                        BACK,
                    ], header="Power"):
                        case "Reboot":   launch_prog(["reboot"])
                        case "Shutdown": launch_prog(["shutdown", "now"])
                        case "Logout":   launch_prog(["hyprctl", "dispatch", "exit"])

                case _: break
    finally:
        os.system("tput cnorm")



if __name__ == "__main__":
    main()
