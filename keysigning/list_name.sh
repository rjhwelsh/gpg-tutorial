#!/bin/bash

gpg -k $1 |grep uid |head -n 1 |./extract_name.pl
