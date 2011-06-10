module Rack 
  class Clicky
    
    TRACKING_CODE = <<-EOTC 
    <script src="//static.getclicky.com/js" type="text/javascript"></script>
    <script type="text/javascript">try{ clicky.init({{CODE}}); }catch(e){}</script>
    <noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/{{CODE}}ns.gif" /></p></noscript>
    EOTC
    
    def initialize(app, site_id, options = {})
      @app = app
      @site_id = site_id
    end
    
    def call(env)
      dup._call(env)
    end
    
    def _call(env)
      
      @status, @headers, @response = @app.call(env)
      return [@status, @headers, @response] unless @headers['Content-Type'] =~ /html/

      @headers.delete('Content-Length')
      response = Rack::Response.new([], @status, @headers)
      @response.each do |fragment|
        response.write(inject_tracking(fragment))
      end
      response.finish
    end
    
    def inject_tracking(response)
        response.sub!(/<\/body>/, "#{track_code}\n</body>")
    end
    
    private
    
    def track_code
      TRACKING_CODE.gsub(/\{\{CODE\}\}/, @site_id)
    end
    
  end
end
