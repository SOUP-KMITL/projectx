# Project X
Weekly plan and other information can be found in the Wiki page: [Here](https://github.com/deoxen0n2/projectx/wiki)

# XScanner
Now it is able to scan single-node target. Multi-node target will come after setting up the next test environment.

## How to test
1. Start Neo4j server at port `7474`  
2. For simple testing for `NmapAdapter`, edit (configure target) and run `ruby scripts/nmap_adapter_test_launch.rb`  
3. Run XScanner (RESTful service), run `ruby xscanner/xscanner.rb`  
4. To test XScanner, issue `POST /sessions` with `target=[yourtarget_ip]` body such as `target=192.168.12.34`  
5. To view results, check at `localhost:7474` with your browser  

> For all this to work, make sure to run `bundle install` with any Gemfile in the project before starting anything.
