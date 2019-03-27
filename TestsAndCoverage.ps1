$testProjects = "XUnitTest", "XUnitTest.Integration"

# Get the most recent OpenCover NuGet package from the dotnet nuget packages
$nugetOpenCoverPackage = Join-Path -Path $env:C:\Users\scafe -ChildPath "\.nuget\packages\opencover\4.7.922"
$latestOpenCover = Join-Path -Path ((Get-ChildItem -Path $nugetOpenCoverPackage | Sort-Object Fullname -Descending)[0].FullName) -ChildPath "tools\OpenCover.Console.exe"
# Get the most recent OpenCoverToCoberturaConverter from the dotnet nuget packages
$nugetCoberturaConverterPackage = Join-Path -Path $env:C:\Users\scafe -ChildPath "\.nuget\packages\OpenCoverToCoberturaConverter"
$latestCoberturaConverter = Join-Path -Path (Get-ChildItem -Path $nugetCoberturaConverterPackage | Sort-Object Fullname -Descending)[0].FullName -ChildPath "tools\OpenCoverToCoberturaConverter.exe"

If (Test-Path "$PSScriptRoot\RazorPagesMovie\$testProject\OpenCover.coverageresults"){
	Remove-Item "$PSScriptRoot\RazorPagesMovie\$testProject\OpenCover.coverageresults"
}

If (Test-Path "$PSScriptRoot\RazorPagesMovie\$testProject\Cobertura.coverageresults"){
	Remove-Item "$PSScriptRoot\RazorPagesMovie\$testProject\Cobertura.coverageresults"
}

& dotnet restore

$testRuns = 1;
foreach ($testProject in $testProjects){
    # Arguments for running dotnet
    $dotnetArguments = "xunit", "-xml `"`"$PSScriptRoot\RazorPagesMovie\$testProject\testRuns_$testRuns.testresults`"`""

    "Running tests with OpenCover"
    & $latestOpenCover `
        -register:user `
        -target:dotnet.exe `
        -targetdir:$PSScriptRoot\RazorPagesMovie\$testProject `
        "-targetargs:$dotnetArguments" `
        -returntargetcode `
        -output:"$PSScriptRoot\RazorPagesMovie\$testProject\OpenCover.coverageresults" `
        -mergeoutput `
        -oldStyle `
        -excludebyattribute:System.CodeDom.Compiler.GeneratedCodeAttribute `
        "-filter:+[Sample*]* -[*.Tests]* -[*.Tests.*]*"

        $testRuns++
}

"Converting coverage reports to Cobertura format"
& $latestCoberturaConverter `
    -input:"$PSScriptRoot\RazorPagesMovie\$testProject\OpenCover.coverageresults" `
    -output:"$PSScriptRoot\RazorPagesMovie\$testProject\Cobertura.coverageresults" `
    "-sources:$PSScriptRoot"