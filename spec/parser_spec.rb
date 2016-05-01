require "spec_helper"

describe MdSpec::Parser do
  describe "#parse" do
    context "without code blocks" do
      it { expect(codeblocks).to be_empty }
    end

    context "with a code block" do
      it { expect(srcs).to include /hello world/ }
      it { expect(names).to include "an example" }
      it { expect(langs).to eq ["text"] }
    end

    context "with multiple code blocks" do
      it { expect(srcs).to include /code-1/ }
      it { expect(srcs).to include /code-2/ }
      it { expect(srcs).to include /code-3/ }
      it { expect(names).to include "example-1" }
      it { expect(names).to include "example-2" }
      it { expect(names).to include "example-3" }
      it { expect(langs.uniq).to eq ["ruby", "rb"] }
    end

    let(:codeblocks) { parser.codeblocks }
    let(:srcs) { codeblocks.map(&:src) }
    let(:names) { codeblocks.map(&:name) }
    let(:langs) { codeblocks.map(&:lang) }
  end

  let(:parser) { MdSpec::Parser.new read_markdown }
end
