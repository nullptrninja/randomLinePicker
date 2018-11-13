param(
    [string]$file = $null,
    [int]$pick = 3
)

if ($file -eq $null -or $pick -le 0) {
    write-host "Bad params";
    exit;
}

if ((test-path $file) -eq $false) {
    write-host "Can't find file $file";
    exit;
}

$fullPath = $(Get-ItemProperty -Path $file).FullName;
$lines = [System.IO.File]::ReadAllLines($fullPath);
$actualPick = $pick;

if ($lines.Length -lt $pick) {
    write-host "There were less lines in the file than you picked, showing all lines...";
    $actualPick = $lines.Length;
}

$alreadyPicked = new-object System.Collections.Generic.HashSet[string];
$i = 1;

while ($i -le $actualPick) {
    $index = get-random -Minimum 0 -Maximum $lines.Length
    $pickedName = $lines[$index];

    if ($alreadyPicked.Contains($pickedName) -eq $false) {
        write-host "Pick #$i -> $pickedName"

        # Suppress the return value
        $derp = $alreadyPicked.Add($pickedName);
        $i++;
    }    
}