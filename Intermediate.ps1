$driveletter = $pwd.drive.name #retourne la lettre du disque actuel
$root = "$driveletter" + ":" #rajoute  : pour que sa fit dans le path
Start-Process "$root\_Tech\menu.exe" 