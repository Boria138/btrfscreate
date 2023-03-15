#!/bin/bash
#
# Btrfscreate v2.0
# ----------------------------------------|
#           :
# Forked by : Barry
#           :
# Based on  : https://github.com/shefpower/btrfscreate.git
#           :
# License   : LGPL-3.0 (http://opensource.org/licenses/lgpl-3.0.html)
#           :
#----------------------------------------------------------------------|
clear
setfont cyr-sun16
echo '
$$$$$$$\    $$\                $$$$$$\                                                    $$\
$$  __$$\   $$ |              $$  __$$\                                                   $$ |
$$ |  $$ |$$$$$$\    $$$$$$\  $$ /  \__|$$$$$$$\  $$$$$$$\  $$$$$$\   $$$$$$\   $$$$$$\ $$$$$$\    $$$$$$\
$$$$$$$\ |\_$$  _|  $$  __$$\ $$$$\    $$  _____|$$  _____|$$  __$$\ $$  __$$\  \____$$\\_$$  _|  $$  __$$\
$$  __$$\   $$ |    $$ |  \__|$$  _|   \$$$$$$\  $$ /      $$ |  \__|$$$$$$$$ | $$$$$$$ | $$ |    $$$$$$$$ |
$$ |  $$ |  $$ |$$\ $$ |      $$ |      \____$$\ $$ |      $$ |      $$   ____|$$  __$$ | $$ |$$\ $$   ____|
$$$$$$$  |  \$$$$  |$$ |      $$ |     $$$$$$$  |\$$$$$$$\ $$ |      \$$$$$$$\ \$$$$$$$ | \$$$$  |\$$$$$$$\
\_______/    \____/ \__|      \__|     \_______/  \_______|\__|       \_______| \_______|  \____/  \_______|


        <───────────────────────────────────────────────────────────────────────────>
                     Внимание !  скрипт НЕ создает разделы на диске , разделы вы
                создаёте сами , поэтому если вы еще не создали разделы - создайте их
        <───────────────────────────────────────────────────────────────────────────>

'
sleep 3
clear
echo '
                                        Выбор разделов

      .────────────────────────────────────────────────────────────────────────────────.
      .                                                                                .
      .                                                                                .
      .                             Введите разделы диска                              .
      .                                                                                .
      .       (Root- Корневой)  (Boot- Загрузочный) (Swap- Подкачка) (Swap file)       .
      .                                                                                .
      .                                                                                .
      .                  Например ( sda2, sdb2, sdc2 , nvme0n1p2 )                     .
      .                                                                                .
      .                                                                                .
      .                (Swap file - размер файла подкачки для EXT4 в mb)               .
      .                                                                                .
      .                                                                                .
      .                                                                                .
      .                                                                                .
      .────────────────────────────────────────────────────────────────────────────────.

'
read -p "
                                 -> Boot: " boot
read -p "
                                 -> Root: " root
read -p "
                                 -> Swap: " swap
read -p "
                                 -> Swap file: " swap_file

clear

echo '
                          Выбор файловой системы Boot раздела

              .─────────────────────────────────────────────────────────────.
              .                                                             .
              .                                                             .
              .      Выберите файловую систему загрузочного  boot раздела   .
              .                                                             .
              .  Согласно вашей версии Bios (обычный старый BIOS или UEFI)  .
              .                                                             .
              .   Для UEFI формат FAT32 . Для обычнго BIOS Ext4 или Ext2    .
              .                                                             .
              .                                                             .
              .─────────────────────────────────────────────────────────────.

'
echo -e "\t

                       -> Для UEFI введите                    1"
echo -e "\t



                       -> Не форматировать  введите           2


                       ( Для установки в один раздел DOS/MBR или рядом с Windows )"
echo -e "\t




                     -> Для обычного Bios форматировать в Ext4 введите    3"
echo -e "\t


                     -> Для обычного Bios фоматировать в Ext2 введиет     4"
echo -n "


                           -> Введите значение : "
read main_menu
      case "$main_menu" in
         "1" ) clear ; mkfs.vfat -F32 /dev/$boot
         ;;
         "3" ) clear ; mkfs.ext4 /dev/$boot
         ;;
         "4" ) clear ; mkfs.ext2 /dev/$boot
         ;;
         "2" ) clear
      esac

clear
echo '
                                 Выбор файловой системы

              .──────────────────────────────────────────────────────────────.
              .                                                              .
              .                                                              .
              .             Выберите файловую систему                        .
              .                                                              .
              .                                                              .
              .──────────────────────────────────────────────────────────────.

'
echo -e "\t

                       -> Форматировать в BTRFS      1"
echo -e "\t



                       -> Форматировать в EXT4      2"
echo -n "


                           -> Введите значение : "
read main_menu
      case "$main_menu" in
         "1" )mkfs.btrfs -f /dev/$root ; mkswap /dev/$swap ; swapon /dev/$swap ; clear ;
         echo '
                          Монтирование BTRFS для SSD и HDD

             .───────────────────────────────────────────────────────.
             .                                                       .
             .                                                       .
             .        Выберите один из вариантов монтирования        .
             .                                                       .
             .                                                       .
             .───────────────────────────────────────────────────────.
         '
echo -e "\t


                              ->  Смонтировать для HDD     1"

echo -e "\t

                              ->  Смонтировать для SSD    2"

echo -n "

                               -> Введите значение : "

read main_menu
      case "$main_menu" in
         "1")
mount  /dev/$root /mnt

btrfs su cr /mnt/@

btrfs su cr /mnt/@home

umount /mnt

mount -o rw,relatime,compress=zstd:3,max_inline=256,commit=120,autodefrag,subvol=@ /dev/$root /mnt

mkdir /mnt/{boot,home}

mount -o rw,relatime,compress=zstd:2,max_inline=256,commit=120,autodefrag,subvol=@home  /dev/$root  /mnt/home
        ;;
        "2" )

mount  /dev/$root /mnt

btrfs su cr /mnt/@

btrfs su cr /mnt/@home

umount /mnt

mount -o rw,relatime,compress=zstd:2,ssd_spread,max_inline=256,commit=120,subvol=@ /dev/$root /mnt

mkdir /mnt/{boot,home}

mount -o rw,relatime,compress=zstd:2,ssd_spread,max_inline=256,commit=120,subvol=@home  /dev/$root  /mnt/home
clear
       esac
        ;;
        "2" ) mkfs.ext4 -f /dev/$root ; dd if=/dev/zero of=/swapfile bs=1M count=$swap_file status=progress ; chmod 0600 /swapfile ; mkswap -U clear /swapfile ; swapon /swapfile ; clear
      esac
clear
echo '
                              Монтирование boot раздела

               .─────────────────────────────────────────────────────────.
               .                                                         .
               .                                                         .
               .          Монтирование загрузочного раздела !            .
               .                                                         .
               .    Выберите один из вариантов монтирования boot раздела .
               .                                                         .
               .        Для обычного биоса (НЕ UEFI) введите 2           .
               .                                                         .
               .              Для UEFI биоса , введите 1                 .
               .                                                         .
               .                                                         .
               .─────────────────────────────────────────────────────────.
'
echo -e "\t

                        -> Для UEFI или EFI введите     1"
echo -e "\t


                        -> Для обычного Bios введите    2"
echo -n "


                        -> Введите значение : "
read main_menu
      case "$main_menu" in
         "1" ) mkdir /mnt/boot/efi ; mount /dev/$boot /mnt/boot/efi
         ;;
         "2" ) mount /dev/$boot  /mnt/boot/
      esac

clear
lsblk
