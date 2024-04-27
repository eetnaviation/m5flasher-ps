# m5flasher-ps (powershell)
What is this? This is a powershell flasher for ESP32 based m5stack products. I have tested it on my own M5Stick C plus2.
# How do I use it?
There are 2 ways:
## CLI w/ arguments
.\m5flasher.ps1 /? --> Shows help dialog
.\m5flasher.ps1 /LISTPORTS --> List all available serial devices (COM ports)
.\m5flasher.ps1 /FLASH <COM port to be flashed (for example COM1)> <binary file full path to flash (C:\folder\flash_this_file.ps1)>
## CLI without arguments
Just run .\m5flasher.ps1 and it will ask you the arguments and show everything nicely.
