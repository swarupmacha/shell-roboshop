#!/bin/bash 
sg_id="sg-0fdf910f0d7d847cc"
ami_id="ami-0055977a6e828a4f4"

for instance in $@
do 
    instance_id=$(aws ec2 run-instances \
    --image-id "$ami_id" \
    --count 1 \
    --instance-type t3.micro \
    --security-group-ids "$sg_id" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text )

    if [ $instance == "frontend" ]; then 
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PublicIpAddress' \
            --output text
        )

    else 
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PrivateIpAddress' \
            --output text
        )
    fi
    echo "IP Address:  $IP"
done
