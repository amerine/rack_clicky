require "rack_clicky/version"

module Rack
  class Clicky

    TRACKING_CODE = <<-EOTC 
    <script src="//static.getclicky.com/js" type="text/javascript"></script>
    <script type="text/javascript">try{ clicky.init({{CODE}}); }catch(e){}</script>
    <noscript><p><img alt="Clicky" width="1" height="1" src="//in.getclicky.com/{{CODE}}ns.gif" /></p></noscript>
    EOTC

    def initialize app, site_id, options={}
      @app = app
      @site_id = site_id
    end

    def call env
      dup._call(env)
    end

    def _call env
      status, headers, response = @app.call(env)

      if should_inject_clicky? status, headers, response
        response = inject_tracking(response)
        fix_content_length(headers, response)
      end

      [status, headers, response]
    end

    def should_inject_clicky? status, headers, response
      status == 200 &&
      headers["Content-Type"] &&
      (headers["Content-Type"].include?("text/html") || headers["Content-Type"].include?("application/xhtml"))
    end

    def fix_content_length headers, response
      if headers["Content-Length"]
        length = response.to_ary.inject(0) { |len, part| len + Rack::Utils.bytesize(part) }
        headers['Content-Length'] = length.to_s
      end
    end

    def inject_tracking response, body=""
      response.each { |s| body << s.to_s }
      [body.gsub(/<\/body>/, "#{track_code}\n</body>")]
    end

    def track_code
      TRACKING_CODE.gsub(/\{\{CODE\}\}/, @site_id)
    end
    private :track_code
  end
end
