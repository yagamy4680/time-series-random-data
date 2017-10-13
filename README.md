# time-series-random-data
Generate time-series random data for experiments.


## Examples

Run data generator with config `test1.yaml`, and output to appender `console`

```text
./app.ls -v \
    -c ./config/test1.yml \
    -m node:F99900001,gid:0001 \
    -p future
```

Run data generator with config `test2.yaml`, and output to appender `ifdb130` (for influxdb v1.3) on localhost:

```text
./app.ls -v \
    -c ./config/test2.yml \
    -m node:F99900001,gid:0001 \
    -p future \
    -a "ifdb130 http://localhost:8086 root root mydb"
```