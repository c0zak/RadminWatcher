$dirR1 = "C:\Records\BigBrotherWatch-1"		#Пути к рабочим каталогам
$dirR2 = "C:\Records\BigBrotherWatch-2"
$dirR3 = "C:\Records\BigBrotherWatch-3"
$dirR4 = "C:\Records\BigBrotherWatch-4"
$dirR5 = "C:\Records\BigBrotherWatch-5"
$workDir = "\work.dir"


function getOldestFile ($dir)	{	#Получаем путь к самому старому файлу, если в рабочей папке пусто - генерим ошибку
	$pathFrom = $dir+$workDir;
	if (-not (exeptEmptyFolder($pathFrom))) {
		$oldest = Get-ChildItem -Path $pathFrom | Sort-Object LastAccessTime -Descending | Select-Object -Last 1
		return $pathFrom + "\" + $oldest.name
	}
	else {return 0}
}

function exeptEmptyFolder ($path)	{	#Проверка на наличие содержимого в папке
    [int] $fileCount = (Get-ChildItem $path).Count
    if ($fileCount -eq 0) {return 1}
    else {return 0}
}

function moveFile ($dir)	{	#Перемещаем файлы по подпапкам с датой записи
	$path = getOldestFile($dir)
	if ($path -ne 0)	{
		$file = Get-Item $path
		$dirDate = $file.CreationTime;
		$fileName = $file.Name
		$dirName = $dir + "\" + $dirDate.toString("dd.MM.yyyy")
		if (-not (Test-Path -path $dirName))	{
			New-Item -path $dirName -ItemType Directory
		}
		$dirName = $dirName + "\" + $fileName
		Move-Item -path $path -destination $dirName
		return $fileName + " successfully moved"
	}
	else {return 0}
}

while (1)	{
	$out = moveFile($dirR1)
	if ($out -ne 0)
	{echo $out}
	Start-Sleep -s 10
	$out = moveFile($dirR2)
	if ($out -ne 0)
	{echo $out}
	Start-Sleep -s 10
	$out = moveFile($dirR3)
	if ($out -ne 0)
	{echo $out}
	Start-Sleep -s 10
	$out = moveFile($dirR4)
	if ($out -ne 0)
	{echo $out}
	Start-Sleep -s 10
	$out = moveFile($dirR5)
	if ($out -ne 0)
	{echo $out}
	Start-Sleep -s 10
}