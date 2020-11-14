$dirR1 = "C:\Records\BigBrotherWatch-1"		#Пути к рабочим каталогам
$dirR2 = "C:\Records\BigBrotherWatch-2"
$dirR3 = "C:\Records\BigBrotherWatch-3"
$dirR4 = "C:\Records\BigBrotherWatch-4"
$dirR5 = "C:\Records\BigBrotherWatch-5"

$rDir1 = "Z:\BigBrotherWatch-01"
$rDir2 = "Z:\BigBrotherWatch-02"
$rDir3 = "Z:\BigBrotherWatch-03"
$rDir4 = "Z:\BigBrotherWatch-04"
$rDir5 = "Z:\BigBrotherWatch-05"

function destination ($dir)	{
	if ($dir -eq $dirR1)	{return $rDir1}
	if ($dir -eq $dirR2)	{return $rDir2}
	if ($dir -eq $dirR3)	{return $rDir3}
	if ($dir -eq $dirR4)	{return $rDir4}
	if ($dir -eq $dirR5)	{return $rDir5}
}

function getOldest ($dir)	{	#Получаем путь к самому старому каталогу
	$pathFrom = $dir
	if (-not (exeptEmptyFolder($pathFrom))) {
		$oldest = Get-ChildItem -Path $pathFrom | Sort-Object LastAccessTime -Descending | Select-Object -Last 1
		$date = Get-Date -Format "dd.MM.yyyy"
		if (($oldest.name -ne $date) -and ($oldest.name -ne "work.dir"))	{
			return $oldest.name
		}
		else {return 0}
	}
	else {return 0}
}

function exeptEmptyFolder ($path)	{	#Проверка на наличие содержимого в папке
    [int] $fileCount = (Get-ChildItem $path).Count
    if ($fileCount -eq 0) {return 1}
    else {return 0}
}

function toServer ($dir)	{
	$oldName = getOldest($dir)
	if ($oldName -ne 0)	{
		$source = $dir + "\" + $oldName
		$destination = destination($dir)
		$destination = $destination + "\" + $oldName
		Copy-Item -Path $source -Destination $destination -Recurse -Force
		Get-ChildItem $source -recurse | Remove-Item
		Remove-Item $source
		$successMessage = $source + " moved to server"
		echo $successMessage
	}
	else	{
		$emptyMessage = "Nothing to do with " + $dir 
		echo $emptyMessage
	}
}


while (1)	{	#Обрабатываем одну папку раз в час, дабы не грузить сеть
	toServer($dirR1)
	Start-Sleep -s 3600
	toServer($dirR2)
	Start-Sleep -s 3600
	toServer($dirR3)
	Start-Sleep -s 3600
	toServer($dirR4)
	Start-Sleep -s 3600
	toServer($dirR5)
	Start-Sleep -s 3600
}