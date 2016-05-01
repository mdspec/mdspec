module MdSpec
  class Parser
    attr_reader :codeblocks

    def initialize(text)
      @codeblocks = []
      parse text
    end

    private
      attr_reader :last_header

      def parse(text)
        @last_header = nil
        walk ::Kramdown::Document.new(text, :input => "GFM").root
      end

      def walk(node)
        codeblocks.push(codeblock(node)) if node.type == :codeblock
        @last_header = header(node)
        node.children.each {|child| walk child }
      end

      def header(node)
        if node.type == :header
          node.children.first.value
        elsif node.type == :text && node.value.match(/^#/)
          node.value.match(/^#+(.*)/)[1].strip
        elsif node.type == :codeblock
          nil
        else
          last_header
        end
      end

      def codeblock(node)
        ::Struct.new(:src, :name, :lang).new(node.value, last_header, lang(node))
      end

      def lang(node)
        if name = node.attr["class"]
          name.match(/^language-(.*)/)[1]
        else
          "text"
        end
      end
  end
end
