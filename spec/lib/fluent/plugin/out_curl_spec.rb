require 'spec_helper'

describe do
  let(:driver) {Fluent::Test::OutputTestDriver.new(Fluent::CurlOutput, 'test.metrics').configure(config)}
  let(:instance) {driver.instance}

  describe 'config' do
    let(:config) {
      %[
  type curl
  curl_command /usr/bin/curl
  url_template  http://example/url/<%= record['field1'] %>
  options_template --data-urlencode 'body=<%= record['field2'] %>'
      ]
    }
    
    context do
      subject {instance.curl_command}
      it{should == '/usr/bin/curl'}
    end

    context do
      subject {instance.url_template}
      it{should == "http://example/url/<%= record['field1'] %>"}
    end

    context do
      subject {instance.options_template}
      it{should == "--data-urlencode 'body=<%= record['field2'] %>'"}
    end

    context do
      subject {instance.body_template}
      it{should == ""}
    end

  end
  
  describe 'emit' do
    let(:record) {{ 'field1' => 300, 'field2' => 20, 'otherfield' => -30}}
    let(:time) {0}
    let(:posted) {
      d = driver
      mock(IO).popen("/usr/bin/curl http://example/url/300 --data-urlencode 'body=20'", 'w').times 1
      #mock(Kernel).exec("/usr/bin/curl http://example/url/300 --data-urlencode 'body=20'").times 1

      d.emit(record, Time.at(time))
      d.run  
    }

    context 'exist custom_determine_color_code' do
      let(:config) {
        %[
  type curl
  curl_command /usr/bin/curl
  url_template  http://example/url/<%= record['field1'] %>
  options_template  --data-urlencode 'body=<%= record['field2'] %>'
        ]
      }
      
      subject {posted}
      it{should_not be_nil}

    end
  end

end
