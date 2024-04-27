function ArgsMode {
	if ($action -eq "/?") {
		HelpDialog
	} elseif ($action -eq "/LISTPORTS") {
		ListPorts
	} elseif ($action -eq "/FLASH") {
		ArgsModeFlash
	}
}

function Cli-GuiMode {
	ListPorts
	$serialPortChoice = Read-Host "COM port? "
	$serialPortChoiceUpper = $serialPortChoice.ToUpper()

	$regexSerialPortChoiceUpper = [Regex]::Match($serialPortList, "$serialPortChoiceUpper")

	if ($regexSerialPortChoiceUpper) {
		Write-Output "[OK] Matched COM port."
		try {
			$binaryFileDirectory = Read-Host "Enter .bin file path: "
			if ([System.IO.File]::Exists($binaryFileDirectory)) {
				Write-Output "[OK] File path checked out! Checking extension."
				if ([IO.Path]::GetExtension($binaryFileDirectory) -eq ".bin") {
					Write-Output "[OK] File extension appeared to be .bin! Continue flashing process"
					if ($debugEnabled -eq $false) {
						Write-Output "[OK] Debug mode is not enabled! Continue flashing process."
						esptool.py --port $serialPortChoice -b 115200 write_flash -z 0x0 $binaryFileDirectory
					} else {
						Write-Output "[FAIL] Debug mode is enabled. Unable to continue!"
					}
				} else {
					Write-Output "[FAIL] File extension invalid. Is it .bin?"
				}
			} else {
				Write-Output "[FAIL] File path invalid. Does it exist?"
			}
		} catch {
			"[FAIL] Error occured. Please check logs above this line."
		}
	} else {
		Write-Output "[FAIL] You have entered an invalid COM port address, or none at all."
	}
}

function HelpDialog {
	Write-Output "M5FLASHER by eetnaviation, https://velend.eu/ , https://github.com/eetnaviation"
	Write-Output "------------------------------------"
	Write-Output ".\m5flasher.ps1 <arg1> [arg2] [arg3]"
	Write-Output "arg1 can be -->"
	Write-Output "--> /? - Shows this help dialog"
	Write-Output "--> /LISTPORTS - Shows all available serial devices"
	Write-Output "--> /FLASH - Run flasher"
	Write-Output "------------------------------------"
	Write-Output ".\m5flasher.ps1 /FLASH <arg2> <arg3>"
	Write-Output "arg2 is --> COM (Serial device) port to be flashed"
	Write-Output "arg3 is --> .bin file path (C:\Folder\flash_this_file.bin)"
}

function ListPorts {
	# Get serial ports and show them on the screen
	$serialPortGet = Get-WMIObject Win32_SerialPort
	$serialPortList = $serialPortGet | ForEach-Object { $_.Name + "`n" } # Create a list of all serial devices
	$serialPortList = "-------COM port list-------`n" + $serialPortList + "---------------------------" # This adds nice formatting to the list
	Write-Output $serialPortList
}

function ArgsModeFlash {
	$serialPortChoice = $comport
	$serialPortChoiceUpper = $serialPortChoice.ToUpper()

	$regexSerialPortChoiceUpper = [Regex]::Match($serialPortList, "$serialPortChoiceUpper")

	if ($regexSerialPortChoiceUpper) {
		Write-Output "[OK] Matched COM port."
		try {
			$binaryFileDirectory = $binFilePathArg
			if ([System.IO.File]::Exists($binaryFileDirectory)) {
				Write-Output "[OK] File path checked out! Checking extension."
				if ([IO.Path]::GetExtension($binaryFileDirectory) -eq ".bin") {
					Write-Output "[OK] File extension appeared to be .bin! Continue flashing process"
					if ($debugEnabled -eq $false) {
						Write-Output "[OK] Debug mode is not enabled! Continue flashing process."
						esptool.py --port $serialPortChoice -b 115200 write_flash -z 0x0 $binaryFileDirectory
					} else {
						Write-Output "[FAIL] Debug mode is enabled. Unable to continue!"
					}
				} else {
					Write-Output "[FAIL] File extension invalid. Is it .bin?"
				}
			} else {
				Write-Output "[FAIL] File path invalid. Does it exist?"
			}
		} catch {
			"[FAIL] Error occured. Please check logs above this line."
		}
	} else {
		Write-Output "[FAIL] You have entered an invalid COM port address, or none at all."
	}
}

Write-Output "[INFO] Supply argument /? to see available arguments. This program can also run without arguments."

$debugEnabled = $false # Debug mode. Set to false when actually using!

# Check if arguments were supplied
if ($args.Length -eq 0) {
    Write-Host "[INFO] No arguments supplied! Running in CLI-GUI mode."
	Cli-GuiMode
} else {
    Write-Host "[INFO] Arguments supplied. Running in args-only mode."
    # Take input parameters
	$action = $args[0]
	if ( ($action -eq "/FLASH") -and ($args[2] -ne $null) -and ($args[1] -ne $null) ) {
		$comport = $args[1]
		$binFilePathArg = $args[2]
	} elseif ( ($action -eq "/FLASH") -and ($args[2] -eq $null) -and ($args[1] -eq $null) ) {
		Write-Output "[FAIL] You tried to run /FLASH without supplying all of the arguments! Please take a look at /? (help menu)."
	}
	ArgsMode
}