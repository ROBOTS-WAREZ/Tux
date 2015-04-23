#!/bin/bash
# su; # SuperUser login.
# wget -O- https://raw.github.com/ROBOTS-WAREZ/Linux/master/netinst.sh | bash; # Run this script.
# smxi; # Mainly for the GPU drivers. [http://smxi.org/site/install.htm]
# reboot; # SuperUser signout.

username=$(getent passwd 1000 | cut -d: -f1);
userpath=/home/$username;

apt-get update;
apt-get dist-upgrade;

######## Software Package Installations Terminally ########
apt-get install \
    gawk unzip \
    iptables-persistent \
    sudo \
    xorg openbox \
    alsa-base alsa-utils `# Audio` \
    openjdk-7-jdk openjdk-7-jre icedtea-netx `# Java` \
    iceweasel `# Web Browser & File Viewer` \
    vlc `# Media Player` \
    gimp inkscape blender `# Visiographical Editors (Rasta, Vector, 3D)` \
    audacity `# Audiographical Editor` \
--assume-yes;
# http://stackoverflow.com/a/12797512

apt-get autoremove && apt-get autoclean;

#http://smxi.org/site/install.htm
cd /usr/local/bin && wget -Nc smxi.org/smxi.zip && unzip smxi.zip && rm smxi.zip;

######## Enable sudo ########
adduser $username sudo;

######## Audio ########
alsactl init;

######## Firefox || Iceweasel || GNU IceCat ########
# about:config (http://kb.mozillazine.org/User.js_file#Removing_user.js_entries)
echo '
// When Firefox starts: Show my windows and tabs from last time
user_pref("browser.startup.page", 3);
// Use autoscrolling (middle click and drag to navigate the page)
user_pref("general.autoScroll", true);
' > $userpath/.mozilla/firefox/$(ls ~/.mozilla/firefox/ | grep .default)/user.js; # The profile directory? What if (profiles>1)?

######## Openbox ########
# https://wiki.archlinux.org/index.php/openbox
# http://openbox.org/wiki/Help:Configuration

mkdir -p $userpath/.config/openbox;
cp -R /etc/xdg/openbox/* $userpath/.config/openbox;

echo '
<?xml version="1.0" encoding="UTF-8"?>

<openbox_menu xmlns="http://openbox.org/"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://openbox.org/
                file:///usr/share/openbox/menu.xsd">

<menu id="root-menu" label="Openbox 3">
  <item label="Terminal Emulator">
    <action name="Execute"><execute>x-terminal-emulator</execute></action>
  </item>
  <item label="Web Browser">
    <action name="Execute"><execute>x-www-browser</execute></action>
  </item>
  <item label="File Manager">
    <action name="Execute"><execute>x-www-browser -new-window file://'$userpath'/</execute></action>
  </item>
  <!-- This requires the presence of the 'menu' package to work -->
  <menu id="/Debian" />
  <separator />
  <menu id="client-list-menu" />
  <separator />
  <item label="ObConf">
    <action name="Execute"><execute>obconf</execute></action>
  </item>
  <item label="Reconfigure">
    <action name="Reconfigure" />
  </item>
  <item label="Restart">
    <action name="Restart" />
  </item>
  <separator />
  <item label="Exit">
    <action name="Exit" />
  </item>
</menu>

</openbox_menu>
' > $userpath/.config/openbox/menu.xml;

echo "
<?xml version=\"1.0\" encoding=\"UTF-8\"?>

<!-- Do not edit this file, it will be overwritten on install.
        Copy the file to $HOME/.config/openbox/ instead. -->

<openbox_config xmlns=\"http://openbox.org/3.4/rc\"
		xmlns:xi=\"http://www.w3.org/2001/XInclude\">

<resistance>
  <strength>10</strength>
  <screen_edge_strength>20</screen_edge_strength>
</resistance>

<focus>
  <focusNew>yes</focusNew>
  <!-- always try to focus new windows when they appear. other rules do
       apply -->
  <followMouse>no</followMouse>
  <!-- move focus to a window when you move the mouse into it -->
  <focusLast>yes</focusLast>
  <!-- focus the last used window when changing desktops, instead of the one
       under the mouse pointer. when followMouse is enabled -->
  <underMouse>no</underMouse>
  <!-- move focus under the mouse, even when the mouse is not moving -->
  <focusDelay>200</focusDelay>
  <!-- when followMouse is enabled, the mouse must be inside the window for
       this many milliseconds (1000 = 1 sec) before moving focus to it -->
  <raiseOnFocus>no</raiseOnFocus>
  <!-- when followMouse is enabled, and a window is given focus by moving the
       mouse into it, also raise the window -->
</focus>

<placement>
  <policy>Smart</policy>
  <!-- 'Smart' or 'UnderMouse' -->
  <center>yes</center>
  <!-- whether to place windows in the center of the free area found or
       the top left corner -->
  <monitor>Primary</monitor>
  <!-- with Smart placement on a multi-monitor system, try to place new windows
       on: 'Any' - any monitor, 'Mouse' - where the mouse is, 'Active' - where
       the active window is, 'Primary' - only on the primary monitor -->
  <primaryMonitor>1</primaryMonitor>
  <!-- The monitor where Openbox should place popup dialogs such as the
       focus cycling popup, or the desktop switch popup.  It can be an index
       from 1, specifying a particular monitor.  Or it can be one of the
       following: 'Mouse' - where the mouse is, or
                  'Active' - where the active window is -->
</placement>

<theme>
  <name>Clearlooks</name>
  <titleLayout>NLIMC</titleLayout>
  <!--
      available characters are NDSLIMC, each can occur at most once.
      N: window icon
      L: window label (AKA title).
      I: iconify
      M: maximize
      C: close
      S: shade (roll up/down)
      D: omnipresent (on all desktops).
  -->
  <keepBorder>yes</keepBorder>
  <animateIconify>yes</animateIconify>
  <font place=\"ActiveWindow\">
    <name>sans</name>
    <size>8</size>
    <!-- font size in points -->
    <weight>bold</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place=\"InactiveWindow\">
    <name>sans</name>
    <size>8</size>
    <!-- font size in points -->
    <weight>bold</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place=\"MenuHeader\">
    <name>sans</name>
    <size>9</size>
    <!-- font size in points -->
    <weight>normal</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place=\"MenuItem\">
    <name>sans</name>
    <size>9</size>
    <!-- font size in points -->
    <weight>normal</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place=\"ActiveOnScreenDisplay\">
    <name>sans</name>
    <size>9</size>
    <!-- font size in points -->
    <weight>bold</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
  <font place=\"InactiveOnScreenDisplay\">
    <name>sans</name>
    <size>9</size>
    <!-- font size in points -->
    <weight>bold</weight>
    <!-- 'bold' or 'normal' -->
    <slant>normal</slant>
    <!-- 'italic' or 'normal' -->
  </font>
</theme>

<desktops>
  <!-- this stuff is only used at startup, pagers allow you to change them
       during a session

       these are default values to use when other ones are not already set
       by other applications, or saved in your session

       use obconf if you want to change these without having to log out
       and back in -->
  <number>4</number>
  <firstdesk>1</firstdesk>
  <names>
    <!-- set names up here if you want to, like this:
    <name>desktop 1</name>
    <name>desktop 2</name>
    -->
  </names>
  <popupTime>875</popupTime>
  <!-- The number of milliseconds to show the popup for when switching
       desktops.  Set this to 0 to disable the popup. -->
</desktops>

<resize>
  <drawContents>yes</drawContents>
  <popupShow>Nonpixel</popupShow>
  <!-- 'Always', 'Never', or 'Nonpixel' (xterms and such) -->
  <popupPosition>Center</popupPosition>
  <!-- 'Center', 'Top', or 'Fixed' -->
  <popupFixedPosition>
    <!-- these are used if popupPosition is set to 'Fixed' -->

    <x>10</x>
    <!-- positive number for distance from left edge, negative number for
         distance from right edge, or 'Center' -->
    <y>10</y>
    <!-- positive number for distance from top edge, negative number for
         distance from bottom edge, or 'Center' -->
  </popupFixedPosition>
</resize>

<!-- You can reserve a portion of your screen where windows will not cover when
     they are maximized, or when they are initially placed.
     Many programs reserve space automatically, but you can use this in other
     cases. -->
<margins>
  <top>0</top>
  <bottom>0</bottom>
  <left>0</left>
  <right>0</right>
</margins>

<dock>
  <position>TopLeft</position>
  <!-- (Top|Bottom)(Left|Right|)|Top|Bottom|Left|Right|Floating -->
  <floatingX>0</floatingX>
  <floatingY>0</floatingY>
  <noStrut>no</noStrut>
  <stacking>Above</stacking>
  <!-- 'Above', 'Normal', or 'Below' -->
  <direction>Vertical</direction>
  <!-- 'Vertical' or 'Horizontal' -->
  <autoHide>no</autoHide>
  <hideDelay>300</hideDelay>
  <!-- in milliseconds (1000 = 1 second) -->
  <showDelay>300</showDelay>
  <!-- in milliseconds (1000 = 1 second) -->
  <moveButton>Middle</moveButton>
  <!-- 'Left', 'Middle', 'Right' -->
</dock>

<keyboard>
  <chainQuitKey>C-g</chainQuitKey>

  <!-- Keybindings for desktop switching -->
  <keybind key=\"C-A-Left\">
    <action name=\"GoToDesktop\"><to>left</to><wrap>no</wrap></action>
  </keybind>
  <keybind key=\"C-A-Right\">
    <action name=\"GoToDesktop\"><to>right</to><wrap>no</wrap></action>
  </keybind>
  <keybind key=\"C-A-Up\">
    <action name=\"GoToDesktop\"><to>up</to><wrap>no</wrap></action>
  </keybind>
  <keybind key=\"C-A-Down\">
    <action name=\"GoToDesktop\"><to>down</to><wrap>no</wrap></action>
  </keybind>
  <keybind key=\"S-A-Left\">
    <action name=\"SendToDesktop\"><to>left</to><wrap>no</wrap></action>
  </keybind>
  <keybind key=\"S-A-Right\">
    <action name=\"SendToDesktop\"><to>right</to><wrap>no</wrap></action>
  </keybind>
  <keybind key=\"S-A-Up\">
    <action name=\"SendToDesktop\"><to>up</to><wrap>no</wrap></action>
  </keybind>
  <keybind key=\"S-A-Down\">
    <action name=\"SendToDesktop\"><to>down</to><wrap>no</wrap></action>
  </keybind>
  <keybind key=\"W-F1\">
    <action name=\"GoToDesktop\"><to>1</to></action>
  </keybind>
  <keybind key=\"W-F2\">
    <action name=\"GoToDesktop\"><to>2</to></action>
  </keybind>
  <keybind key=\"W-F3\">
    <action name=\"GoToDesktop\"><to>3</to></action>
  </keybind>
  <keybind key=\"W-F4\">
    <action name=\"GoToDesktop\"><to>4</to></action>
  </keybind>
  <keybind key=\"W-d\">
    <action name=\"ToggleShowDesktop\"/>
  </keybind>

  <!-- Keybindings for windows -->
  <keybind key=\"A-F4\">
    <action name=\"Close\"/>
  </keybind>
  <keybind key=\"A-Escape\">
    <action name=\"Lower\"/>
    <action name=\"FocusToBottom\"/>
    <action name=\"Unfocus\"/>
  </keybind>
  <keybind key=\"A-space\">
    <action name=\"ShowMenu\"><menu>client-menu</menu></action>
  </keybind>
  <!-- Take a screenshot of the current window with gnome-screenshot when Alt+Print are pressed -->
  <keybind key=\"A-Print\">
    <action name=\"Execute\"><command>gnome-screenshot -w</command></action>
  </keybind>

  <!-- Keybindings for window switching -->
  <keybind key=\"A-Tab\">
    <action name=\"NextWindow\">
      <finalactions>
        <action name=\"Focus\"/>
        <action name=\"Raise\"/>
        <action name=\"Unshade\"/>
      </finalactions>
    </action>
  </keybind>
  <keybind key=\"A-S-Tab\">
    <action name=\"PreviousWindow\">
      <finalactions>
        <action name=\"Focus\"/>
        <action name=\"Raise\"/>
        <action name=\"Unshade\"/>
      </finalactions>
    </action>
  </keybind>
  <keybind key=\"C-A-Tab\">
    <action name=\"NextWindow\">
      <panels>yes</panels><desktop>yes</desktop>
      <finalactions>
        <action name=\"Focus\"/>
        <action name=\"Raise\"/>
        <action name=\"Unshade\"/>
      </finalactions>
    </action>
  </keybind>

  <!-- Keybindings for window switching with the arrow keys -->
  <keybind key=\"W-S-Right\">
    <action name=\"DirectionalCycleWindows\">
      <direction>right</direction>
    </action>
  </keybind>
  <keybind key=\"W-S-Left\">
    <action name=\"DirectionalCycleWindows\">
      <direction>left</direction>
    </action>
  </keybind>
  <keybind key=\"W-S-Up\">
    <action name=\"DirectionalCycleWindows\">
      <direction>up</direction>
    </action>
  </keybind>
  <keybind key=\"W-S-Down\">
    <action name=\"DirectionalCycleWindows\">
      <direction>down</direction>
    </action>
  </keybind>

  <!-- Keybindings for running applications -->
  <keybind key=\"W-e\">
    <action name=\"Execute\">
      <startupnotify>
        <enabled>true</enabled>
        <name>Konqueror</name>
      </startupnotify>
      <command>kfmclient openProfile filemanagement</command>
    </action>
  </keybind>
  <!-- Launch gnome-screenshot when Print is pressed -->
  <keybind key=\"Print\">
    <action name=\"Execute\"><command>gnome-screenshot</command></action>
  </keybind>
<!-- http://en.wikipedia.org/wiki/Table_of_keyboard_shortcuts

Where do these come from?

F11     = ToggleFullscreen (Only have a keybind for some special cirmucstances.)
A-C-F1  = TTY1
A-C-F2  = TTY2
A-C-F3  = TTY3
A-C-F4  = TTY4
A-C-F5  = TTY5
A-C-F6  = TTY6
A-C-F7  = GUI0
A-C-F12 = TTY12

-->
  <keybind key="C-A-T">
    <action name="Execute">
      <command>x-terminal-emulator</command>
    </action>
  </keybind>
</keyboard>

<mouse>
  <dragThreshold>1</dragThreshold>
  <!-- number of pixels the mouse must move before a drag begins -->
  <doubleClickTime>200</doubleClickTime>
  <!-- in milliseconds (1000 = 1 second) -->
  <screenEdgeWarpTime>400</screenEdgeWarpTime>
  <!-- Time before changing desktops when the pointer touches the edge of the
       screen while moving a window, in milliseconds (1000 = 1 second).
       Set this to 0 to disable warping -->
  <screenEdgeWarpMouse>false</screenEdgeWarpMouse>
  <!-- Set this to TRUE to move the mouse pointer across the desktop when
       switching due to hitting the edge of the screen -->

  <context name=\"Frame\">
    <mousebind button=\"A-Left\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
    </mousebind>
    <mousebind button=\"A-Left\" action=\"Click\">
      <action name=\"Unshade\"/>
    </mousebind>
    <mousebind button=\"A-Left\" action=\"Drag\">
      <action name=\"Move\"/>
    </mousebind>

    <mousebind button=\"A-Right\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"Unshade\"/>
    </mousebind>
    <mousebind button=\"A-Right\" action=\"Drag\">
      <action name=\"Resize\"/>
    </mousebind> 

    <mousebind button=\"A-Middle\" action=\"Press\">
      <action name=\"Lower\"/>
      <action name=\"FocusToBottom\"/>
      <action name=\"Unfocus\"/>
    </mousebind>

    <mousebind button=\"A-Up\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>previous</to></action>
    </mousebind>
    <mousebind button=\"A-Down\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>next</to></action>
    </mousebind>
    <mousebind button=\"C-A-Up\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>previous</to></action>
    </mousebind>
    <mousebind button=\"C-A-Down\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>next</to></action>
    </mousebind>
    <mousebind button=\"A-S-Up\" action=\"Click\">
      <action name=\"SendToDesktop\"><to>previous</to></action>
    </mousebind>
    <mousebind button=\"A-S-Down\" action=\"Click\">
      <action name=\"SendToDesktop\"><to>next</to></action>
    </mousebind>
  </context>

  <context name=\"Titlebar\">
    <mousebind button=\"Left\" action=\"Drag\">
      <action name=\"Move\"/>
    </mousebind>
    <mousebind button=\"Left\" action=\"DoubleClick\">
      <action name=\"ToggleMaximize\"/>
    </mousebind>

    <mousebind button=\"Up\" action=\"Click\">
      <action name=\"if\">
        <shaded>no</shaded>
        <then>
          <action name=\"Shade\"/>
          <action name=\"FocusToBottom\"/>
          <action name=\"Unfocus\"/>
          <action name=\"Lower\"/>
        </then>
      </action>
    </mousebind>
    <mousebind button=\"Down\" action=\"Click\">
      <action name=\"if\">
        <shaded>yes</shaded>
        <then>
          <action name=\"Unshade\"/>
          <action name=\"Raise\"/>
        </then>
      </action>
    </mousebind>
  </context>

  <context name=\"Titlebar Top Right Bottom Left TLCorner TRCorner BRCorner BLCorner\">
    <mousebind button=\"Left\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"Unshade\"/>
    </mousebind>

    <mousebind button=\"Middle\" action=\"Press\">
      <action name=\"Lower\"/>
      <action name=\"FocusToBottom\"/>
      <action name=\"Unfocus\"/>
    </mousebind>

    <mousebind button=\"Right\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"ShowMenu\"><menu>client-menu</menu></action>
    </mousebind>
  </context>

  <context name=\"Top\">
    <mousebind button=\"Left\" action=\"Drag\">
      <action name=\"Resize\"><edge>top</edge></action>
    </mousebind>
  </context>

  <context name=\"Left\">
    <mousebind button=\"Left\" action=\"Drag\">
      <action name=\"Resize\"><edge>left</edge></action>
    </mousebind>
  </context>

  <context name=\"Right\">
    <mousebind button=\"Left\" action=\"Drag\">
      <action name=\"Resize\"><edge>right</edge></action>
    </mousebind>
  </context>

  <context name=\"Bottom\">
    <mousebind button=\"Left\" action=\"Drag\">
      <action name=\"Resize\"><edge>bottom</edge></action>
    </mousebind>

    <mousebind button=\"Right\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"ShowMenu\"><menu>client-menu</menu></action>
    </mousebind>
  </context>

  <context name=\"TRCorner BRCorner TLCorner BLCorner\">
    <mousebind button=\"Left\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"Unshade\"/>
    </mousebind>
    <mousebind button=\"Left\" action=\"Drag\">
      <action name=\"Resize\"/>
    </mousebind>
  </context>

  <context name=\"Client\">
    <mousebind button=\"Left\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
    </mousebind>
    <mousebind button=\"Middle\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
    </mousebind>
    <mousebind button=\"Right\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
    </mousebind>
  </context>

  <context name=\"Icon\">
    <mousebind button=\"Left\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"Unshade\"/>
      <action name=\"ShowMenu\"><menu>client-menu</menu></action>
    </mousebind>
    <mousebind button=\"Right\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"ShowMenu\"><menu>client-menu</menu></action>
    </mousebind>
  </context>

  <context name=\"AllDesktops\">
    <mousebind button=\"Left\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"Unshade\"/>
    </mousebind>
    <mousebind button=\"Left\" action=\"Click\">
      <action name=\"ToggleOmnipresent\"/>
    </mousebind>
  </context>

  <context name=\"Shade\">
    <mousebind button=\"Left\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
    </mousebind>
    <mousebind button=\"Left\" action=\"Click\">
      <action name=\"ToggleShade\"/>
    </mousebind>
  </context>

  <context name=\"Iconify\">
    <mousebind button=\"Left\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
    </mousebind>
    <mousebind button=\"Left\" action=\"Click\">
      <action name=\"Iconify\"/>
    </mousebind>
  </context>

  <context name=\"Maximize\">
    <mousebind button=\"Left\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"Unshade\"/>
    </mousebind>
    <mousebind button=\"Middle\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"Unshade\"/>
    </mousebind>
    <mousebind button=\"Right\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"Unshade\"/>
    </mousebind>
    <mousebind button=\"Left\" action=\"Click\">
      <action name=\"ToggleMaximize\"/>
    </mousebind>
    <mousebind button=\"Middle\" action=\"Click\">
      <action name=\"ToggleMaximize\"><direction>vertical</direction></action>
    </mousebind>
    <mousebind button=\"Right\" action=\"Click\">
      <action name=\"ToggleMaximize\"><direction>horizontal</direction></action>
    </mousebind>
  </context>

  <context name=\"Close\">
    <mousebind button=\"Left\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
      <action name=\"Unshade\"/>
    </mousebind>
    <mousebind button=\"Left\" action=\"Click\">
      <action name=\"Close\"/>
    </mousebind>
  </context>

  <context name=\"Desktop\">
    <mousebind button=\"Up\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>previous</to></action>
    </mousebind>
    <mousebind button=\"Down\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>next</to></action>
    </mousebind>

    <mousebind button=\"A-Up\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>previous</to></action>
    </mousebind>
    <mousebind button=\"A-Down\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>next</to></action>
    </mousebind>
    <mousebind button=\"C-A-Up\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>previous</to></action>
    </mousebind>
    <mousebind button=\"C-A-Down\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>next</to></action>
    </mousebind>

    <mousebind button=\"Left\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
    </mousebind>
    <mousebind button=\"Right\" action=\"Press\">
      <action name=\"Focus\"/>
      <action name=\"Raise\"/>
    </mousebind>
  </context>

  <context name=\"Root\">
    <!-- Menus -->
    <mousebind button=\"Middle\" action=\"Press\">
      <action name=\"ShowMenu\"><menu>client-list-combined-menu</menu></action>
    </mousebind> 
    <mousebind button=\"Right\" action=\"Press\">
      <action name=\"ShowMenu\"><menu>root-menu</menu></action>
    </mousebind>
  </context>

  <context name=\"MoveResize\">
    <mousebind button=\"Up\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>previous</to></action>
    </mousebind>
    <mousebind button=\"Down\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>next</to></action>
    </mousebind>
    <mousebind button=\"A-Up\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>previous</to></action>
    </mousebind>
    <mousebind button=\"A-Down\" action=\"Click\">
      <action name=\"GoToDesktop\"><to>next</to></action>
    </mousebind>
  </context>
</mouse>

<menu>
  <!-- You can specify more than one menu file in here and they are all loaded,
       just don't make menu ids clash or, well, it'll be kind of pointless -->

  <!-- default menu file (or custom one in $HOME/.config/openbox/) -->
  <!-- system menu files on Debian systems -->
  <file>/var/lib/openbox/debian-menu.xml</file>
  <file>menu.xml</file>
  <hideDelay>200</hideDelay>
  <!-- if a press-release lasts longer than this setting (in milliseconds), the
       menu is hidden again -->
  <middle>no</middle>
  <!-- center submenus vertically about the parent entry -->
  <submenuShowDelay>100</submenuShowDelay>
  <!-- time to delay before showing a submenu after hovering over the parent
       entry.
       if this is a negative value, then the delay is infinite and the
       submenu will not be shown until it is clicked on -->
  <submenuHideDelay>400</submenuHideDelay>
  <!-- time to delay before hiding a submenu when selecting another
       entry in parent menu
       if this is a negative value, then the delay is infinite and the
       submenu will not be hidden until a different submenu is opened -->
  <applicationIcons>yes</applicationIcons>
  <!-- controls if icons appear in the client-list-(combined-)menu -->
  <manageDesktops>yes</manageDesktops>
  <!-- show the manage desktops section in the client-list-(combined-)menu -->
</menu>

<applications>
<!--
  # this is an example with comments through out. use these to make your
  # own rules, but without the comments of course.
  # you may use one or more of the name/class/role/title/type rules to specify
  # windows to match

  <application name=\"the window's _OB_APP_NAME property (see obxprop)\"
              class=\"the window's _OB_APP_CLASS property (see obxprop)\"
               role=\"the window's _OB_APP_ROLE property (see obxprop)\"
              title=\"the window's _OB_APP_TITLE property (see obxprop)\"
               type=\"the window's _OB_APP_TYPE property (see obxprob)..
                      (if unspecified, then it is 'dialog' for child windows)\">
  # you may set only one of name/class/role/title/type, or you may use more
  # than one together to restrict your matches.

  # the name, class, role, and title use simple wildcard matching such as those
  # used by a shell. you can use * to match any characters and ? to match
  # any single character.

  # the type is one of: normal, dialog, splash, utility, menu, toolbar, dock,
  #    or desktop

  # when multiple rules match a window, they will all be applied, in the
  # order that they appear in this list


    # each rule element can be left out or set to 'default' to specify to not 
    # change that attribute of the window

    <decor>yes</decor>
    # enable or disable window decorations

    <shade>no</shade>
    # make the window shaded when it appears, or not

    <position force=\"no\">
      # the position is only used if both an x and y coordinate are provided
      # (and not set to 'default')
      # when force is \"yes\", then the window will be placed here even if it
      # says you want it placed elsewhere.  this is to override buggy
      # applications who refuse to behave
      <x>center</x>
      # a number like 50, or 'center' to center on screen. use a negative number
      # to start from the right (or bottom for <y>), ie -50 is 50 pixels from the
      # right edge (or bottom).
      <y>200</y>
      <monitor>1</monitor>
      # specifies the monitor in a xinerama setup.
      # 1 is the first head, or 'mouse' for wherever the mouse is
    </position>

    <focus>yes</focus>
    # if the window should try be given focus when it appears. if this is set
    # to yes it doesn't guarantee the window will be given focus. some
    # restrictions may apply, but Openbox will try to

    <desktop>1</desktop>
    # 1 is the first desktop, 'all' for all desktops

    <layer>normal</layer>
    # 'above', 'normal', or 'below'

    <iconic>no</iconic>
    # make the window iconified when it appears, or not

    <skip_pager>no</skip_pager>
    # asks to not be shown in pagers

    <skip_taskbar>no</skip_taskbar>
    # asks to not be shown in taskbars. window cycling actions will also
    # skip past such windows

    <fullscreen>yes</fullscreen>
    # make the window in fullscreen mode when it appears

    <maximized>true</maximized>
    # 'Horizontal', 'Vertical' or boolean (yes/no)
  </application>

  # end of the example
-->
</applications>

</openbox_config>
" > $userpath/.config/openbox/rc.xml;

######## Firewall ########
# http://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers
# http://unix.stackexchange.com/q/108029
# http://askubuntu.com/q/423630

# Just in case, you never know. ;-)
ip6tables --flush;
ip6tables --delete-chain;
iptables --flush;
iptables --delete-chain;

# Default policies.
ip6tables -P INPUT DROP;
ip6tables -P OUTPUT DROP;
ip6tables -P FORWARD DROP;
iptables -P INPUT DROP;
iptables -P OUTPUT DROP;
iptables -P FORWARD DROP;

# Deny malformed/illegal/corrupt signals.
iptables -A INPUT   -m state --state INVALID -j DROP;
iptables -A FORWARD -m state --state INVALID -j DROP;
iptables -A OUTPUT  -m state --state INVALID -j DROP;
iptables -A INPUT -f -j DROP; # fragments
iptables -A INPUT -p tcp ! --syn -m state --state NEW -j DROP; # new is synful
iptables -A INPUT -p tcp --tcp-flags ALL ALL -j DROP; # xmas
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP; # null
iptables -A INPUT -p tcp --tcp-flags ALL FIN,URG,PSH -j DROP;
iptables -A INPUT -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP;
iptables -A INPUT -p tcp --tcp-flags SYN,RST SYN,RST -j DROP;
iptables -A INPUT -p tcp --tcp-flags SYN,FIN SYN,FIN -j DROP;
# rfc1918
iptables-A INPUT -s 10.0.0.0/8 -j DROP;
iptables-A INPUT -s 172.16.0.0/12 -j DROP;
iptables-A INPUT -s 192.168.0.0/16 -j DROP;
# spoof
iptables -A INPUT -s 169.254.0.0/16 -j DROP;
iptables -A INPUT -s 127.0.0.0/8 -j DROP;
iptables -A INPUT -s 224.0.0.0/4 -j DROP;
iptables -A INPUT -d 224.0.0.0/4 -j DROP;
iptables -A INPUT -s 240.0.0.0/5 -j DROP;
iptables -A INPUT -d 240.0.0.0/5 -j DROP;
iptables -A INPUT -s 0.0.0.0/8 -j DROP;
iptables -A INPUT -d 0.0.0.0/8 -j DROP;
iptables -A INPUT -d 239.255.255.0/24 -j DROP;
iptables -A INPUT -d 255.255.255.255 -j DROP;
# icmp smurf
iptables -A INPUT -p icmp --icmp-type address-mask-request -j DROP;
iptables -A INPUT -p icmp --icmp-type timestamp-request -j DROP;
iptables -A INPUT -p icmp --icmp-type router-solicitation -j DROP;
# http://security.stackexchange.com/a/4745

# Allow incoming signals.
iptables -A INPUT -i lo -m state --state ESTABLISHED -j ACCEPT; # loopback
iptables -A INPUT -p icmp --icmp-type echo-reply -m limit --limit 2/second -m state --state ESTABLISHED -j ACCEPT;
iptables -A INPUT -p udp -m multiport --sports 53,123 -m state --state ESTABLISHED -j ACCEPT;
iptables -A INPUT -p tcp -m multiport --sports 22,80,443 -m state --state ESTABLISHED -j ACCEPT;
#iptables -A INPUT -p tcp -m multiport --sports 113,194,994,6660:6669,6679,6697 -m state --state ESTABLISHED -j ACCEPT;
#iptables -A INPUT -p tcp -m multiport --sports 26000:28000 -m state --state ESTABLISHED -j ACCEPT;

# Allow outgoing signals.
iptables -A OUTPUT -o lo -m state --state NEW,ESTABLISHED -j ACCEPT; # loopback
iptables -A OUTPUT -p icmp --icmp-type echo-request -m limit --limit 2/second -m state --state NEW,ESTABLISHED -j ACCEPT;
iptables -A OUTPUT -p udp -m multiport --dports 53,123 -m state --state NEW,ESTABLISHED -j ACCEPT;
iptables -A OUTPUT -p tcp -m multiport --dports 22,80,443 -m state --state NEW,ESTABLISHED -j ACCEPT;
#iptables -A OUTPUT -p tcp -m multiport --dports 113,194,994,6660:6669,6679,6697 -m state --state NEW,ESTABLISHED -j ACCEPT;
#iptables -A OUTPUT -p tcp -m multiport --dports 26000:28000 -m state --state NEW,ESTABLISHED -j ACCEPT;

# Defensive persistence.
iptables-save > /etc/iptables/rules.v4;
ip6tables-save > /etc/iptables/rules.v6;
service iptables-persistent start;

# https://wiki.archlinux.org/index.php/Keyboard_configuration_in_Xorg
# https://wiki.debian.org/EnvironmentVariables
