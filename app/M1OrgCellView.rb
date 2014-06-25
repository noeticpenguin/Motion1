class M1OrgCellView < NSTableCellView
  extend IB

  outlet :progressIndicator, NSProgressIndicator
  outlet :removeButton, NSButton
  outlet :subTitleTextField, NSTextField

  attr_accessor :subTitleTextField, 
                :progressIndicator, 
                :isSmallSize

  def layoutViewsForSmallSize(smallSize, animated:animated)
    if (@isSmallSize != smallSize) then
      @isSmallSize = smallSize

      targetAlpha = @isSmallSize ? 0 : 1
      if (animated) then
        removeButton.animator.setAlphaValue(targetAlpha)
        subTitleTextField.animator.setAlphaValue(targetAlpha)
        subTitleTextField.animator.setHidden(@isSmallSize)
      else
        removeButton.setAlphaValue(targetAlpha)
        subTitleTextField.setAlphaValue(targetAlpha)
      end
    end
  end

end
