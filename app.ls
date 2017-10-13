#!/usr/bin/env lsc
#
require! <[yargs colors fs prettyjson moment]>
yaml = require \js-yaml
Runner = require \./lib/runner


ERROR_EXIT = (code, message) ->
  console.error message
  process.exit code


PRINT_CONFIG = (config, doc) ->
  console.log config.green
  text = prettyjson.render doc, keysColor: \gray, dashColor: \green, stringColor: \yellow, numberColor: \cyan, inlineArrays: 1, defaultIndentation: 4
  xs = text.split '\n'
  [ console.log "\t#{x}" for x in xs ]


PARSE_PAST_STRING = (past) ->
  exp1 = /^[0-9]*[y|Q|M|w|d|h|m]$/
  exp2 = /^[0-9]*/
  return ["invalid past string: #{past}"] unless exp1.test past
  m = past.match exp2
  number = parse-int m[0]
  string = past.substr m[0].length
  return [null, number, string]


INITIALIATE_APPENDER = (string) ->
  yargs.reset!
  xs = string.split ' '
  clazz = xs.shift!
  return (new (require \./lib/appenders/console)).init xs if clazz is \console
  return ERROR_EXIT 2, "no such appender: #{clazz}"


RUN_WITHOUT_TIMER = (runners, appender, past) ->
  [parse-err, number, string] = PARSE_PAST_STRING past
  return ERROR_EXIT 1, parse-err if parse-err?
  start = moment!
  now = moment start
  start = start.subtract number, string
  console.log "starting from #{(start.format 'MM/DD HH:mm:ss').cyan} (past #{past.yellow})"
  time = start.value-of!
  end = now.value-of!
  console.log "starting from #{time}, and ends at #{end}ms"
  do
    x = moment time
    for r in runners
      xs = r.at-next-second new Date time
      appender.append xs if xs?
    time = time + 1001ms
  while time < end


RUN_WITH_TIMER = (runners, appender) ->
  f = ->
    for r in runners
      xs = r.at-next-second new Date!
      appender.append xs if xs?
  setInterval f, 1000ms




{config, verbose, past, metadata} = argv = yargs
  .option \config  , alias: \c, describe: "the yaml config"
  .option \verbose , alias: \v, describe: "enable verbose outputs", default: no
  .option \past    , alias: \p, describe: "the starting time from the past, e.g. 10m, 1h, 2d, 5w, or future", default: \3m
  .option \metadata, alias: \m, describe: "extra metadata, e.g. node:F00010002,gid:010", default: \node:F00010002
  .option \appender, alias: \a, describe: "the appender (and its options) to serialize generated data points, e.g. 'console stdout'", default: 'console stdout'
  .version no
  .demandOption <[config]>
  .help!
  .argv

doc = yaml.safe-load fs.read-file-sync config
PRINT_CONFIG config, doc if verbose

xs = metadata.split ','
xs = [ (x.split ':') for x in xs ]
xs = { [x[0],x[1]] for x in xs }
console.log "metadata => #{JSON.stringify xs}"
runners = [ new Runner c, xs for c in doc.collections ]

appender = INITIALIATE_APPENDER argv.appender

return RUN_WITH_TIMER runners, appender if past is \future
return RUN_WITHOUT_TIMER runners, appender, past