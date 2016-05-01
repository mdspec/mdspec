module MdSpec::Runner
  class Diff < BaseRunner
    def run(codeblock)
      out = ::StringIO.new
      status = sh(command, out, :input => codeblock.src)
      { :name => "should be #{opts[:diff]}", :result => status === 0 }
    end

    def command
      cmd = []
      cmd << "diff"
      cmd << "--ignore-blank-lines"
      cmd << opts[:diff]
      cmd << "-"
      cmd.join(" ")
    end
  end
end
