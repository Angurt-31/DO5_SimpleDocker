#!/bin/bash

gcc hello_World.c -lfcgi -o server
service nginx start
nginx -s reload
spawn-fcgi -p 8080 -n server