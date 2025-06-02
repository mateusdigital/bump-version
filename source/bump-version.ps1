##----------------------------------------------------------------------------##
##                               *       +                                    ##
##                         '                  |                               ##
##                     ()    .-.,="``"=.    - o -                             ##
##                           '=/_       \     |                               ##
##                        *   |  '=._    |                                    ##
##                             \     `=./`,        '                          ##
##                          .   '=.__.=' `='      *                           ##
##                 +                         +                                ##
##                      O      *        '       .                             ##
##                                                                            ##
##  File      : bump-version.ps1                                              ##
##  Project   : doom_fire                                                     ##
##  Date      : 2025-05-14                                                    ##
##  License   : See project's COPYING.TXT for full info.                      ##
##  Author    : mateus.digital <hello@mateus.digital>                         ##
##  Copyright : mateus.digital - 2025                                         ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##----------------------------------------------------------------------------##

## -----------------------------------------------------------------------------
param (
  [object]$Path = "package.json",
  [switch]$BumpMajor,
  [switch]$BumpMinor,
  [switch]$BumpPatch,
  [switch]$BumpBuild,
  [switch]$ShowVersion,
  [switch]$ShowVersionFull,
  [switch]$ShowMajor,
  [switch]$ShowMinor,
  [switch]$ShowPatch,
  [switch]$ShowBuild,
  [switch]$Version,
  [switch]$Help,
  [switch]$Update
)

## -----------------------------------------------------------------------------
$PROGRAM_VERSION = "0.0.0.0";
$PROGRAM_NAME    = "bump-version";



##
## Help And Version
##

## -----------------------------------------------------------------------------
if ($PSBoundParameters.ContainsKey("Help")) {
  Write-Output "Usage: bump-version.ps1 [options]";
  Write-Output "Options:";
  Write-Output "  -Help                   Show this help message";
  Write-Output "  -Version                Show copyright and version information";
  Write-Output "  -Update                 Auto Update the script...";
  Write-Output "";
  Write-Output "  -Path <path>            Path to the package.json file (default: package.json)";
  Write-Output "";
  Write-Output "  -BumpMajor <number>     Major version number";
  Write-Output "  -BumpMinor <number>     Minor version number";
  Write-Output "  -BumpPatch <number>     Patch version number";
  Write-Output "  -BumpBuild <number>     Build version number";
  Write-Output "";
  Write-Output "  -ShowVersion            Show the current version";
  Write-Output "  -ShowVersionFull        Show the full version (including build number)";
  Write-Output "  -ShowMajor              Show the major version";
  Write-Output "  -ShowMinor              Show the minor version";
  Write-Output "  -ShowPatch              Show the patch version";
  Write-Output "  -ShowBuild              Show the build number";
  exit;
}

## -----------------------------------------------------------------------------
if ($PSBoundParameters.ContainsKey("Version")) {
  "${PROGRAM_NAME} - ${PROGRAM_VERSION}- mateus.digital <hello@mateus.digital>"
  "Copyright (c) 2025 - mateus.digital"
  "This is a free software (GPLv3) - Share/Hack it"
  "Check http://mateus.digital for more :)"
  exit;
}

##
## Update Script
##

## -----------------------------------------------------------------------------
if($PSBoundParameters.ContainsKey("Update")) {
  $script_path = $MyInvocation.MyCommand.Path;
  $script_dir  = Split-Path $script_path -Parent;
  $script_name = Split-Path $script_path -Leaf;

  Write-Output "Updating script...";
  try {
    $script_content = Invoke-RestMethod https://api.github.com/repos/mateusdigital/doom-fire/tags;
    $latest_version = $script_content[0].name;

    $v1 = [version]${PROGRAM_VERSION};
    $v2 = [version]${latest_version};

    if($v1 -ge $v2) {
      Write-Output "You already have the latest version: $latest_version";
      exit;
    }

    Write-Output "Downloading latest version: $latest_version";
    $script_url = "https://raw.githubusercontent.com/mateusdigital/doom-fire/${latest_version}/source/bump-version.ps1";
    $script_content = Invoke-RestMethod -Uri $script_url -UseBasicParsing;
    $script_path = Join-Path $script_dir "$script_name ($latest_version).ps1";

    Set-Content -Path $script_path -Value $script_content -Encoding UTF8;
    Write-Output "Script updated successfully to version: $latest_version";
  } catch {
    Write-Error "Failed to download the script: $_";
    exit 1;
  }

  exit;
}



##
## Resolve path and read file
##

## -----------------------------------------------------------------------------
if ((Test-Path $Path) -and (Get-Item $Path).PSIsContainer) {
  $Path = (Join-Path $Path "package.json");
}

if (-not (Test-Path $Path)) {
  Write-Error "File not found: $Path";
  exit 1
}

$json          = (Get-Content $Path | ConvertFrom-Json);
$version_parts = ($json.version -split '\.').ForEach({ [int]$_ });
$build_number  = [int]$json.build;


##
## Show Arguments
##

## -----------------------------------------------------------------------------
if ($ShowVersion) {
  Write-Output "$($version_parts[0]).$($version_parts[1]).$($version_parts[2])";
  exit;
}
if ($ShowVersionFull) {
  Write-Output "$($version_parts[0]).$($version_parts[1]).$($version_parts[2]).$build_number";
  exit;
}

if ($ShowMajor) { Write-Output $version_parts[0]; exit; }
if ($ShowMinor) { Write-Output $version_parts[1]; exit; }
if ($ShowPatch) { Write-Output $version_parts[2]; exit; }
if ($ShowBuild) { Write-Output $build_number;     exit; }


##
## Bump Arguments
##

## -----------------------------------------------------------------------------
if ($PSBoundParameters.ContainsKey("BumpMajor")) {
  $version_parts[0] += 1;
  $version_parts[1]  = 0;
  $version_parts[2]  = 0;
}
elseif ($PSBoundParameters.ContainsKey("BumpMinor")) {
  $version_parts[1] += 1;
  $version_parts[2]  = 0;
}
elseif ($PSBoundParameters.ContainsKey("BumpPatch")) {
  $version_parts[2] = +1;
}
elseif ($PSBoundParameters.ContainsKey("BumpBuild")) {
  $build_number += 1;
}

# Save
$json.version = "$($version_parts -join '.')";
if ($json.PSObject.Properties['build'] -ne $null) {
  $json.build = $build_number;
}

$json | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 $Path;

# Output
$json.version;
