class M1Org < NSObject

  attr_accessor :fileURL, :children, :textField, :subTitleTextField
  
  def M1Org.entityForUrl(url)
    typeIdentifier = Pointer.new(:object)
    if (url.getResourceValue(typeIdentifier, forKey:NSURLTypeIdentifierKey, error:NULL))
      imageUTIs = NSImage.imageTypes
      if (imageUTIs.containsObject(typeIdentifier))
        return M1OrgInstance.alloc.initWithFileURL(url)
      elsif (typeIdentifier.isEqualToString(kUTTypeFolder))
        return M1OrgDivider.alloc.initWithFileURL(url)
      end
    end
    return nil;
  end

  def initWithFileURL(fileURL)
    @fileURL = fileURL
  end

  def copyWithZone(zone)
    result = self.class.alloc.initWithFileURL(self.fileURL)
    return result
  end

  def description
    return NSString.stringWithFormat("%@ : %@", super.description, title)
  end

  # def dealloc
  #   super.dealloc
  # end

  def title
    result = Pointer.new(:object)
    return result if (@fileURL.getResourceValue(result, forKey:NSURLLocalizedNameKey, error:nil))
    return nil
  end

  def title=(newTitle)
    @title = newTitle
  end

  def writableTypesForPasteboard(pasteboard)
    return self.fileURL.writableTypesForPasteboard(pasteboard)
  end

  def pasteboardPropertyListForType(type)
    return self.fileURL.pasteboardPropertyListForType(type)
  end

  def writingOptionsForType(type, pasteboard:pasteboard)
    if (self.fileURL.respondsToSelector('writingOptionsForType:pasteboard'))
      return self.fileURL.writingOptionsForType(type, pasteboard:pasteboard)
    else
      return 0
    end
  end

  def M1Org.readableTypesForPasteboard(pasteboard)
    # We allow creation from folder and image URLs only, but there is no way to specify just file URLs that contain images
    return [kUTTypeFolder, kUTTypeFileURL]
  end

  def M1Org.readingOptionsForType(type, pasteboard:pasteboard)
    return NSPasteboardReadingAsString
  end

  def initWithPasteboardPropertyList(propertyList, ofType:type)
    # We only have URLs accepted. Create the URL
    url = NSURL.alloc.initWithPasteboardPropertyList(propertyList, ofType:type)
    # Now see what the data type is; if it isn't an image, we return nil
    urlUTI = Pointer.new(:object)
    if (url.getResourceValue(urlUTI, forKey:NSURLTypeIdentifierKey, error:NULL))
      # We could use UTTypeConformsTo((CFStringRef)type, kUTTypeImage), but we want to make sure it is an image UTI type that NSImage can handle
      if (NSImage.imageTypes.containsObject(urlUTI))
        # We can use it with NSImage
        return M1OrgInstance.alloc.initWithFileURL(url)
      elsif (urlUTI.isEqualToString(kUTTypeFolder))
        # It is a folder
        return M1OrgDivider.alloc.initWithFileURL(url)
      end
    end
    # We may return nil
    return self
  end

  def imageUID
    return NSString.stringWithFormat("%p", self)
  end

  def imageRepresentationType
    return IKImageBrowserNSURLRepresentationType
  end

  def imageRepresentation
    return @fileURL
  end

  def imageVersion
    return 0
  end

  def imageTitle
    return @title
  end

  def imageSubtitle
    return nil
  end

  def isSelectable
    return true
  end

end
