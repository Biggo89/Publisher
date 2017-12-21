$application = ""
$source = ""
$destination = ""
$destination2 = ""
$response = ""
$backupSource = 0
$backupDest = 0


do {
    do {
        write-host ""
        write-host "1 - MyIdea - dev shared   --> vdimove_cert|vdimove_prod"
        write-host "2 - MyIdea - vdimove_cert --> cert"
        write-host "3 - MyIdea - vdimove_prod --> prod"

        write-host ""
        write-host "X - Exit"
        write-host ""
        write-host -nonewline "Type your choice and press Enter: "
        
        $choice = read-host
        
        write-host ""
        
        $ok = $choice -match '^[123xX]+$'
        
        if ( -not $ok) { write-host "Invalid selection" }
    } until ( $ok )
    
$application = ""
$source = ""
$destination = ""
$destination2 = ""
$response = ""
$backupSource = 0
$backupDest = 0

    switch -Regex ( $choice ) {
        1 {
            $application = "FI303 - MyIdea - da dev shared a vdimove_cert e vdimove_prod"
            $source = "\\10.26.49.247\c$\inetpub\wwwroot\MyIdea"
            $destination = "\\xittor47fscd020.fgcorp.fgad.fg.local\FI303_CERT\web_$(get-date -f yyyyMMdd)"
            $destination2 = "\\xittor47fscd020.fgcorp.fgad.fg.local\FI303_PROD\web_$(get-date -f yyyyMMdd)"
			$backupSource = 1
        }
        2 {
            $application = "FI303 - MyIdea - da vdimove_cert a server cert"
            $source = "\\xittor47fscc030.fgcorp.fgad.fg.local\FI303_CERT\web_$(get-date -f yyyyMMdd)"
            $destination = "\\XITTOR47WBCC060.fgcorp.fgad.fg.local\MyIdea"
			$backupDest = 1
        }
        3 {
            $application = "FI303 - MyIdea - da vdimove_prod a server prod"
            $source = "\\xittor47fscp110.fgcorp.fgad.fg.local\FI303_PROD\web_$(get-date -f yyyyMMdd)"
            $destination = "\\XITTOR47WBCP040.fgcorp.fgad.fg.local\MyIdea"
			$backupDest = 1
        }
    }
	If($choice -ne "x" -or $choice -ne "X" ){
		write-host "Procedere con la pubblicazione di $application ?(s/n)"
		$choice = read-host
		If($choice -eq "s" -or $choice -eq "S" ){
			write-host "Vuoi sovrascrivere i weconfig?(s/n)"
			$choice = read-host			
			write-host ""
			if($backupSource -eq 1){
				write-host "Backup`n   FROM -> $source`n   TO   -> $source\Backup_ps"
				robocopy $source "$source\Backup_ps\web_$(get-date -f yyyyMMddhhmmss)" /e /COPY:DT /xd "Backup_ps" /NFL /NDL /NJH /NJS
				If ($lastexitcode -eq 0 -or $lastexitcode -eq 1){ $response = "$response`n------------------> Backup_ps done!" }
				else { $response = "$response`nxxxxxxxxxxxxxxxxxx> Backup_ps error! errorCode:$lastexitcode" }
			}
			if($backupDest -eq 1){
				write-host "Backup`n   FROM -> $destination`n   TO   -> $destination\Backup_ps\web_$(get-date -f yyyyMMddhhmmss)"
				robocopy $destination "$destination\Backup_ps\web_$(get-date -f yyyyMMddhhmmss)" /e /COPY:DT /xd "Backup_ps" /NFL /NDL /NJH /NJS
				If ($lastexitcode -eq 0 -or $lastexitcode -eq 1){ $response = "$response`n------------------> Backup_ps done!" }
				else { $response = "$response`nxxxxxxxxxxxxxxxxxx> Backup_ps error! errorCode:$lastexitcode" }
			}
			
			If($choice -eq "s" -or $choice -eq "S" ){
				write-host "Copia`n   FROM -> $source`n   TO   -> $destination"
				robocopy $source $destination /e /COPY:DT /xd "Backup_ps" /MIR /NFL /NDL /NJH /NJS
				If ($lastexitcode -eq 0 -or $lastexitcode -eq 1){ $response = "$response`n------------------> Copy destination done!" }
				else { $response = "$response`nxxxxxxxxxxxxxxxxxx> Copy destination error! errorCode:$lastexitcode" }
				If($destination2 -ne "") {
					write-host "Copia`n   FROM -> $source`n   TO   -> $destination2"
					robocopy $source $destination2 /e /COPY:DT /xd "Backup_ps" /MIR /NFL /NDL /NJH /NJS
					If ($lastexitcode -eq 0 -or $lastexitcode -eq 1){ $response = "$response`n------------------> Copy destination2 done!" }
					else { $response = "$response`nxxxxxxxxxxxxxxxxxx> Copy destination2 error! errorCode:$lastexitcode" }
				}
			}else{
				write-host "Copia`n   FROM -> $source`n   TO   -> $destination"
				robocopy $source $destination /e /COPY:DT /xf "web.config" /xd "Backup_ps" /MIR /NFL /NDL /NJH /NJS
				If ($lastexitcode -eq 0 -or $lastexitcode -eq 1){ $response = "$response`n------------------> Copy destination without web.config done!" }
				else { $response = "$response`nxxxxxxxxxxxxxxxxxx> Copy destination without web.config error! errorCode:$lastexitcode" }
				$exclude = @('*.config')
				If($destination2 -ne "") {
					write-host "Copia`n   FROM -> $source`n   TO   -> $destination2"
					robocopy $source $destination2 /e /COPY:DT /xf "web.config" /xd "Backup_ps" /MIR /NFL /NDL /NJH /NJS
					If ($lastexitcode -eq 0 -or $lastexitcode -eq 1){ $response = "$response`n------------------> Copy destination2 without web.config done!" }
					else { $response = "$response`nxxxxxxxxxxxxxxxxxx> Copy destination2 without web.config error! errorCode:$lastexitcode" }
				}
			}
		}
		
		write-host ""
		write-host ""
		write-host ""
        write-host "***************************************************************"
        write-host "***************************************************************"
		write-host $response
		write-host ""
		write-host "***************************************************************"
		write-host "***************************************************************"
		write-host ""
		write-host ""
	}
} until ( $choice -eq "x" -or $choice -eq "X")




















