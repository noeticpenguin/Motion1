class M1OrgInstance < M1Org

  attr_accessor :thumbnailImage, 
                :imageLoading, 
                :fillColor, 
                :fillColorName, 
                :image, 
                :title,
                :webView,
                :endPoint,
                :superFrameSize

  THUMBNAIL_HEIGHT=180.0

  #- (id)initWithFileURL:(NSURL *)fileURL {
  def initWithFileURL(fileURL)
    super
    # App.delegate.mainWindow.webViewMaster.dup
    @title = 'test title'
    return self
  end

  def initWithType(type)
   
    # WebView.alloc.initWithFrame([[0,0],[100,100]], frameName:"foo", groupName:'m1')
    case type
    when "prod"
      @endPoint = "https://login.salesforce.com"
      @fileURL = NSBundle.bundleForClass(AppDelegate).URLForResource('CloudProd', withExtension:'png')
      @title = "Production Instance"
    when "sandbox"
      @endPoint = "https://test.salesforce.com"
      @fileURL = NSBundle.bundleForClass(AppDelegate).URLForResource('CloudSandbox', withExtension:'png')
      @title = "Sandbox Instance"
    when "pre"
      @endPoint = "https://gs0.salesforce.com"
      @fileURL = NSBundle.bundleForClass(AppDelegate).URLForResource('CloudPre', withExtension:'png')
      @title = "Pre-Release Instance"
    else
      @endPoint = "https://login.salesforce.com"
      @fileURL = NSBundle.bundleForClass(AppDelegate).URLForResource('CloudProd', withExtension:'png')
      @title = "Production Instance"
    end
    # append the one/one.app location to the uri endpoint
    @endPoint += "?startURL=/one/one.app"

    @superFrameSize = App.delegate.mainWindow.webViewContainer.frameSize
    @webView = WebView.alloc.initWithFrame([[0,0],[@superFrameSize.width,@superFrameSize.height]], frameName:"m1", groupName:"m1")
    ap "frame size = #{@webView.frameSize.width} x #{@webView.frameSize.height}"
    load
    return self
  end

  def load
    request = NSURLRequest.requestWithURL(NSURL.URLWithString(@endPoint))
    @webView.mainFrame.loadRequest(request)
  end

  def NSViewFrameDidChangeNotification(sender)
    ap "NSViewFrameDidChangeNotification happened"
  end

  # static NSImage *M1thumbnailImageFromImage(NSImage *image) {
  def M1thumbnailImageFromImage(image)
    imageSize = image.size
    imageAspectRatio = imageSize.width / imageSize.height
    # Create a thumbnail image from this image (this part of the slow operation)
    thumbnailSize = NSMakeSize(THUMBNAIL_HEIGHT * imageAspectRatio, THUMBNAIL_HEIGHT)
    @thumbnailImage = NSImage.alloc.initWithSize(thumbnailSize)
    @thumbnailImage.lockFocus
    image.drawInRect(NSMakeRect(0, 0, thumbnailSize.width, thumbnailSize.height), fromRect:NSZeroRect, operation:NSCompositeSourceOver, fraction:1.0)
    @thumbnailImage.unlockFocus

    return @thumbnailImage
  end

  # Lazily load the thumbnail image when requested
  def thumbnailImage
    if (@image != nil && @thumbnailImage == nil)
      # Generate the thumbnail right now, synchronously
      @thumbnailImage = M1thumbnailImageFromImage(@image)
    elsif (@image == nil && !@imageLoading)
      # Load the image lazily
      loadImage
    end
    return @thumbnailImage;
  end

  #- (void)set@thumbnailImage:(NSImage *)img {
  def setThumbnailImage(img)
    @thumbnailImage = img if (img != @thumbnailImage)
  end

  #- (void)loadImage {
  def loadImage
    if (@image == nil && !@imageLoading)
      @imageLoading = true
      image = NSImage.alloc.initWithContentsOfURL(@fileURL)
      if (image != nil)
        thumbnailImage = M1thumbnailImageFromImage(image)
        # We synchronize access to the image/@imageLoading pair of variables
        @imageLoading = false
        @image = image
        @thumbnailImage = thumbnailImage
      else
        @image = NSImage.imageNamed(NSImageNameTrashFull)
      end
    end
  end
end
