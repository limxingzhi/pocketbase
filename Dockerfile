FROM alpine:latest

ARG PB_VERSION=0.41.0
ARG PB_RELEASE_ID=7vo1mkjw049veng

# RUN apk add --no-cache \
#     unzip \
#     ca-certificates

# download and unzip PocketBase
ADD https://ganigeorgiev.com/api/files/releases/${PB_RELEASE_ID}/pocketbase_${PB_VERSION}_linux_amd64.zip /tmp/pb.zip
RUN unzip /tmp/pb.zip -d /pb/

# uncomment to copy the local pb_migrations dir into the image
# COPY ./pb_migrations /pb/pb_migrations

# uncomment to copy the local pb_hooks dir into the image
# COPY ./pb_hooks /pb/pb_hooks

EXPOSE 8080

# start PocketBase
CMD ["/pb/pocketbase", "serve", "--http=0.0.0.0:8080"]
