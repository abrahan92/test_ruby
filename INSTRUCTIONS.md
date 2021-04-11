# Instructions for Returnly Code Challenge

## Abrahan Mendoza

The purpose of this document is to describe how to run the Ruby script approach based on the requirements located in the README.md file.


### Instructions 📄

#### Requirements ⚙️

1. ```Unix based OS```

2. ```ruby >= 2.5.*```

3. ```Docker version >= 20.10.5 ``` (Optional)

#### Steps 🌀

1. Run ```git clone https://github.com/abrahan92/test_ruby.git``` to get the project locally.

2. Run ```cd test_ruby``` to go on the project root.

3. Run ```sudo chmod -R 777 installations.sh``` in order to add permission for run the bash script.

4. Run ```bundle install``` To install the gems on the Gemfile.

5. Run ```./installations.sh``` to run the bash script.

It is possible your bundler could be deprecated if you already have a ruby version then update it before run the 
spec task. `bundle update --bundler`

`Step 5` script will detect if user already have installed ruby on your local machine, if yes then run the ruby script, 
if not will ask if have docker installed to run a docker container with a ruby image configured to this test. 

In case you don´t have ruby and docker installed, will be more easy install Docker and then run this script again

For installation check this topic https://docs.docker.com/get-docker/

#### Run script with docker 🚀

  * Run ```./installations.sh```

After have docker installed, the above script will build the needed image for run the ruby script and will magic.

The Rspec tests will run while image building

#### Run Rspec Tests manually 🔥

  * Run ```bundle exec rake spec``` -> For this test we have 10 example scenarios

It is possible your bundler could be deprecated if you already have a ruby version then update it before run the 
spec task. `bundle update --bundler`

#### Run the script with ruby manually 💥

  * Run ```bundle install``` -> To install the gems on the Gemfile

  * Run ```ruby -r './order_report.rb' -e "OrderReportModule.data_report"``` -> Keep in mind you must have ruby installed

### Description 📋

This project try to generate a report using the SOLID principle, and best practices for this ruby script.
I tried to keep in mind all things to do a real case for this simple example, but there are more things can be improved.

The project structure have the follow topics:

* Ruby files that have the logic to solve the problem `(order_report.rb && order_interface.rb)`.
* `Gemfile` with the gems needed for the problem and spec tests.
* `Dockerfile` with the image needed to run the project if don't have ruby installed or your version break with this project.
* `Rakefile` to run the spec tasks.
* `installations.sh` is the bash script that check if you have ruby or docker and then decide to run
* `entrypoint.sh` is the bash script used for the docker image to run the ruby script on the created container.
* The specs tests are in the `spec folder`, we have 10 examples which check the structures used in this project.
* `README.md` have the test rules and instructions.

### Notes 🚩️

I have created an order interface to separete the orders API http request logic respect to the order module for simulate we send information to other microservices.

Have the instance method called `get_data` to make the request to the endpoint for this test. Simulating that interface work on a real
scenario, right now just have `GET` but we could have others http methods if needed `[POST, PUT, DELETE, PATCH]`.

There are some validations to rescue the script if some went wrong.

A class methods called `handle_error` was created for handle the errors and send
the correct response to the user in case of something wen wrong.

A private method called `get_response_status` handle the response status, with ruby `Net::HTTP` types 

### Gems used 💎

* `net/http` To make the http requests in the order_interface.rb.
* `colorize` To use happy colors on CLI for the report.
* `json` To parse the data requested on the endpoint.
* `date` To parse the string date, be able to process and calculte the interval of times.
* `uri` To parse the endpoint url used on the `get_data` method.
* `rspec` To build the test for our scenarios.
* `rake` To run the rspec task.