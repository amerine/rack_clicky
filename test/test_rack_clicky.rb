require 'helper'
require 'rack/mock'

class TestRackClicky < Test::Unit::TestCase
  context "Embedding clicky" do
    should "place the tracking code at the end of an HTML request" do
      assert_match EXPECTED_CODE, request.body
    end
    
    should "place the tracking code at the end of an XHTML request" do
      assert_match EXPECTED_CODE, request(:content_type => 'application/xhtml+xml').body
    end
    
    should "not place the tracking code in a non HTML request" do
      assert_no_match EXPECTED_CODE, request(:content_type => 'application/xml', :body => [XML]).body
    end
    
    should "insert the site id" do
      assert_match /clicky\.init\(000000\)/, request.body
    end
    
  end
  
  
  private
  
  EXPECTED_CODE = /<script.*clicky\.init.*<\/script>.*<\/body>/m
  
  SITE_ID = "000000"
  
  HTML = <<-EOHTML
  <html>
    <head>
      <title>Sample Page</title>
    </head>
    <body>
      <h2>Rack::Clicky Test</h2>
      <p>This is more test html</p>
    </body>
  </html>
  EOHTML
  
  XML = <<-EOXML
  <?xml version="1.0" encoding="ISO-8859-1"?>
  <user>
    <name>Mark Turner</name>
    <age>Unknown</age>
  </user>
  EOXML
  
  def request(options={})
    @app = app(options)
    request = Rack::MockRequest.new(@app).get('/')
    yield(@app, request) if block_given?
    request
  end
  
  def app(options={})
    options = options.clone
    options[:content_type] ||= "text/html"
    options[:body]         ||= [HTML]
    rack_app = lambda { |env| [200, { 'Content-Type' => options.delete(:content_type) }, options.delete(:body)] }
    Rack::Clicky.new(rack_app, SITE_ID)
  end
  
end
