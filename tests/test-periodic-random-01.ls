#!/usr/bin/env lsc
#
Generator = require \../lib/generators/periodic-random

const max_value = 300
const min_value = 100
const delta = 10
const increase_ratio = 0.7

g = new Generator {max_value, min_value, delta, increase_ratio}

for i from 1 to 50
  console.log "next-value: #{g.next!}"


