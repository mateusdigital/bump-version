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
##  File      : generate-release-zip.ps1                                      ##
##  Project   : bump-version                                                  ##
##  Date      : 2025-06-02                                                    ##
##  License   : See project's COPYING.TXT for full info.                      ##
##  Author    : mateus.digital <hello@mateus.digital>                         ##
##  Copyright : mateus.digital - 2025                                         ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##----------------------------------------------------------------------------##

$ErrorActionPreference = "Stop";

##
## Constants
##

## -----------------------------------------------------------------------------
$SCRIPT_DIR    = Split-Path -Parent $MyInvocation.MyCommand.Definition;
$ROOT_DIR      = Split-Path -Parent $SCRIPT_DIR;
$BUILD_DIR     = "$ROOT_DIR/_build";
$DIST_DIR      = "$ROOT_DIR/_dist";

$PACKAGE_JSON    = (Get-Content "${ROOT_DIR}/package.json" -Raw) | ConvertFrom-Json;
$PROJECT_NAME    = $PACKAGE_JSON.name;
$PROJECT_VERSION = $PACKAGE_JSON.version;

$FULL_PROJECT_NAME = "${PROJECT_NAME}-${PROJECT_VERSION}";

## -----------------------------------------------------------------------------
foreach ($item in $(Get-ChildItem "${BUILD_DIR}/*")) {
  $build_name            = $item.BaseName;
  $build_name_components = $build_name.Split("-");
  $build_platform        = $build_name_components[0];
  $build_mode            = $build_name_components[1];

  $output_name = "${FULL_PROJECT_NAME}-${build_platform}";
  $output_dir  = "${DIST_DIR}/${output_name}";

  Write-Host "==> Build directory:  $item";
  Write-Host "==> Output directory: $output_dir";

  New-Item -Path ${output_dir} -ItemType Directory -Force;
  ## Copy the build files.
  Copy-Item -Path $item/* -Destination $output_dir/
  ## Copy resource files.
  Copy-Item -Path "resources/readme-release.txt" -Destination $output_dir;

  ## Make the zip
  $zip_fullpath = "${output_dir}.zip";

  Compress-Archive                    `
    -Path            "$output_dir"    `
    -DestinationPath "$zip_fullpath"  `
    -Force;
}
