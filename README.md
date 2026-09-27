# In Marvin We Trust · schermate di avvio

Il progetto contiene due temi coordinati: una schermata iniziale per **KDE Plasma 6** e una schermata di avvio del sistema per **Plymouth**. Entrambe usano fondo nero, Marvin con spada laser rossa, logo pixelato e barra di caricamento a segmenti.

La barra della schermata Plasma segue le fasi comunicate da KSplashQML; la luce che la attraversa è decorativa. La barra Plymouth usa l'avanzamento comunicato dal sistema e mostra un segmento animato durante le attese.

## Schermata iniziale KDE Plasma

```bash
mkdir -p ~/.local/share/plasma/look-and-feel/org.inmarvinwetrust.splash
cp -a metadata.json contents ~/.local/share/plasma/look-and-feel/org.inmarvinwetrust.splash/
```

Chiudi e riapri **Impostazioni di sistema** se era già aperto durante l'installazione. Poi vai in **Colori e temi → Schermata iniziale** (in alcune traduzioni **Splash screen**), scegli **In Marvin We Trust** e premi **Applica**. Puoi aprire direttamente il modulo con:

```bash
kcmshell6 kcm_splashscreen
```

Per verificare che KDE riconosca il pacchetto:

```bash
kpackagetool6 --type Plasma/LookAndFeel --show org.inmarvinwetrust.splash
```

Per provare l'animazione:

```bash
ksplashqml org.inmarvinwetrust.splash --test
```

Per disinstallare, elimina la cartella `~/.local/share/plasma/look-and-feel/org.inmarvinwetrust.splash` e seleziona un'altra splash screen nelle impostazioni.

## Schermata di avvio Plymouth

Il tema si trova in [`plymouth/in-marvin-we-trust`](plymouth/in-marvin-we-trust). Richiede Plymouth con il plugin `script` installato e incluso nell'initramfs. Le anteprime statiche mostrano la [schermata di avvio](plymouth/in-marvin-we-trust/preview.png) e quella di [sblocco del disco](plymouth/preview-unlock.png) a 1280 × 720. Il file `preview.png` nella cartella del tema è mostrato anche nelle Impostazioni di sistema di Plasma.

Per installarlo e selezionarlo su un sistema che usa `plymouth-set-default-theme`:

```bash
sudo install -d /usr/share/plymouth/themes/in-marvin-we-trust
sudo install -m 644 plymouth/in-marvin-we-trust/* /usr/share/plymouth/themes/in-marvin-we-trust/
sudo plymouth-set-default-theme in-marvin-we-trust --rebuild-initrd
```

Riavvia per vedere il risultato. Il tema mostra **AVVIO DEL SISTEMA** all'avvio, **SPEGNIMENTO DEL SISTEMA** allo spegnimento e **RIAVVIO DEL SISTEMA** al riavvio. Se Plymouth non compare durante l'avvio, verifica che la distribuzione lo abbia abilitato nell'initramfs e nella configurazione del bootloader.

### Passphrase del disco e logo del produttore

La schermata di sblocco con la scritta «Encryption is not a crime» appare soltanto se la passphrase viene richiesta **dopo** l'avvio del kernel, tramite Plymouth. Se anche `/boot` è nel volume cifrato e GRUB usa `GRUB_ENABLE_CRYPTODISK=y`, la prima richiesta della passphrase è invece di **GRUB**: avviene prima che Plymouth possa partire. In questa configurazione è normale vedere ancora il logo Lenovo durante la richiesta; selezionare o reinstallare il tema Plymouth non la modifica.

Per mostrare il tema Plymouth già alla richiesta della passphrase occorre modificare la struttura di avvio, ad esempio spostando kernel e initramfs su una partizione `/boot` non cifrata e lasciando a `sd-encrypt` lo sblocco del volume di sistema. È un intervento distinto che richiede una migrazione delle partizioni e la reinstallazione del bootloader. Per personalizzare invece la richiesta iniziale di GRUB serve una configurazione grafica incorporata nella sua immagine EFI, accessibile prima dello sblocco; il normale `GRUB_THEME` conservato dentro `/boot` cifrato viene caricato troppo tardi.

Per verificare la selezione:

```bash
plymouth-set-default-theme
```

Per tornare al tema precedente, selezionalo con `sudo plymouth-set-default-theme NOME --rebuild-initrd`.

Il logo proviene dal progetto [In Marvin We Trust](https://github.com/marvinpascale/inMarvinWeTrust). L'immagine di Marvin è stata fornita per questo tema; le immagini in `contents/splash/images` e `plymouth/in-marvin-we-trust` sono copie ridimensionate per caricarle più velocemente. Nessuno dei due temi modifica la schermata di login SDDM.
