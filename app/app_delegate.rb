class AppDelegate
  attr_accessor :array_of_windows, :mainWindow
  
  def applicationDidFinishLaunching(notification)
    buildMenu
    buildWindow

    NSUserDefaults.standardUserDefaults.setBool(TRUE, forKey:"WebKitDeveloperExtras")
    NSUserDefaults.standardUserDefaults.synchronize
  end

  def buildWindow
    @mainWindow  = MainController.alloc.initWithWindowNibName("M1MainWindow")
    @mainWindow.showWindow(self)
  end

end
