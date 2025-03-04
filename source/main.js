#!/usr/bin/env node
//----------------------------------------------------------------------------//
//                               *       +                                    //
//                         '                  |                               //
//                     ()    .-.,="``"=.    - o -                             //
//                           '=/_       \     |                               //
//                        *   |  '=._    |                                    //
//                             \     `=./`,        '                          //
//                          .   '=.__.=' `='      *                           //
//                 +                         +                                //
//                      O      *        '       .                             //
//                                                                            //
//  File      : main.js                                                       //
//  Project   : bump-version                                                  //
//  Date      : 2025-03-04                                                    //
//  License   : See project's COPYING.TXT for full info.                      //
//  Author    : mateus.digital <hello@mateus.digital>                         //
//  Copyright : mateus.digital - 2025                                         //
//                                                                            //
//  Description :                                                             //
//                                                                            //
//----------------------------------------------------------------------------//

// -----------------------------------------------------------------------------
const fs          = require('fs');
const path        = require('path');
const yargs       = require('yargs');
const packageJson = require('../package.json');

// -----------------------------------------------------------------------------
const argv = yargs //
               .version(false)
               .help(false)
               .option('help', {
                 alias : 'h',
                 type : 'boolean',
               })
               .option('version', {
                 alias : 'v',
                 type : 'boolean',
               })

               .option('major', {
                 type : 'number',
               })
               .option('minor', {
                 type : 'number',
               })
               .option('patch', {
                 type : 'number',
               })
               .option('build', {
                 type : 'number',
               })
               .argv;

// -----------------------------------------------------------------------------
if (argv.help) {
  const cl   = console.log;
  const name = path.basename(packageJson.name);

  cl("Usage:");
  cl(`  ${name} -h | -v`);
  cl(`  ${name} --major | --minor | --patch | --build [value]`);
  cl(`  ${name} [path]`);
  cl(``);
  cl(`Options:`);
  cl(`  *-h --help     : Show this screen.`);
  cl(`  *-v --version  : Show app version and copyright.`);
  cl(``);
  cl(`  --major [value]: Increment or set major version number.`);
  cl(`  --minor [value]: Increment or set minor version number.`);
  cl(`  --patch [value]: Increment or set patch version number.`);
  cl(`  --build [value]: Increment or set patch version number.`);
  cl(``);
  cl(`Notes:`);
  cl(`  If [path] is blank the current ./package.json is assumed.`);
  cl(`  If [path] is directory the current [path]/package.json is assumed.`);
  cl(``);
  cl(`  Options marked with * are exclusive, i.e. the ${name} will run that`);
  cl(`  and exit after the operation.`);

  process.exit(0);
}

// -----------------------------------------------------------------------------
if (argv.version) {
  const prog_name = path.basename(packageJson.name);
  const version   = packageJson.version;

  const cl = console.log;
  cl(`${prog_name} - ${version} - mateus.digital <hello@mateus.digital>`);
  cl('Copyright (c) 2025 - mateus.digital');
  cl('This is a free software (GPLv3) - Share/Hack it');
  cl('Check http://mateus.digital for more :)');

  process.exit(0);
}

// -----------------------------------------------------------------------------
let filename = argv._[0] || "package.json";

// -----------------------------------------------------------------------------
let filepath = path.resolve(filename);
if (!fs.existsSync(filepath)) {
  console.error(`File not found: ${filename}`);
  process.exit(1);
}

if (fs.statSync(filepath).isDirectory()) {
  filepath = path.join(filename, "package.json");
}

console.log(`Reading file: ${filepath}`);
const contents = fs.readFileSync(filepath);
const json     = JSON.parse(contents);
const version  = json.version || '0.0.0';
const build    = json.build || 0;

// -----------------------------------------------------------------------------
console.log(`Current version: ${version}`);
console.log(`Current build: ${build}`);
let version_parts = version.split('.');
let version_build = build;

// -----------------------------------------------------------------------------
function _HasKey(obj, targetKey)
{
  for (let key of Object.keys(argv)) {
    if (key != targetKey) {
      continue;
    }

    return true;
  }

  return false;
}

// -----------------------------------------------------------------------------
if (_HasKey(argv, "major")) {

  version_parts[0] =
    (argv.major !== undefined) ? argv.major : parseInt(version_parts[0], 10) + 1;

  version_parts[1] = 0;
  version_parts[2] = 0;
}

// -----------------------------------------------------------------------------
if (_HasKey(argv, "minor")) {

  version_parts[1] =
    (argv.minor !== undefined) ? argv.minor : parseInt(version_parts[1], 10) + 1;

  version_parts[2] = 0;
}

// -----------------------------------------------------------------------------
if (_HasKey(argv, "patch")) {
  version_parts[2] =
    (argv.patch !== undefined) ? argv.patch : parseInt(version_parts[2], 10) + 1;
}

// -----------------------------------------------------------------------------
if (_HasKey(argv, "build")) {
  version_build = (argv.build !== undefined) ? argv.build : (version_build + 1);
}

// -----------------------------------------------------------------------------
json.version = version_parts.join('.');
json.build   = version_build;

// -----------------------------------------------------------------------------
console.log(`New version: ${json.version}`);
console.log(`New build: ${json.build}`);

const str = JSON.stringify(json, null, " ");
fs.writeFileSync(filepath, str);
