#! /bin/bash

find $PWD -name '*.[ch]' > ./cscope.files
cscope -b
