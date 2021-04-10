#!/bin/bash

echo "\n Loading..."
ruby -r './order_report.rb' -e "OrderReportModule.data_report" $PAGE