#!/bin/bash

check_command_exists () {
    command $1 &> /dev/null ;
}

# 1. Check if ruby has been installed in your os
if check_command_exists "ruby -v"
then
    ruby -r './order_report.rb' -e "OrderReportModule.data_report"
else
    if check_command_exists "docker -v"
    then
        read -p 'Enter the page number would you like to get / or leave blank to get default page: ' page_number

        if [[ $page_number == "" ]]
        then
            echo "You must enter a valid number, example [1, 2, 3, ...]"
            exit
        fi

        docker build -t returnly_abrahan_image .
        docker run --env PAGE=$page_number -i returnly_abrahan_image
    else
        echo "Docker is not installed"
    fi
fi