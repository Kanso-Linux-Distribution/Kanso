#!/usr/bin/env python3
import sys
import subprocess

from core import ops

def show_help():
    print("""
Kanso CLI - System Management (Python Core)

Usage: kanso <command> [arguments]

Commands:
  add **[src:pkg]  Install package
  rm **[src:pkg]   Uninstall package

  sync-pkgs        Sync 'packages.toml' with system packages
  list-pkgs        List all 'packages.toml' packages 
  
  snapshot [name]  Create config snapshot for /vault
  rewind           Interactive Git restore for /vault

  rebuild          Rebuild Nix system configuration
  rollback         Restore previous Nix generation
  
  hard-clean       Deep clean Nix generations and config snapshots history

  yt               Search and play YouTube videos
  code             Launch Zellij development layout

  help             See the help
""")

def main():
    if len(sys.argv) < 2:
        show_help()
        sys.exit(0)

    command = sys.argv[1]
    args = sys.argv[2:]

    clear_arg = "class::clear" in args
    arg_val = args[0] if args and args[0] != "class::clear" else None

    commands = {
        "add":             lambda: ops.update_packages(isInstall=True, clear_screen=clear_arg, queries=args),
        "rm":              lambda: ops.update_packages(isInstall=False, clear_screen=clear_arg, queries=args),

        "sync-pkgs":       lambda: ops.sync_pkgs(clear_screen=clear_arg),
        "list-pkgs":       lambda: ops.list_pkgs(clear_screen=clear_arg),
        
        "snapshot":        lambda: ops.snapshot(arg_val, clear_screen=clear_arg),        
        "rewind":          lambda: ops.rewind(clear_screen=clear_arg),

        "rebuild":         lambda: ops.rebuild(clear_screen=clear_arg),
        "rollback":        lambda: ops.rollback(clear_screen=clear_arg),
        
        "hard-clean":      lambda: ops.hard_clean(clear_screen=clear_arg),

        "yt":              lambda: ops.watch_youtube(arg_val),
        "code":            lambda: ops.code_editor(),

        "help":            show_help,
    }

    if command in commands:
        commands[command]()
    else:
        subprocess.run(["gum", "style", "--foreground", "#fb4934", f"Error: Invalid command '{command}'"])
        sys.exit(1)
        
if __name__ == "__main__":
    main()
