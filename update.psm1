#function mettreAJourDossier ($lienweb, $dossierParentApplication, $nomApplicationAMettreAJour) 
#lien github/ftp, Path de dossier parents du dossier à mettre à jours , nom du dossier à mettre à jours dans la clé

$driveletter = $pwd.drive.name #retourne la lettre du disque actuel
$root = "$driveletter" + ":" #rajoute  : pour que sa fit dans le path

$categorie = "diagnostique"
$nomApplicationAMettreAJour = "Batterie"
$liengithub = 'https://raw.githubusercontent.com/jeremyrenaud42/Menu/main/test.version.txt'

#créer dossier Temp (Testé et fonctionnel)
#dossier temp créé dans la catégorie
function tempfolder
{
$dossierTemp = "$root\_Tech\applications\$categorie\Temp" #path
    try 
    {
        New-Item -Path $dossierTemp -ItemType Directory | Out-Null #créer dossier temp
    }   
    catch 
    {
        Write-Error "Erreur! Le dossier temporaire n'a pas pu être créé!"
        return
    }
}
#Il faut aller chercher le fichier version dans le dossier de l'app en question
#Il faut download le fichier version depuis github
#Il faut get-content dans les 2 fichier et effectuer l'Update si nécéssaire


#Vérifie si une nouvelle version est disponible
function verif
{

    Invoke-WebRequest $liengithub -OutFile $dossierTemp\app.version.txt | Out-Null #Download du fichier version

    $versionTemp = Get-Content -Path "$dossierTemp\$nomApplicationAMettreAJour\*.version.txt" #fichier version nouveau
    $versionActuelle = Get-Content -Path "$root\_tech\applications\$categorie\$nomApplicationAMettreAJour\*.version.txt" #fichier version actuel
    if ($versionTemp -gt $versionActuelle) 
    { 
        try 
        {
            Write-Host "Mise à jour en cours..."
            #Copy-Item -Path "$dossierTemp\$nomApplicationAMettreAJour" -Destination $dossierParentApplication -Recurse -Force | Out-Null
            #Mettre un invokeweb request pour faire l'update
        }
        catch 
        {
            Write-Error "Erreur! La copie du dossier temporaire de mise à jour ($dossierTemp) vers le dossier d'application ($dossierParentApplication) a échoué!"
            return
        }
    } 
    Remove-Item $dossierTemp -Recurse -Force #Supprime le dossier temp
    return  
}


    

    #exemple: verifiermiseajours "https://mega.nz/folder/Fx02GRya#wmbMcqi98YPVVVnhNkvxxw" "Diagnostique" "verifAida"