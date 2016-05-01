module MdSpec::Runner
  class BashRepl < BaseRunner
    WITHIN_KEY = "MDSPEC_WITHIN_MDSPEC"

    def initialize(_)
      super
      @prompt = opts.fetch(:prompt, "$ ")
    end

    def run(codeblock)
      root = { :name => "repl", :childs => [], :flat => true }
      each_with_counter(examples_for(codeblock)) do |example|
        output = ::StringIO.new
        status = sh(example[:cmd], output)
        root[:childs].push(
          :name => "should pass \`$ #{example[:cmd]}\`",
          :result => status === 0 && same?(example[:expected], output.string.split("\n")),
          :output => output.string,
        )
      end
      root
    end

    private
      attr_reader :prompt

      def each_with_counter(items, &b)
        ENV[WITHIN_KEY] = (ENV.fetch(WITHIN_KEY, 0).to_i + 1).to_s
        items.each(&b)
        ENV[WITHIN_KEY] = (ENV[WITHIN_KEY].to_i - 1).to_s
      end

      def examples_for(codeblock)
        codeblock.src.split($/).reduce([]) do |examples, line|
          if line.start_with?(prompt)
            examples.push(:cmd => line[prompt.length..-1], :expected => [])
          else
            examples.last[:expected].push(line) unless examples.empty?
          end
          examples
        end
      end

      def same?(a, b)
        # return false if a.length < b.length
        b.map! {|s| s.uncolorize }
        while not b.empty?
          la = a.shift.split
          lb = b.shift.split
          la.each_with_index {|_, k| return false unless same_word?(la[k], lb[k]) }
        end
        return true
      end

      def same_word?(a, b)
        /^\*{3,}/ === a || a === b
      end
  end
end
