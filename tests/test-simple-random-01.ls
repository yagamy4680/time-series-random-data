#!/usr/bin/env lsc
#
Generator = require \../lib/generators/simple-random

const max_value = 10
const min_value = 100

g = new Generator {max_value, min_value}

for i from 1 to 10
  console.log "next-value: #{g.next!}"


