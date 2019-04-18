# rabbitmq-transfert

Simple tool to transfert from one RabbitMQ to another one.

## Building

    docker build -t rq_transfert .

## Running

    docker run --name=rq_transfert --link rabbitmq:rabbitmq --link rabbitmq2:rabbitmq2 rq_transfert
