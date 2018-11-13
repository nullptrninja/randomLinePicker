param(
    [string]$file = $null,
    [int]$pick = 3,
    
    # auditSeed is optional and is only used for results reproduction
    [int]$auditSeed = 0
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

$seed = $auditSeed;
if ($auditSeed -eq 0) {
    $utcNow = [System.DateTime]::UtcNow;

    # We want the seed to be shifting every second or so, otherwise if we picked TotalHours we would've
    # been stuck with the same seed value for an hour during testing.
    $seed = [int]([System.TimeSpan]::FromTicks($utcNow.Ticks).TotalSeconds % [Int32]::MaxValue);
}

write-host "Using Seed: $seed";
write-host "Picking $actualPick out of $($lines.Length)";

if ($lines.Length -lt $pick) {
    write-host "There were less lines in the file than you picked, showing all lines...";
    $actualPick = $lines.Length;
}

# Tracks names that have already been picked
$alreadyPicked = new-object System.Collections.Generic.HashSet[string];

# Ordinal counter
$i = 0;

# Iteration counter
$j = 0;

# Note: most of this could've been done with Get-Random -InputObject -Count however
# we needed the ability to weight the data and the extra code to prevent dupes would've
# just as wordy as this block.

while ($i -lt $actualPick) {
    # Note, advance the seed arbitrarily to avoid infinite loop
    $index = get-random -Minimum 0 -Maximum $lines.Length -SetSeed ($seed + $j)
    $pickedName = $lines[$index];

    if ($alreadyPicked.Contains($pickedName) -eq $false) {
        write-host "Pick #$($i + 1) -> $pickedName"

        # Suppress the return value
        $derp = $alreadyPicked.Add($pickedName);
        $i++;
    }
    $j++;    
}
write-host "Finished in $j iterations";