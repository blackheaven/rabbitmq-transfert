docker build -t rq_test_dequeue -f Dockerfile-dequeue .
docker build -t rq_test_enqueue -f Dockerfile-enqueue .
docker build -t rq_transfert -f Dockerfile-transfert .

docker run -d --name=rabbitmq2 -p "15672:15672" -p "5672:5672" rabbitmq:3.7.7-management
docker rm -f rq_dequeue; docker run --name=rq_dequeue --link rabbitmq2:rabbitmq rq_test_enqueue
docker rm -f rq_transfert; docker run --name=rq_transfert --link rabbitmq:rabbitmq rq_transfert
