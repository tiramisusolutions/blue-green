# Blue-Green

 A bash script for Docker based blue/green deployments.

## Function

- Check version,port and color [blue of green] of currently running ct.
- Pull new version of ct
- Start new ct on other defined color and port
- Transfer open connection to new ct
- Kill and rm old ct

## Calling

Something like:
```
deploy $CONTAINERNAME:$VERSION
```

This should:

- Get build versions from current and new Images
- Check if we have already a CT-Image with the name and Tag on the server

    -> check if it is on blue or green, running

    -> if not pull new Image and run it on the port which is not in use [blue or green]

    -> shutdown old image

## Notes:

The Vars: $BUILD_VERSION and the TAG of the image should be always the same


