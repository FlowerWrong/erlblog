## A blog write by erlang.

#### Dependency

* [rebar 2](https://github.com/rebar/rebar)
* [ChicagoBoss master](https://github.com/ChicagoBoss/ChicagoBoss)


#### Usage

```ruby
git clone git@github.com:FlowerWrong/erlblog.git
cd erlblog
rebar -h
rebar g-d
rebar compile

# test
rebar boss c=test_functional

# dev server
./init-dev.sh
q().

# production server
./init.sh start
./init.sh stop

# hot code reload
rebar compile
init.sh reload
```
