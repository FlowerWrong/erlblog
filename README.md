## A blog written in erlang.

#### Dependency

* [rebar 2](https://github.com/rebar/rebar)
* [ChicagoBoss master](https://github.com/ChicagoBoss/ChicagoBoss)
* [typescript](http://www.typescriptlang.org/)
* [bower](http://bower.io/)
* [scss](http://sass-lang.com/)
* [less](http://lesscss.org/)
* [theme](http://lessmade.com/themes/less/)
* [jquery 2](http://jquery.com/)
* [ace editor](https://github.com/ajaxorg/ace-builds)
* [jQuery-File-Upload](https://github.com/blueimp/jQuery-File-Upload)
* [marked js](https://github.com/chjj/marked)
* [Highlightjs](https://highlightjs.org)
* [jQuery-Tags-Input](https://github.com/xoxco/jQuery-Tags-Input)
* [fortawesome icons](http://fortawesome.github.io/Font-Awesome/)
* [blockUI](http://jquery.malsup.com/block)
* [react](https://github.com/facebook/react)

#### Curl test

```ruby
curl -i -X POST -d "image=/static/chicago-boss.png&title=title1&content=content1&author_id=1" 'http://127.0.0.1:8001/posts/create'

curl -i -X PUT -d "image=/static/chicago-boss.png&title=title_update1&content=contentupdate1&author_id=1" 'http://127.0.0.1:8001/posts/post-1/update'

curl -i -X GET 'http://127.0.0.1:8001/posts/post-1'

curl -i -X DELETE 'http://127.0.0.1:8001/posts/post-1/delete'

curl -i -X POST -F "image=@/home/yang/dev/erlang/erlblog/priv/static/chicago-boss.png" 'http://127.0.0.1:8001/uploader'
```

#### Usage

```ruby
git clone git@github.com:FlowerWrong/erlblog.git
cd erlblog

npm install -g bower
bower install

# Install scss, typescript lint and compile tools.
npm install -g typescript
npm install -g tslint
npm install -g less
bundle install

# Install rebar, following up link.
rebar -h
rebar g-d
rebar compile

# test
rebar boss c=test_functional
rebar boss c=test_eunit

# dev server
make
q().

# production server
./init.sh start
./init.sh stop

# hot code reload
rebar compile
init.sh reload
```

### Deploy

* [See chicagoboss deploy wiki with nginx](https://github.com/ChicagoBoss/ChicagoBoss/wiki/Deploy)

### Todo

- [ ] Use react to rewrite tags input
- [ ] Fix blockUI with location.href not work
- [ ] Add created_at and updated_at datetime column name
- [x] Markdown compile in erlang