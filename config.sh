#!/bin/bash

sed -i s:{{FUNCTION_NAME}}:$FUNCTION_NAME:g ./lambda-function.tf;
