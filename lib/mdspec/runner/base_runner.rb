module MdSpec::Runner
  class BaseRunner
    def initialize(opts)
      @opts = opts
    end

    protected
      attr_reader :opts

      def sh(cmd, output, opts = {})
        ::IO.popen(cmd, "r+") do |io|
          io.puts opts[:input] unless opts[:input].nil?
          io.close_write
          while line = io.gets
            output.puts line
          end
        end
        $?.to_i # exit status
      end
  end
end
