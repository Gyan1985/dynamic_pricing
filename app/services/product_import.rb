class ProductImport
  def initialize(file)
    @file = file
  end

  def import
    raise NotImplementedError, "#{self.class} must implement the import method"
  end
end