class MainController < NSWindowController
	extend IB

  outlet :webview, WebView
  outlet :w, NSWindow
  attr_accessor :end_point, :window_title

  def generate_login_url end_point
    case end_point
    when "prod"
      @end_point = "https://login.salesforce.com"
      @window_title = "Production Org"
    when "sandbox" 
      @end_point = "https://test.salesforce.com"
      @window_title = "Sandbox Org"
    when "pre"
      @end_point = "https://gs0.salesforce.com"
      @window_title = "Pre-Release Org"
    else
      @end_point = "https://login.salesforce.com"
      @window_title = "Production Org"
    end
    # Per PR-1, i've changed this from retURL to startURL to support SSO 
    @end_point += "?startURL=/one/one.app"
  end

  def init end_point
    generate_login_url end_point
    initWithWindowNibName('MainWindow')
  end

  def windowDidLoad
    load(self)
    w.title = "Motion1 - #{@window_title}"
  end

  def load(sender)
    request = NSURLRequest.requestWithURL(NSURL.URLWithString(@end_point))
    webview.mainFrame.loadRequest(request)
  end



end
