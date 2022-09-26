$driveletter = $pwd.drive.name #retourne la lettre du disque actuel
$root = "$driveletter" + ":" #rajoute  : pour que sa fit dans le path
$applications = "$root\\_Tech\applications" #chemin du dossier applications

function Update($categorie,$nomApplicationAMettreAJour,$liengithub,$lienappligithub)
{
    $dossierTemp = "$root\_Tech\applications\$categorie\source\$nomApplicationAMettreAJour\Temp" #path du dossier Temp
    try 
    {
        New-Item -Path $dossierTemp -ItemType Directory -Force | Out-Null #créer dossier temp
    }   
    catch 
    {
        Write-Error "Erreur! Le dossier temporaire n'a pas pu être créé!"
        return
    }

    #Download le fichier version depuis github
    Invoke-WebRequest 'https://raw.githubusercontent.com/jeremyrenaud42/versions/main/Diagnostique/speccy.version.txt' -OutFile "$applications\$categorie\source\$nomApplicationAMettreAJour\Temp\speccy.version.txt" | Out-Null

    #cherche le chiffre dans les 2 fichiers
    $valuedownloadfile = Get-Content -Path "$dossierTemp\*.version.txt" #fichier version nouveau
    $valueactualfile = Get-Content -Path "$applications\$categorie\source\$nomApplicationAMettreAJour\*.version.txt" #fichier version actuel
    
    #compare les 2 valeurs
    if ($valuedownloadfile -gt $valueactualfile) 
    { 
        try 
        {
            Write-Host "Mise à jour en cours..."
            Invoke-WebRequest $lienappligithub -OutFile "$applications\$categorie\source\Speccy.zip" | Out-Null
            Expand-Archive "$applications\$categorie\source\Speccy.zip" "$applications\$categorie\source" -Force | Out-Null
            Remove-Item "$applications\$categorie\source\Speccy.zip" -Force | Out-Null
            Copy-Item "$applications\$categorie\source\$nomApplicationAMettreAJour\Temp\speccy.version.txt" -Destination "$applications\$categorie\source\$nomApplicationAMettreAJour\speccy.version.txt" -Force | Out-Null #Met le fichier version a jour.
        }
        catch 
        {
            Write-Error "Erreur!"
            return
        }
    } 
    Remove-Item $dossierTemp -Recurse -Force #Supprime le dossier temp
    return  
}

#exemple de call
#Import-Module "E:\_Tech\Applications\Source\update.psm1"
#Update "Diagnostique" "Speccy" 'https://raw.githubusercontent.com/jeremyrenaud42/versions/main/Diagnostique/speccy.version.txt' 'https://raw.githubusercontent.com/jeremyrenaud42/Diagnostique/main/Speccy.zip'