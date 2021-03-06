#!/bin/bash

check_command_exists () {
    command $1 &> /dev/null ;
}

run_with_docker () {
    printf "\n\e[33m"
    read -p "Enter the page number you would like to get / or leave blank to get default page: " page_number

    if [[ $page_number == "" ]]
    then
        echo "You must enter a valid number, example [1, 2, 3, ...]"
        exit
    fi

    printf "\n\e[32mBuilding the ruby image, please wait... \n\n\e[34m"
    docker build -t returnly_abrahan_image .
    docker run --env PAGE=$page_number -i returnly_abrahan_image
}

returnly_title () {
    printf "\e[36m
####################################################################################################
####################### / __ \/ ____/_  __/ / / / __ \/ | / / /\ \/ / ##############################
###################### / /_/ / __/   / / / / / / /_/ /  |/ / /  \  / ###############################
##################### / _, _/ /___  / / / /_/ / _, _/ /|  / /___/ / ################################
#################### /_/ |_/_____/ /_/  \____/_/ |_/_/ |_/_____/_/ #################################
#################################################################################################### \n\n"
}

if check_command_exists "ruby -v" && check_command_exists "docker -v"
then
    # 1. Check if ruby and docker are installed on your os
    printf "\n\e[33m"
    read -p 'You have installed Docker and Ruby, which one would you like to use? [ruby/docker]: ' software
    printf "\n"
    if [[ ($software == "ruby" || $software == "Ruby") ]]
    then
        returnly_title
        ruby -r './order_report.rb' -e "OrderReportModule.data_report"
    else
        run_with_docker
    fi
elif check_command_exists "ruby -v"
then
    returnly_title
    ruby -r './order_report.rb' -e "OrderReportModule.data_report"
else
    # 2. Check if docker has been installed in your os
    if check_command_exists "docker -v"
    then
        run_with_docker
    else
        echo "Docker is not installed"
    fi
fi