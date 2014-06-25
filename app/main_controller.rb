class MainController < NSWindowController
  extend IB

  outlet :tableViewMain, NSTableView
  outlet :useSmallRowHeight, NSButton
  outlet :webViewContainer, NSView
  outlet :webViewMaster, WebView 
  
  attr_accessor :tableContents, 
                :observedVisibleItems, 
                :webViews

  # Constants
  M1EntityPropertyNamedThumbnailImage = "thumbnailImage"

  # Instance Methods

  # def dealloc
  #   @observedVisibleItems.each do |imageEntity|
  #     imageEntity.removeObjserver(self, forKeyPath:M1EntityPropertyNamedThumbnailImage) if imageEntity.class == M1OrgInstance
  #   end
  #   super
  # end

  def windowNibName
    return "M1MainWindow"
  end

  def windowWillLoad
    @tableContents ||= NSMutableArray.new 
    @webViews ||= NSMutableArray.new
  end

  def windowDidLoad
    super
    entity = M1OrgInstance.alloc.initWithType('prod')
    index = @tableViewMain.selectedRow
    if (index == -1)
      if (@tableViewMain.numberOfRows == 0)
        index = 0;
      else
        index = 1;
      end
    end

    production_divider = M1OrgDivider.new
    production_divider.title = "Production"
    @tableContents.insertObject(production_divider, atIndex:index)

    @tableContents.insertObject(entity, atIndex:index+1)

    @webViews = [];
    @tableViewMain.setGridStyleMask(NSTableViewSolidHorizontalGridLineMask)
    @tableViewMain.setFloatsGroupRows(true)
    @tableViewMain.beginUpdates
    @tableViewMain.insertRowsAtIndexes(NSIndexSet.indexSetWithIndex(index), withAnimation:NSTableViewAnimationEffectFade)
    @tableViewMain.scrollRowToVisible(0)
    @tableViewMain.endUpdates
    
    @tableViewMain.setDoubleAction('tblvwDoubleClick:')
    @tableViewMain.setTarget(self)
    @tableViewMain.reloadData
    @tableViewMain.setDraggingSourceOperationMask(NSDragOperationEvery, forLocal:false)
    @useSmallRowHeight = false

  end

   def entityForRow(row)
    return @tableContents.objectAtIndex(row)
  end

  def imageEntityForRow(row)
    result = row != -1 ? @tableContents.objectAtIndex(row) : nil
    return (result.class == M1OrgInstance || result.class == NSKVONotifying_M1OrgInstance) ? result : nil
  end

  ### NSTableView delegate and datasource methods
  def numberOfRowsInTableView(tableview)
    return @tableContents.size rescue 1
  end

  def tablView(tableView, didRemoveRowView:rowView, forRow:row)
    # Stop observing visible things
    imageEntity = rowView.objectValue
    index = imageEntity ? @observedVisibleItems.indexOfObject(imageEntity) : NSNotFound
    if (index != NSNotFound)
      imageEntity.removeObserver(self, forKeyPath:M1EntityPropertyNamedThumbnailImage)
      @observedVisibleItems.removeObjectAtIndex(index)
    end
  end

  def reloadRowForEntity(object)
    row = @tableContents.indexOfObject(object)
    if (row != NSNotFound)
      entity = self.imageEntityForRow(row)
      cellView = @tableViewMain.viewAtColumn(0, row:row, makeIfNecessary:false)
      if (cellView)
        NSAnimationContext.beginGrouping
        NSAnimationContext.currentContext.setDuration(0.8)
        cellView.imageView.setAlphaValue(0)
        cellView.imageView.image = entity.thumbnailImage
        cellView.imageView.setHidden(false)
        cellView.imageView.animator.setAlphaValue(1.0)
        cellView.progessIndicator.setHidden(true)
        NSAnimationContext.endGrouping
      end
    end
  end

  def observeValueForKeyPath(keyPath, ofObject:object, change:change, context:context)
    if(keyPath.isEqualToString:M1EntityPropertyNamedThumbnailImage)
      performSelectorOnMainThread(reloadRowForEntity, withObject:object, waitUntilDone:NO, modes:[arrayWithObject:NSRunLoopCommonModes])
    end
  end

  def tableView(tableView, rowViewForRow:row)
    # Make the row view keep track of our main model object
    result = M1OrgRowView.alloc.initWithFrame(NSMakeRect(0, 0, 100, 100))
    result.objectValue = self.entityForRow(row)
    return result
  end

  def tableView(tableView, isGroupRow:row)
    return (entityForRow(row).class == M1OrgDivider) ? true : false
  end

  def tableView(tableView, viewForTableColumn:tableColumn, row:row)
    entity = entityForRow(row)
    if (entity.class == M1OrgDivider)
      textField = tableView.makeViewWithIdentifier("TextCell", owner:self)
      textField.setStringValue(entity.title)
      return textField
    else
      cellView = tableView.makeViewWithIdentifier("MainCell", owner:self)
      imageEntity = entity # is this needed or is it fodder for refactor?
      cellView.textField.stringValue = entity.title
      cellView.subTitleTextField.stringValue = "foo bar baz"

      # Use KVO to observe for changes of the thumbnail image
      @observedVisibleItems = NSMutableArray.new if (@observedVisibleItems == nil)

      if (!@observedVisibleItems.containsObject(entity))
        imageEntity.addObserver(self, forKeyPath:M1EntityPropertyNamedThumbnailImage, options:0, context:nil)
        imageEntity.loadImage
        @observedVisibleItems.addObject(imageEntity)
      end

      # Hide/show progress based on the thumbnail image being loaded or not.
      if (imageEntity.thumbnailImage == nil)
        cellView.progressIndicator.setHidden(false)
        cellView.progressIndicator.startAnimation(nil)
        cellView.imageView.setHidden(true)
      else
        cellView.imageView.setImage(imageEntity.thumbnailImage)
      end

      # Size/hide things based on the row size
      cellView.layoutViewsForSmallSize(@useSmallRowHeight, animated:false)
      return cellView
    end
  end

  # # We make the "group rows" have the standard height, while all other image rows have a larger height
  def tableView(tableView, heightOfRow:row)
    if(self.entityForRow(row).class == M1OrgDivider)
      return tableView.rowHeight;
    else
      return @useSmallRowHeight ? 30.0 : 75.0;
    end
  end

  def tableViewSelectionDidChange(aNotification)
    ap aNotification
    ap tableViewMain.selectedRow
    
  end

  def tableView(tableView, selectionIndexesForProposedSelection:proposedSelectionIndexes)
    ap "firing tableView:selectionIndexesForProposedSelection"
    ap proposedSelectionIndexes
    return proposedSelectionIndexes
  end

  def splitView(splitView, constrainMinCoordinate:proposedMinimumPosition, ofSubviewAt:dividerIndex)
    NSLog("Inside Splitview:constrainMinCoordinate:ofSubviewAt")
    return 200
  end

  def splitView(splitView, constrainMaxCoordinate:proposedMaximumPosition, ofSubviewAt:dividerIndex)
    NSLog("Inside Splitview:constrainMaxCoordinate:ofSubviewAt")
    # Make sure the view on the right has at least 200 px wide
    splitViewWidth = splitView.bounds.size.width
    return splitViewWidth - 200
  end

  def cellColorViewClicked(sender)
    # Find out what row it was in and edit that color with the popup
    row = @tableViewMain.rowForView(sender)
    self.editColorOnRow(row) if (row != -1)
  end

  #- (IBAction)textTitleChanged:(id)sender {
  def textTitleChanged(sender)
    row = @tableViewMain.rowForView(sender)
    if (row != -1)
      entity = self.imageEntityForRow(row)
      entity.title = sender.stringValue
    end
  end

  #- (IBAction)colorTitleChanged:(id)sender {
  def colorTitleChanged(sender)
    ap "inside colorTileChanged - Don't delete this method."
    row = @tableViewMain.rowForView(sender)
    if (row != -1)
      entity = imageEntityForRow(row)
      entity.fillColorName = sender.stringValue
    end
  end

  #- (void)_selectRowStartingAtRow:(NSInteger)row {
  def selectRowStartingAtRow(row)
    if (@tableViewMain.selectedRow == -1)
      row = 0 if row == -1
      # Select the same or next row (if possible) but skip group rows
      while row < @tableViewMain.numberOfRows
        if (!self.tableView(@tableViewMain, isGroupRow:row)) then
          @tableViewMain.selectRowIndexes(NSIndexSet.indexSetWithIndex(row), byExtendingSelection:false)
          return
        end
        row = row + 1
      end
      row = @tableViewMain.numberOfRows - 1
      while row >= 0
        if (!self.tableView(@tableViewMain, isGroupRow:row)) then
          @tableViewMain.selectRowIndexes(NSIndexSet.indexSetWithIndex(row), byExtendingSelection:false)
          return
        end
        row = row - 1
      end
    end
  end

  def btnRemoveRowClick(sender)
    row = @tableViewMain.rowForView(sender)
    if (row != -1)
      @tableContents.removeObjectAtIndex(row)
      @tableViewMain.removeRowsAtIndexes(NSIndexSet.indexSetWithIndex(row), withAnimation:NSTableViewAnimationEffectFade)
      self.selectRowStartingAtRow(row)
    end
  end

  def btnInsertNewRow(sender)
    case(sender.tag)
    when 1
      type = "prod"
    when 2
      type = "sandbox"
    when 3
      type = "pre"
    else
      type = "prod"
    end

    entity = M1OrgInstance.alloc.initWithType(type)
    index = @tableViewMain.selectedRow
    if (index == -1)
      if (@tableViewMain.numberOfRows == 0)
        index = 0;
      else
        index = 1;
      end
    end

    @tableContents.insertObject(entity, atIndex:index)
    @tableViewMain.beginUpdates
    @tableViewMain.insertRowsAtIndexes(NSIndexSet.indexSetWithIndex(index), withAnimation:NSTableViewAnimationEffectFade)
    @tableViewMain.scrollRowToVisible(index)
    @tableViewMain.endUpdates
  end

  def chkbxUseSmallRowHeightClicked(sender)
    @useSmallRowHeight = (sender.state == 1)
    # Reload the height for all non group rows
    indexesToNoteHeightChanges = NSMutableIndexSet.indexSet
    @tableContents.each_with_index do |row, row_index|
      indexesToNoteHeightChanges.addIndex(row_index) unless row.class == M1OrgDivider
      # We also want to synchronize our own animations with the height change. We do this by creating our own animation grouping
      NSAnimationContext.beginGrouping
      NSAnimationContext.currentContext.setDuration(1.5)

      # Update all the current visible views animated in sync with the row heights
      @tableViewMain.enumerateAvailableRowViewsUsingBlock(
        lambda do |rowView, row|
          @tableViewMain.tableColumns.each_with_index do |o, i|
            view = @tableViewMain.viewAtColumn(i, row:row, makeIfNecessary:false)
            if (view && view.instance_of?(M1OrgCellView))
              view.layoutViewsForSmallSize(@useSmallRowHeight, animated:true)
            end
          end
        end
      )
      @tableViewMain.noteHeightOfRowsWithIndexesChanged(indexesToNoteHeightChanges)
      NSAnimationContext.endGrouping
    end
  end

  def tblvwDoubleClick(sender)
    row = @tableViewMain.selectedRow
    if (row != -1)
      entity = entityForRow(row)
    end
  end

  def tableView(tableView, pasteboardWriterForRow:row)
    # Support for us being a dragging source
    return self.entityForRow(row)
  end

end
