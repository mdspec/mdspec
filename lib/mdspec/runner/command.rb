module MdSpec::Runner
  class Command < BaseRunner
    def run(codeblock)
      output = ::StringIO.new
      status = sh(opts[:command], output)
      { :name => "should pass #{opts[:command]}", :result => status === 0 }
    end
  end
end
