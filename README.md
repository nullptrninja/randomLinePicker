# randomLinePicker
Reads a text file and picks a random line from it.

### Usage
1. Open Powershell
2. CD to script location
3. Run `.\pickFromFile.ps1 -file sampleInput.txt -pick 3`

### Sample Output
```
.\pickFromFile.ps1 -file .\sampleInput.txt -pick 3
Using Seed: 1400666232
Picking 3 out of 11
Pick #1 -> Name8
Pick #2 -> Name10
Pick #3 -> Name2
Finished in 4 iterations
```

### Auditing Results
You can audit the results to ensure the inputs and outputs match by adding the `auditSeed` parameter. Using the above example, the auditing command would look like this:  
```
.\pickFromFile.ps1 -file .\sampleInput.txt -pick 3 -auditSeed 1400666232
Using Seed: 1400666232
Picking 3 out of 11
Pick #1 -> Name8
Pick #2 -> Name10
Pick #3 -> Name2
Finished in 4 iterations
```

#### Why not Get-Random -Count?
Good question, Get-Random with `InputObject` and `Count` does almost exactly what we needed with the exception of data weights. We wanted to allow some data points to have a greater chance of being picked than others and in this implementation we do so by simply repeating that data line some amount of times. `Get-Random` does not have this capability and we didn't want to introduce some arbitrary index-to-string mapping nonsense as well as de-duping code on top of that.
