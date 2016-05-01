require "mdspec"

module SpecHelper
  def read_markdown(path = descpath)
    File.read(root("../markdown/#{path}.md"))
  end

  def read_block(path = descpath)
    File.read(root("../block/#{path}.txt"))
  end

  private
    def root(path)
      File.expand_path(File.join(__FILE__, path))
    end

    def descpath
      self.class.description.gsub(/ /, "-")
    end
end

RSpec.configure do |c|
  c.include SpecHelper
end
