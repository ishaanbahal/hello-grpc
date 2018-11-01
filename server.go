package main

import (
	"context"
	"log"
	"net"

	"github.com/golang/protobuf/ptypes/empty"
	model "github.com/ishaanbahal/hello-grpc/model/gen"
	"google.golang.org/grpc"
)

func main() {
	path := "0.0.0.0:3000"
	lis, err := net.Listen("tcp", path)
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	log.Printf("Listening on %s", path)
	grpcServer := grpc.NewServer()
	model.RegisterHelloServiceServer(grpcServer, newHelloSever())
	grpcServer.Serve(lis)
}

func newHelloSever() *helloServiceServer {
	log.Printf("Registered helloServiceServer handler")
	return &helloServiceServer{}
}

// HelloService handler
type helloServiceServer struct{}

func (s *helloServiceServer) SayHello(ctx context.Context, req *empty.Empty) (*model.ResponseHello, error) {
	return &model.ResponseHello{Response: "Hello you!"}, nil
}
