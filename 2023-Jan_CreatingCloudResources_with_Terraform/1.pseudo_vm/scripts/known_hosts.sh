#!/bin/bash

ssh-keygen  -f ~/.ssh/known_hosts -R "[127.0.0.1]:2222"
ssh-keyscan -t rsa -p 2222           "127.0.0.1" >> ~/.ssh/known_hosts
#ssh-keyscan -t rsa                  "[127.0.0.1]:2222" >> ~/.ssh/known_hosts


