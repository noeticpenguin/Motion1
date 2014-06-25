class AppDelegate
  attr_accessor :array_of_windows, :mainWindow
  
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow
  end

  def buildWindow
    @mainWindow  = MainController.alloc.initWithWindowNibName("M1MainWindow")
    @mainWindow.showWindow(self)
  end

end
