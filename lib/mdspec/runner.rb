module MdSpec
  module Runner
    class << self
      def for(opts)
        const_get(classname(opts[:type])).new(opts)
      end

      def classname(type)
        raise "illegal type" unless /^[a-zA-Z0-9\-]+$/ === type
        type.capitalize.gsub(/-[a-z]/) {|m| m[1..-1].capitalize }
      end
    end
  end
end
