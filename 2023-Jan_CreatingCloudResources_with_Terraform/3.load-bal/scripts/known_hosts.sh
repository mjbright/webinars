#!/bin/bash

for port in 2222 2223 2224; do
    ssh-keygen  -f ~/.ssh/known_hosts -R "[127.0.0.1]:$port"
    ssh-keyscan -t rsa -p $port          "127.0.0.1" >> ~/.ssh/known_hosts
done
#ssh-keyscan -t rsa                  "[127.0.0.1]:2222" >> ~/.ssh/known_hosts


