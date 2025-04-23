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
##  File      : install.ps1                                                   ##
##  Project   : bump-version                                                  ##
##  Date      : 2025-04-23                                                    ##
##  License   : See project's COPYING.TXT for full info.                      ##
##  Author    : mateus.digital <hello@mateus.digital>                         ##
##  Copyright : mateus.digital - 2025                                         ##
##                                                                            ##
##  Description :                                                             ##
##                                                                            ##
##----------------------------------------------------------------------------##

## -----------------------------------------------------------------------------
$PROGRAM_NAME = "bump-version";
$INSTALL_ROOT = "${HOME}/.mateusdigital/bin";
$INSTALL_DIR  = "${INSTALL_ROOT}";


## -----------------------------------------------------------------------------
Write-Output "==> Installing ${PROGRAM_NAME}...";

## -----------------------------------------------------------------------------
New-Item -Path "${INSTALL_DIR}" -ItemType Directory -Force | Out-Null;
npm run build;

Copy-Item "./dist/bump-version-win.exe" "${INSTALL_DIR}/${PROGRAM_NAME}.exe" -Force;

Write-Output "$PROGRAM_NAME was installed at:";
Write-Output "    $INSTALL_ROOT";
Write-Output "You might need add it to the PATH";

Write-Output "Done... ;D";
Write-Output "";
