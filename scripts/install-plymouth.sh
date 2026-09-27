#!/usr/bin/env bash
set -euo pipefail

if (( EUID != 0 )); then
  echo "Eseguire come root." >&2
  exit 1
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
theme_source="$script_dir/../plymouth/in-marvin-we-trust"
theme_destination=/usr/share/plymouth/themes/in-marvin-we-trust

install -d -m 755 -- "$theme_destination"
install -m 644 -- "$theme_source"/* "$theme_destination/"

echo "Tema precedente: $(plymouth-set-default-theme)"
plymouth-set-default-theme in-marvin-we-trust --rebuild-initrd
echo "Tema attivo: $(plymouth-set-default-theme)"
