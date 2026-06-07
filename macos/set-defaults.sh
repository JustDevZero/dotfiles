#!/usr/bin/env zsh
# macOS Sequoia defaults

setopt errexit

print '› Applying macOS defaults...'

###############################################################################
# General / Input
###############################################################################

# Desactivar press-and-hold para poder repetir teclas (útil en vim/terminal)
defaults write -g ApplePressAndHoldEnabled -bool false

# Key repeat rápido
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Sin autocorrección
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Sin capitalización automática
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Sin punto al doble espacio
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Sin comillas tipográficas (rompen código)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Sin guiones tipográficos
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# UTF-8 en Terminal
defaults write com.apple.terminal StringEncodings -array 4

###############################################################################
# Trackpad
###############################################################################

# Tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

###############################################################################
# Finder
###############################################################################

# Vista de lista por defecto
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Mostrar extensiones de fichero siempre
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Mostrar ficheros ocultos
defaults write com.apple.finder AppleShowAllFiles -bool true

# Mostrar ruta completa en el título de la ventana
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Mostrar barra de ruta en la parte inferior
defaults write com.apple.finder ShowPathbar -bool true

# Mostrar barra de estado
defaults write com.apple.finder ShowStatusBar -bool true

# Sin aviso al cambiar extensión de fichero
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Buscar en el directorio actual por defecto (no en todo el Mac)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Mostrar ~/Library
chflags nohidden ~/Library

# No crear ficheros .DS_Store en volúmenes de red o USB
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Unidades externas y medios extraíbles en el escritorio
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

###############################################################################
# Dock
###############################################################################

# Ocultar automáticamente
defaults write com.apple.dock autohide -bool true

# Sin delay al mostrar/ocultar
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5

# Tamaño del dock
defaults write com.apple.dock tilesize -int 48

# Minimizar con efecto Scale (más rápido que Genie)
defaults write com.apple.dock mineffect -string "scale"

# No animar las apps al abrirlas
defaults write com.apple.dock launchanim -bool false

# No reagrupar espacios según app más reciente
defaults write com.apple.dock mru-spaces -bool false

###############################################################################
# Screenshots
###############################################################################

# Guardar en el escritorio
defaults write com.apple.screencapture location -string "${HOME}/Desktop"

# Sin sombra en screenshots de ventanas
defaults write com.apple.screencapture disable-shadow -bool true

# Formato PNG
defaults write com.apple.screencapture type -string "png"

###############################################################################
# TextEdit
###############################################################################

# Abrir en texto plano por defecto
defaults write com.apple.TextEdit RichText -int 0

# UTF-8 al abrir y guardar
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Aplicar cambios
###############################################################################

print '› Reiniciando apps afectadas...'
for app in Finder Dock SystemUIServer; do
    killall "$app" &>/dev/null || true
done

print '✓ Hecho. Algunos cambios requieren cerrar sesión para aplicarse.'
