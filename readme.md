
## Installation and usage via docker compose

```
  pocketbase:
    image: ghcr.io/limxingzhi/pocketbase:latest
    ports:
      - 8080:8080
    container_name: pocketbase
    volumes:
      - /volume1/docker/pocketbase_pb_data:/pb/pb_data
```

## Release source

PocketBase binaries are downloaded from
https://ganigeorgiev.com/pocketbase/pocketbase/releases (GitHub releases stop at 0.40.6).

## Reference

https://pocketbase.io/docs/going-to-production/
