## Shipping package
PROTO_ROOT_DIR = $(shell brew --prefix)/Cellar/protobuf/3.6.0/include
PROJECT_NAME = hello-grpc

## Dart requires you to manually ship all google provided proto files too.
_gendart:
	@mkdir -p model/gen/ship/dart
	@protoc -I=model/protodefs --dart_out=grpc:model/gen/ship/dart model/protodefs/*.proto
	@protoc -I$(PROTO_ROOT_DIR) --dart_out=model/gen/ship/dart $(PROTO_ROOT_DIR)/google/protobuf/*.proto

_gengo:
	@mkdir -p model/gen
	@protoc -I=model/protodefs --go_out=plugins=grpc:model/gen model/protodefs/*.proto

gen: _gengo _gendart

build: get gen
	@env CGO_ENABLED=0 GOOS=linux GOARCH=386 go build -ldflags '-w -extldflags "-static"' -o build/${PROJECT_NAME}_linux_amd64 .
	@env GOARCH=amd64 go build -ldflags '-w -extldflags "-static"' -o build/${PROJECT_NAME}_macosx_amd64 .

get:
	@go get -u github.com/golang/dep/cmd/dep
	@dep ensure

install: get gen
	@cp config_template.json config.json