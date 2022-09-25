$driveletter = $pwd.drive.name #retourne la lettre du disque actuel
$root = "$driveletter" + ":" #rajoute  : pour que sa fit dans le path
$applications = "$root\\_Tech\applications" #chemin du dossier applications

#$categorie = "diagnostique"
#$nomApplicationAMettreAJour = "Batterie"
#$liengithub = 'https://raw.githubusercontent.com/jeremyrenaud42/Menu/main/test.version.txt'

#dossier temp créé dans la catégorie

function Update($categorie,$nomApplicationAMettreAJour,$liengithub)
{
    $dossierTemp = "$root\_Tech\applications\$categorie\source\$nomApplicationAMettreAJour\Temp" #path
    try 
    {
        New-Item -Path $dossierTemp -ItemType Directory | Out-Null #créer dossier temp
    }   
    catch 
    {
        Write-Error "Erreur! Le dossier temporaire n'a pas pu être créé!"
        return
    }

    #Il faut download le fichier version depuis github
    Invoke-WebRequest 'https://raw.githubusercontent.com/jeremyrenaud42/versions/main/Diagnostique/speccy.version.txt' -OutFile "$applications\$categorie\source\$nomApplicationAMettreAJour\speccy.version.txt" | Out-Null

    #Il faut aller chercher le chiffre dans les 2 fichiers
    $valuedownloadfile = Get-Content -Path "$dossierTemp\*.version.txt" #fichier version nouveau
    $valueactualfile = Get-Content -Path "$applications\$categorie\source\$nomApplicationAMettreAJour\*.version.txt" #fichier version actuel
    
    #Il faut comparer les 2 valeurs
    if ($valuedownloadfile -gt $valueactualfile) 
    { 
        try 
        {
            Write-Host "Mise à jour en cours..."
            #Copy-Item -Path "$dossierTemp\$nomApplicationAMettreAJour" -Destination $dossierParentApplication -Recurse -Force | Out-Null
            #Mettre un invokeweb request pour faire l'update
        }
        catch 
        {
            Write-Error "Erreur! La copie du dossier temporaire de mise à jour a échoué!"
            return
        }
    } 
    Remove-Item $dossierTemp -Recurse -Force #Supprime le dossier temp
    return  
}