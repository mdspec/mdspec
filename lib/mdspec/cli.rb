module MdSpec
  class CLI
    def initialize(argv)
      parse_options(argv)
      exit 0 if within_mdspec?
      @config = ::YAML.parse(::File.read(".mdspec.yml")).to_ruby
      @global_rules = config.fetch("rules", [])
      normalize! global_rules
      @rules = global_rules

      # load and run markdown
      render argv.map(&load_and_run)
    end

    private
      attr_reader :config
      attr_reader :global_rules
      attr_reader :rules

      def parse_options(argv)
        opts = ::OptionParser.new

        opts.on_tail("--version", "Show version") do
          puts "MdSpec version #{VERSION}"
          exit
        end

        opts.parse!(argv)
      end

      def render(results, level = 0)
        puts ""
        @num = 0
        @ok = 0
        render_results results
        puts ""
        puts "Finished in 1 seconds"
        puts "#{@num} examples, #{@num - @ok} failures"
        puts ""
      end

      def render_results(results, level = 0)
        results.each do |result|
          unless result[:flat]
            print "  " * level
            if result[:childs].nil?
              @num += 1
              @ok += 1 if result[:result]
              if result[:result]
                puts result[:name].colorize(:green)
              else
                puts result[:name].colorize(:red)
              end
            else
              puts result[:name]
            end
          end
          next_level = result[:flat] ? level : level + 1
          render_results result[:childs], next_level unless result[:childs].nil?
        end
      end

      def within_mdspec?
        ENV["MDSPEC_WITHIN_MDSPEC"].to_i >= 2
      end

      def normalize!(rules)
        rules.each do |k, v|
          rules[k] = symbolize({ :pattern => pattern_for(k) }.merge!(v.is_a?(Hash) ? v : { :type => v }))
        end
      end

      def symbolize(hash)
        hash.reduce({}) do |nxt, (k, v)|
          nxt[k.to_sym] = v
          nxt
        end
      end

      def pattern_for(k)
        ::Regexp.compile(k.match(/^\/.*\/$/) ? k[1..-2] : "^#{k}$")
      end

      def load_and_run
        lambda do |path|
          markdown = ::File.read(path)
          local_rules = config.fetch(path, {})
          normalize! local_rules
          @rules = global_rules.merge!(local_rules)

          root = { :name => path, :result => true, :childs => [] }
          Parser.new(markdown).codeblocks.select(&match?).each do |cb|
            block_root = { :name => cb.name, :childs => [] }
            [cb.name, cb.lang].each do |key|
              block_root[:childs].push(run(key, cb)) if match_pattern?(key)
            end
            root[:childs].push(block_root)
          end

          root
        end
      end

      def run(key, codeblock)
        if opts = ruleopts(key)
          Runner.for(opts[1]).run(codeblock)
        end
      end

      def ruleopts(key)
        rules.find {|_, v| v[:pattern] === key }
      end

      def match?
        lambda do |cb|
          match_pattern?(cb.lang) or match_pattern?(cb.name)
        end
      end

      def match_pattern?(item)
        rules.any? {|_, v| v[:pattern] === item }
      end
  end
end
