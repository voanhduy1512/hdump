# hdump

A simple web server which captures all requests send to it for debugging

## Features

1. Capture all http requests to it for debugging
2. Show all captured requests, by requesting to `/admin`

## Building

1. Get [stack](https://docs.haskellstack.org/en/stable/README/#how-to-install)
2. 
```bash
cd hdump
stack setup
stack install
```

## Running

```bash
hdump -p 4000 HDUMP_PORT=5000 hdump
```

Port can be customized by `-p` or environment variable `HDUMP_PORT`. In case
both are define, environment variable will be used

## Todo
- Customize show url
- Add a persistant storage, right now all requests store in memory
