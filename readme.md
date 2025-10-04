
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

## Reference

https://pocketbase.io/docs/going-to-production/
