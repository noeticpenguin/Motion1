class AppDelegate
  attr_accessor :array_of_windows
  
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow = MainController.alloc.init('prod')
    @mainWindow.showWindow(self)
  end

  def newProductionConnection(sender)
    @array_of_windows = [] if @array_of_windows.nil?
    @array_of_windows << MainController.alloc.init('prod')
    @array_of_windows.last.showWindow(self)
  end

  def newSandboxConnection(sender)
    @array_of_windows = [] if @array_of_windows.nil?
    @array_of_windows << MainController.alloc.init('sandbox')
    @array_of_windows.last.showWindow(self)
  end

  def newPreReleaseConnection(sender)
    @array_of_windows = [] if @array_of_windows.nil?
    @array_of_windows << MainController.alloc.init('pre')
    @array_of_windows.last.showWindow(self)
  end

end
