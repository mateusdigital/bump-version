$ErrorActionPreference = "Stop"

##
## Constants
##

## -----------------------------------------------------------------------------
$SCRIPT_DIR    = Split-Path -Parent $MyInvocation.MyCommand.Definition;
$ROOT_DIR      = Split-Path -Parent $SCRIPT_DIR;
$SOURCE_DIR    = "$ROOT_DIR/source";
$BUILD_DIR     = "$ROOT_DIR/_build";

$PACKAGE_JSON    = (Get-Content "${ROOT_DIR}/package.json" -Raw) | ConvertFrom-Json;
$PROJECT_NAME    = $PACKAGE_JSON.name;
$PROJECT_VERSION = $PACKAGE_JSON.version + "." + $PACKAGE_JSON.build;

## Detect platform
if     ($IsWindows) { $BUILD_PLATFORM = "windows" }
elseif ($IsLinux)   { $BUILD_PLATFORM = "linux" }
elseif ($IsMacOS)   { $BUILD_PLATFORM = "macos" }
else { throw "Unsupported platform" }

$BUILD_MODE = "release"; # Default build mode
if ($PSBoundParameters.ContainsKey("Debug")) {
  $BUILD_MODE = "debug";
}

##
## Build
##

## -----------------------------------------------------------------------------
$FULL_BUILD_DIR = "${BUILD_DIR}/${BUILD_PLATFORM}-${BUILD_MODE}";
New-Item -ItemType Directory -Force -Path "${FULL_BUILD_DIR}" | Out-Null;

##
(Get-Content -Path "${SOURCE_DIR}/${PROJECT_NAME}.ps1") `
  -replace "0.0.0.0", $PROJECT_VERSION | `
  Set-Content -Path "${FULL_BUILD_DIR}/${PROJECT_NAME}.ps1" -Encoding UTF8;