# fluent-plugin-curl

Fluentd output plugin to any request using curl

## Installation

Install gem

````
fluent-gem install fluent-plugin-curl
````

## config

````ruby
    config_param :curl_command, :string, :default => 'curl'
    config_param :url_template, :string
    config_param :options_template, :string
    config_param :body_template, :string, :default => ''
````

### example1

````
<store>
  type curl
  curl_command /usr/bin/curl
  url_template  http://example/url/<%= ERB::Util.url_encode(record['field1']) %>
  options_template -d 'body=<%= ERB::Util.url_encode(record['field2']) %>'
</store>
````

For messages such as: {"field1":300, "field2":20, "field3diff":-30}

execute `/usr/bin/curl http://example/url/300 -d 'body=20`

### example2

````
<store>
  type curl
  curl_command /usr/bin/curl
  url_template  http://example/url/<%= ERB::Util.url_encode(record['field1']) %>
  options_template --data-urlencode @-
  body_template body=<%= ERB::Util.url_encode(record['field2']) %>
</store>
````

For messages such as: {"field1":300, "field2":20, "field3diff":-30}

execute `/usr/bin/curl http://example/url/300 - @-` with 'body=20' in STDIN 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## releases
2013/10/15 0.0.0 1st release
