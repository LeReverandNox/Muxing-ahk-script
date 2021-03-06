SetWorkingDir %A_ScriptDir%
folder = %A_ScriptDir%

;~ On dit bonjour !
msgbox, Bienvenue dans le mega-muxer du poney !

;~ On creer une petite variable pour compter les tours de la boucle
i = 0

;~ On compte les fichiers mkv et on stock le r�sultat dans count
SetBatchLines -1
count := 0
Loop, %folder%\*.mkv, 1, 0 
  count += 1
;~ msgbox, %count%

;~ Si pas de mkv, on affiche une erreur
if count = 0
{
	msgbox, Aucun fichier trouv�
	msgbox, Bye bye.
	ExitApp
}

;~ Sinon, on affiche le nombre de fichier � mux
else
{
	msgbox, %count% fichiers trouv�s !
}

;~ On v�rifie la pr�sence des dossiers Muxed et Sources et s'ils n'existent pas, on les creer
IfNotExist, %folder%\Muxed
{
FileCreateDir, %folder%\Muxed
}

IfNotExist, %folder%\Sources
{
FileCreateDir, %folder%\Sources
}

;~ On boucle tant qu'il y a des �pisodes
while i < count
{
	;~ On stock le nom du fichier trouv� dans une variable, et on retire l'extension
	Loop, %folder%\*.mkv
	filename = %A_LoopFileName%
	StringTrimRight, filename, filename, 4
	;~ On affiche le nom du fichier sur le quel on travail
	;~ msgbox, Fichier � traiter : %filename% - Au boulot !
	
	;~ On supprime l'ancien et on cr�e un petit script batch pour mux
	FileDelete, %folder%\mux.bat
	FileAppend,
	(
	"C:\Program Files (x86)\MKVToolNix\mkvmerge.exe" -o "%folder%\Muxed\%filename%.mkv"  "--sub-charset" "0:UTF-8" "--language" "0:fre" "--track-name" "0:Sous-titres" "--forced-track" "0:no" "-s" "0" "-D" "-A" "-T" "--no-global-tags" "--no-chapters" "(" "%folder%\%filename% VF.srt" ")" "--sub-charset" "0:UTF-8" "--language" "0:eng" "--track-name" "0:Subtitles" "--forced-track" "0:no" "-s" "0" "-D" "-A" "-T" "--no-global-tags" "--no-chapters" "(" "%folder%\%filename% VO.srt" ")" "--language" "0:eng" "--default-track" "0:no" "--forced-track" "0:no" "--aspect-ratio" "0:16/9" "--default-track" "1:yes" "--forced-track" "1:no" "-a" "1" "-d" "0" "-S" "-T" "--no-global-tags" "--no-chapters" "(" "%folder%\%filename%.mkv" ")" "--track-order" "0:0,1:0,2:0,2:1"
	), %folder%\mux.bat
		
	;~ On execute le script
	RunWait, %folder%\mux.bat, %folder%, hide,
	If ErrorLevel
	{
		msgbox, �chec du muxage
		ExitApp
	}
	else
	{
		;~ msgbox, Fichiers mux�s !
	}
	;~ On supprime le script
	FileDelete, %folder%\mux.bat
	
	;~ On d�place les fichiers sources dans le dossier Sources
	FileMove, %filename%*.*, %folder%\Sources\
	;~ msgbox, Fichiers sources d�plac�s !
	
	;~ On incr�mente le compteur
	i += 1
}
 ;~ On dit au revoir !
msgbox, Merci de m'avoir utilis� pour muxer vos fichiers :)
ExitApp

