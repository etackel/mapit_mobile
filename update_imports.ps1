# PowerShell script to update import statements

$rootDir = "D:\mapit\lib\src"

# Define mapping of old paths to new paths
$importMappings = @{
    "import 'package:mapit/src/models/" = "import 'package:mapit/src/domain/entities/";
    "import 'package:mapit/src/provider/" = "import 'package:mapit/src/presentation/providers/";
    "import 'package:mapit/src/views/" = "import 'package:mapit/src/presentation/pages/";
    "import 'package:mapit/src/services/" = "import 'package:mapit/src/shared/services/";
    "import 'package:mapit/src/constants/" = "import 'package:mapit/src/core/constants/";
    "import 'package:mapit/src/utils/" = "import 'package:mapit/src/core/utils/";
    "import '../models/" = "import '../domain/entities/";
    "import '../provider/" = "import '../presentation/providers/";
    "import '../views/" = "import '../presentation/pages/";
    "import '../services/" = "import '../shared/services/";
    "import '../constants/" = "import '../core/constants/";
    "import '../utils/" = "import '../core/utils/";
}

# Function to update imports in a file
function Update-Imports($file) {
    $content = Get-Content $file -Raw
    $changed = $false

    foreach ($oldPath in $importMappings.Keys) {
        $newPath = $importMappings[$oldPath]
        if ($content -match [regex]::Escape($oldPath)) {
            $content = $content -replace [regex]::Escape($oldPath), $newPath
            $changed = $true
        }
    }

    if ($changed) {
        Set-Content -Path $file -Value $content
        Write-Host "Updated imports in $file"
    }
}

# Recursively find and update .dart files
Get-ChildItem -Path $rootDir -Recurse -Include *.dart | ForEach-Object {
    Update-Imports $_.FullName
}
