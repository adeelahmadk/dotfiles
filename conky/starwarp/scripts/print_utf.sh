#!/usr/bin/env bash

echo "بسم الله الرحمن الرحيم" | awk '{ for(i = length; i!=0; i--)
x = x substr($0, i, 1); }END
{print x}'
